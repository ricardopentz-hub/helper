const { createClient } = require('@supabase/supabase-js')
const { createRemoteJWKSet, jwtVerify, SignJWT } = require('jose')

const SUPABASE_URL = process.env.SUPABASE_URL
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
const APPLE_CLIENT_ID = process.env.APPLE_CLIENT_ID // Service ID (client_id) registered with Apple
const VERCEL_JWT_SECRET = process.env.VERCEL_JWT_SECRET // fallback server JWT secret

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('Missing Supabase env vars')
}

const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)
const appleJWKS = createRemoteJWKSet(new URL('https://appleid.apple.com/auth/keys'))

module.exports = async function handler(req, res) {
  try {
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' })

    const { identityToken } = req.body || {}
    if (!identityToken) return res.status(400).json({ error: 'Missing identityToken in body' })

    // Verify Apple's identity token using Apple's JWKS
    let payload
    try {
      const verified = await jwtVerify(identityToken, appleJWKS, {
        issuer: 'https://appleid.apple.com',
        audience: APPLE_CLIENT_ID
      })
      payload = verified.payload
    } catch (err) {
      console.error('Apple token verification failed', err)
      return res.status(401).json({ error: 'Invalid Apple identity token' })
    }

    const appleSub = payload.sub
    const email = payload.email || null

    if (!appleSub) return res.status(400).json({ error: 'Apple token missing sub claim' })

    // Upsert a profile row in Supabase (profiles table) mapping apple_sub -> profile record
    // NOTE: This uses a `profiles` table described in docs/SUPABASE_SCHEMA.sql. If you prefer to use auth.users directly,
    // we can adapt this to call Supabase Admin auth APIs. Using a profiles table avoids touching auth.users and is simpler.

    // Try to find existing profile
    const { data: existingProfiles, error: selectErr } = await supabaseAdmin
      .from('profiles')
      .select('*')
      .eq('apple_sub', appleSub)
      .limit(1)

    if (selectErr) {
      console.error('Error querying profiles', selectErr)
      // continue - we may still attempt to insert
    }

    let profile = (existingProfiles && existingProfiles[0]) || null

    if (!profile) {
      const insertPayload = {
        apple_sub: appleSub,
        email: email,
        created_at: new Date().toISOString()
      }
      const { data: inserted, error: insertErr } = await supabaseAdmin
        .from('profiles')
        .insert(insertPayload)
        .select()
        .limit(1)

      if (insertErr) {
        console.error('Error inserting profile', insertErr)
        return res.status(500).json({ error: 'Failed to create profile' })
      }
      profile = inserted[0]
    }

    // Attempt to find a corresponding Supabase auth user by email (best-effort). If a user exists, return that user id.
    // Note: Creating auth users and issuing Supabase sessions via Admin API can be implemented, but often requires
    // additional config. For the MVP we upsert the profile and return a short-lived server token for client use.

    // Generate a server-signed JWT so the client can call our Vercel endpoints securely (this is a pragmatic fallback).
    // If you want a true Supabase session token returned here, we can implement that next (it may need additional
    // Supabase auth admin API calls and configuration).

    if (!VERCEL_JWT_SECRET) {
      console.warn('VERCEL_JWT_SECRET not set; returning profile without server token')
      return res.status(200).json({ profile })
    }

    const token = await new SignJWT({ sub: profile.id, email: profile.email })
      .setProtectedHeader({ alg: 'HS256' })
      .setIssuedAt()
      .setExpirationTime('24h')
      .sign(Buffer.from(VERCEL_JWT_SECRET, 'utf-8'))

    return res.status(200).json({ token, profile })
  } catch (err) {
    console.error('auth/apple error', err)
    return res.status(500).json({ error: 'Server error' })
  }
}
