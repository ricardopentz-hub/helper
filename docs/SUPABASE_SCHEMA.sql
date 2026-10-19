-- Supabase schema for Helper app (notes table + RLS policy + profiles table)

-- Create notes table
create table if not exists public.notes (
  id uuid primary key,
  user_id uuid not null,
  content text not null,
  updated_at timestamptz default now(),
  is_deleted boolean default false
);

-- Enable Row Level Security
alter table public.notes enable row level security;

-- Policy: allow authenticated user to insert or update their own rows
create policy "users_can_modify_own_notes" on public.notes
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Index for updated_at to make sync queries efficient
create index if not exists notes_updated_at_idx on public.notes (updated_at desc);

-- Profiles table to map external provider ids (Apple) to app profiles
create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  apple_sub text unique,
  email text,
  created_at timestamptz default now()
);
