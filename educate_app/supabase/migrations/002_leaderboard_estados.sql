-- ============================================
-- EDUCATE APP - Leaderboard corrigido + Ranking por Estado
-- Rode este script no SQL Editor do Supabase (depois do 001)
-- ============================================

-- 1. Coluna de estado (UF) no perfil
alter table profiles add column if not exists state text;

create index if not exists idx_profiles_state on profiles(state);
create index if not exists idx_profiles_xp on profiles(xp desc);

-- 2. Recriar a função de ranking.
-- PROBLEMAS DA VERSÃO ANTIGA:
--   a) Sem "security definer", a RLS fazia o ranking retornar só o próprio usuário.
--   b) Filtro por estado não existia.
drop function if exists get_leaderboard(integer, integer);

create or replace function get_leaderboard(
  page_size integer default 20,
  page_offset integer default 0,
  state_filter text default null
)
returns table (
  name text,
  avatar_url text,
  state text,
  xp integer,
  streak integer,
  total_quizzes integer,
  rank bigint
)
language sql
stable
security definer
set search_path = public
as $$
  select
    p.name,
    p.avatar_url,
    p.state,
    p.xp,
    p.streak,
    p.total_quizzes,
    row_number() over (order by p.xp desc) as rank
  from profiles p
  where state_filter is null or p.state = state_filter
  order by p.xp desc
  limit page_size
  offset page_offset;
$$;

-- Apenas usuários logados podem consultar o ranking
revoke all on function get_leaderboard(integer, integer, text) from public;
grant execute on function get_leaderboard(integer, integer, text) to authenticated;

-- 3. Trigger de novo usuário passa a gravar o estado vindo do cadastro
create or replace function handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into profiles (id, name, email, objective, state, xp, streak)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', 'Usuario'),
    new.email,
    coalesce(new.raw_user_meta_data->>'objective', 'ENEM'),
    new.raw_user_meta_data->>'state',
    0,
    1
  )
  on conflict (id) do nothing;
  return new;
end;
$$;
