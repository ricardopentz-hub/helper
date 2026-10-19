# Vercel setup

1) Create a Vercel project (https://vercel.com)
2) Add the following Environment Variables (in Project Settings -> Environment Variables):
   - SUPABASE_URL = your Supabase project URL (e.g., https://xyz.supabase.co)
   - SUPABASE_SERVICE_ROLE_KEY = your Supabase service_role key (secret, server-side only)
   - OPENAI_API_KEY = your OpenAI API key (secret)

3) Deploy the api/ directory as Serverless Functions using Vercel's recommended structure.

Security notes
- The Vercel functions use the service role key to upsert and read data on behalf of authenticated users. The functions must verify the user's JWT before performing operations.
- Do NOT expose SUPABASE_SERVICE_ROLE_KEY to the client.
