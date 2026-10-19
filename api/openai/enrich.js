import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = process.env.SUPABASE_URL
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
const OPENAI_API_KEY = process.env.OPENAI_API_KEY

const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export default async function handler(req, res) {
  try {
    const authHeader = req.headers.authorization || ''
    const token = authHeader.replace('Bearer ', '')
    if (!token) return res.status(401).json({ error: 'Missing Authorization' })

    // Verify user
    const userResp = await fetch(`${SUPABASE_URL}/auth/v1/user`, {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (!userResp.ok) return res.status(401).json({ error: 'Invalid token' })
    const user = await userResp.json()

    const { noteId, text } = req.body || {}
    const content = text

    if (!content && !noteId) return res.status(400).json({ error: 'Provide noteId or text' })

    // Prepare OpenAI request (example using Chat Completions)
    const prompt = `Summarize the following user note and suggest up to 5 tags (comma separated):\n\n${content}`

    const openaiResp = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${OPENAI_API_KEY}`
      },
      body: JSON.stringify({
        model: process.env.OPENAI_MODEL || 'gpt-4o-mini',
        messages: [{ role: 'user', content: prompt }],
        max_tokens: 256
      })
    })

    if (!openaiResp.ok) {
      const textErr = await openaiResp.text()
      return res.status(500).json({ error: 'OpenAI error', detail: textErr })
    }

    const openaiData = await openaiResp.json()
    // This parsing depends on model response structure — adjust as needed
    const summary = openaiData?.choices?.[0]?.message?.content || ''

    // Optionally, store enrichment back to Supabase (e.g., a notes_metadata table)
    // For MVP we return the summary to client
    res.status(200).json({ summary })
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Server error' })
  }
}
