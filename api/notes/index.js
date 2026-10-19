import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = process.env.SUPABASE_URL
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY

const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export default async function handler(req, res) {
  // Simple notes endpoint: supports POST to upsert a note, GET to fetch notes since timestamp
  try {
    const authHeader = req.headers.authorization || ''
    const token = authHeader.replace('Bearer ', '')
    if (!token) return res.status(401).json({ error: 'Missing Authorization' })

    // Verify token and get user info
    const userResp = await fetch(`${SUPABASE_URL}/auth/v1/user`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    if (!userResp.ok) return res.status(401).json({ error: 'Invalid token' })
    const user = await userResp.json()
    const user_id = user.id

    if (req.method === 'POST') {
      const body = req.body
      if (!body?.id || !body?.content) return res.status(400).json({ error: 'Missing id or content' })

      const upsert = await supabaseAdmin
        .from('notes')
        .upsert({ id: body.id, user_id, content: body.content, updated_at: body.updated_at || new Date().toISOString(), is_deleted: body.is_deleted || false })

      if (upsert.error) return res.status(500).json({ error: upsert.error.message })
      return res.status(200).json({ data: upsert.data })
    }

    if (req.method === 'GET') {
      const since = req.query.since || null
      let q = supabaseAdmin.from('notes').select('*').eq('user_id', user_id).neq('is_deleted', true)
      if (since) q = q.gt('updated_at', since)
      const result = await q.order('updated_at', { ascending: false })
      if (result.error) return res.status(500).json({ error: result.error.message })
      return res.status(200).json({ data: result.data })
    }

    return res.status(405).json({ error: 'Method not allowed' })
  } catch (err) {
    console.error(err)
    return res.status(500).json({ error: 'Server error' })
  }
}
