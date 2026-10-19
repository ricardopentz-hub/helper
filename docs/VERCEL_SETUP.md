# Vercel setup (additional env vars for Apple auth)

Add the following Environment Variables to your Vercel project (in addition to the earlier list):

- APPLE_CLIENT_ID: Your Apple Service ID / client_id used to validate the identity token's aud claim.
- VERCEL_JWT_SECRET: A strong secret used to sign short-lived server JWTs returned to clients. Keep this private.

Notes about sessions and Supabase
- This implementation verifies Apple's identity token and upserts a `profiles` row in Supabase. It then issues a server-signed JWT
  that the client can use to call other Vercel endpoints (notes, openai).
- If you want the server to return a native Supabase session (so the client can call Supabase directly with supabase-js),
  additional steps are needed:
  1) Use Supabase Admin auth APIs to create or link an auth.user entry for the Apple identity.
  2) Generate a Supabase session for that user (Supabase does not currently provide a simple create-session API in all setups).
  3) Return the Supabase access token to the client.

I can implement the Supabase-session issuance flow next (Option 2) once you confirm and provide any required Supabase configuration details.
