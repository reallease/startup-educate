  -- ============================================
  -- EDUCATE APP - Supabase Schema
  -- ============================================

  -- 1. TABELA DE PERFIS (profiles)
  -- Vinculada ao auth.users via id
  create table if not exists profiles (
    id uuid references auth.users(id) on delete cascade primary key,
    name text not null,
    email text not null,
    objective text default 'ENEM',
    xp integer default 0,
    streak integer default 0,
    total_quizzes integer default 0,
    total_questions integer default 0,
    study_minutes integer default 0,
    avatar_url text,
    created_at timestamp with time zone default now(),
    updated_at timestamp with time zone default now()
  );

  -- 2. TABELA DE RESULTADOS DE QUIZ (quiz_results)
  create table if not exists quiz_results (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references profiles(id) on delete cascade not null,
    title text not null,
    total_questions integer not null,
    correct_answers integer not null,
    time_spent_seconds integer not null,
    answers boolean[] not null default '{}',
    created_at timestamp with time zone default now()
  );

  create index idx_quiz_results_user on quiz_results(user_id);
  create index idx_quiz_results_created on quiz_results(user_id, created_at desc);

  -- 3. TABELA DE DIAS DE ESTUDO (study_days)
  create table if not exists study_days (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references profiles(id) on delete cascade not null,
    study_date text not null,
    minutes_studied integer default 0,
    quizzes_completed integer default 0,
    created_at timestamp with time zone default now(),
    unique(user_id, study_date)
  );

  create index idx_study_days_user on study_days(user_id);
  create index idx_study_days_date on study_days(study_date);

  -- 4. TABELA DE FLASHCARDS DOMINADOS (flashcard_progress)
  create table if not exists flashcard_progress (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references profiles(id) on delete cascade not null,
    flashcard_id text not null,
    mastered_at timestamp with time zone default now(),
    unique(user_id, flashcard_id)
  );

  create index idx_flashcard_user on flashcard_progress(user_id);


  -- ============================================
  -- ROW LEVEL SECURITY (RLS)
  -- ============================================

  -- Habilitar RLS em todas as tabelas
  alter table profiles enable row level security;
  alter table quiz_results enable row level security;
  alter table study_days enable row level security;
  alter table flashcard_progress enable row level security;

  -- PROFILES: cada usuario ve e edita apenas seu perfil
  create policy "Usuarios podem ver seu proprio perfil"
    on profiles for select
    using (auth.uid() = id);

  create policy "Usuarios podem inserir seu perfil"
    on profiles for insert
    with check (auth.uid() = id);

  create policy "Usuarios podem atualizar seu perfil"
    on profiles for update
    using (auth.uid() = id);

  -- QUIZ RESULTS: cada usuario ve e edita apenas seus resultados
  create policy "Usuarios podem ver seus quiz results"
    on quiz_results for select
    using (auth.uid() = user_id);

  create policy "Usuarios podem inserir seus quiz results"
    on quiz_results for insert
    with check (auth.uid() = user_id);

  create policy "Usuarios podem deletar seus quiz results"
    on quiz_results for delete
    using (auth.uid() = user_id);

  -- STUDY DAYS: cada usuario ve e edita apenas seus dias
  create policy "Usuarios podem ver seus study days"
    on study_days for select
    using (auth.uid() = user_id);

  create policy "Usuarios podem inserir seus study days"
    on study_days for insert
    with check (auth.uid() = user_id);

  create policy "Usuarios podem atualizar seus study days"
    on study_days for update
    using (auth.uid() = user_id);

  -- FLASHCARD PROGRESS: cada usuario ve e edita apenas seus
  create policy "Usuarios podem ver seus flashcards"
    on flashcard_progress for select
    using (auth.uid() = user_id);

  create policy "Usuarios podem inserir seus flashcards"
    on flashcard_progress for insert
    with check (auth.uid() = user_id);

  create policy "Usuarios podem deletar seus flashcards"
    on flashcard_progress for delete
    using (auth.uid() = user_id);


  -- ============================================
  -- FUNCOES E TRIGGERS
  -- ============================================

  -- Trigger para criar perfil automaticamente ao registrar
  create or replace function handle_new_user()
  returns trigger
  language plpgsql
  security definer
  set search_path = public
  as $$
  begin
    insert into profiles (id, name, email, objective, xp, streak)
    values (
      new.id,
      coalesce(new.raw_user_meta_data->>'name', 'Usuario'),
      new.email,
      coalesce(new.raw_user_meta_data->>'objective', 'ENEM'),
      0,
      1
    );
    return new;
  end;
  $$;

  create trigger on_auth_user_created
    after insert on auth.users
    for each row execute procedure handle_new_user();

  -- Funcao para atualizar updated_at
  create or replace function update_updated_at_column()
  returns trigger
  language plpgsql
  as $$
  begin
    new.updated_at = now();
    return new;
  end;
  $$;

  create trigger set_updated_at
    before update on profiles
    for each row execute procedure update_updated_at_column();


  -- ============================================
  -- FUNCOES DE RANKING
  -- ============================================

  -- Funcao para pegar top usuarios por XP
  create or replace function get_leaderboard(
    page_size integer default 10,
    page_offset integer default 0
  )
  returns table (
    name text,
    avatar_url text,
    xp bigint,
    streak integer,
    total_quizzes integer,
    rank bigint
  )
  language sql
  stable
  as $$
    select
      name,
      avatar_url,
      xp,
      streak,
      total_quizzes,
      row_number() over (order by xp desc) as rank
    from profiles
    order by xp desc
    limit page_size
    offset page_offset;
  $$;
