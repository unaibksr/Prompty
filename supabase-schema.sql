-- Prompts — Supabase schema
-- Run this in the Supabase SQL editor (Dashboard → SQL → New query), then
-- paste your project URL + anon key into SUPABASE_URL / SUPABASE_ANON_KEY
-- in index.html.

create extension if not exists "pgcrypto";

create table if not exists public.prompts (
  id          uuid        primary key default gen_random_uuid(),
  num         integer     generated always as identity,
  title       text        not null,
  description text        not null default '',
  tags        text[]      not null default '{}',
  created_at  timestamptz not null default now()
);

create index if not exists prompts_created_at_idx
  on public.prompts (created_at desc);

-- Row Level Security.
-- The policies below make the board fully public (anyone with the anon key
-- can read/write/delete). This matches the original offline, no-auth design.
-- For a per-user app, drop these and add authenticated policies that scope
-- rows to auth.uid().
alter table public.prompts enable row level security;

drop policy if exists "Prompts are readable by everyone"   on public.prompts;
drop policy if exists "Prompts are insertable by everyone" on public.prompts;
drop policy if exists "Prompts are updatable by everyone"  on public.prompts;
drop policy if exists "Prompts are deletable by everyone"  on public.prompts;

create policy "Prompts are readable by everyone"
  on public.prompts for select
  using (true);

create policy "Prompts are insertable by everyone"
  on public.prompts for insert
  with check (true);

create policy "Prompts are updatable by everyone"
  on public.prompts for update
  using (true)
  with check (true);

create policy "Prompts are deletable by everyone"
  on public.prompts for delete
  using (true);
