# Configuração do Supabase - Educate App

## Por que Supabase?
- **100% gratuito** no tier free (até 500MB DB, 1GB storage, 50k MAU)
- PostgreSQL completo
- Auth com email/senha, Google, GitHub, etc.
- Row Level Security nativo
- Dashboard fácil de usar
- Sem necessidade de configuração complexa de arquivos (vs Firebase)

---

## Passo 1: Criar Projeto
1. Acesse https://supabase.com/signup
2. Crie uma conta (ou use Google/GitHub)
3. Clique em **New Project**
4. Preencha:
   - **Name**: `educate-app`
   - **Database Password**: escolha uma senha forte (GUARDE!)
   - **Region**: `South America (São Paulo)` ou a mais próxima
5. Clique em **Create new project**

---

## Passo 2: Configurar Auth
1. No dashboard, vá em **Authentication** → **Providers**
2. **Email**: já vem ativado por padrão. Clique e:
   - Desative **Confirm email** (para não exigir verificação) OU deixe ativado
   - Salve
3. **Google** (opcional):
   - Clique em **Google** → ative
   - Precisa de Client ID e Secret do Google Cloud Console
   - Authorized redirect: `https://SEU-PROJETO.supabase.co/auth/v1/callback`

---

## Passo 3: Criar Tabelas (SQL)
1. No dashboard, vá em **SQL Editor**
2. Clique em **New query**
3. Cole TODO o conteúdo de `supabase/migrations/001_initial_schema.sql`
4. Clique em **Run**

Isso criará automaticamente:
- `profiles` - dados do usuário
- `quiz_results` - resultados de simulados
- `study_days` - dias de estudo (calendário)
- `flashcard_progress` - flashcards dominados
- Triggers que criam perfil automaticamente ao registrar
- Row Level Security (cada usuário só vê seus dados)

---

## Passo 4: Pegar Credenciais
1. No dashboard, vá em **Project Settings** (ícone engrenagem) → **API**
2. Copie:
   - **Project URL**: `https://xxxxxxxxxxxxx.supabase.co`
   - **anon public**: `eyJhbGciOi...`

---

## Passo 5: Colocar Credenciais no App
1. Abra `lib/config/app_config.dart`
2. Substitua:
```dart
static const String url = 'SUA_SUPABASE_URL';       // Cole o Project URL
static const String anonKey = 'SUA_SUPABASE_ANON_KEY'; // Cole a anon public key
```

---

## Passo 6: Rodar
```bash
flutter pub get
flutter run
```

Pronto! Login e registro já funcionam com banco de dados real.

---

## Estrutura do Banco

```
profiles              (1 por usuário)
├── id (uuid, PK, FK → auth.users)
├── name
├── email
├── objective          (ENEM, Concurso, Militares)
├── xp
├── streak
├── total_quizzes
├── total_questions
├── study_minutes
└── created_at

quiz_results          (N por usuário)
├── id (uuid, PK)
├── user_id (FK → profiles)
├── title
├── total_questions
├── correct_answers
├── time_spent_seconds
├── answers (boolean[])
└── created_at

study_days            (N por usuário)
├── id (uuid, PK)
├── user_id (FK → profiles)
├── study_date (YYYY-M-D)
├── minutes_studied
├── quizzes_completed
└── unique(user_id, study_date)

flashcard_progress    (N por usuário)
├── id (uuid, PK)
├── user_id (FK → profiles)
├── flashcard_id
├── mastered_at
└── unique(user_id, flashcard_id)
```

---

## O que já funciona pronto
- [x] Login com email/senha via Supabase
- [x] Registro com perfil automático (nome, email, objetivo)
- [x] Recuperação de senha por email
- [x] Google Sign-In (se configurado)
- [x] Salvar quiz results no banco
- [x] Buscar resultados do usuário
- [x] Tracking de XP, streak, minutos
- [x] Leaderboard/Ranking
- [x] Flashcard progress persistente
- [x] Calendar com dias estudados
- [x] Row Level Security (dados isolados por usuário)
- [x] Trigger cria perfil ao registrar

---

## URL de Redirecionamento OAuth (se for usar Google)
No Supabase: **Authentication** → **URL Configuration**
- Adicione: `io.supabase.educate://login-callback/`

No `android/app/src/main/AndroidManifest.xml` (intent filter):
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="io.supabase.educate"
        android:host="login-callback" />
</intent-filter>
```

---

## Múltiplos ambientes (dev/prod)
Crie dois arquivos de config:
- `lib/config/app_config.dart` (dev)
- `lib/config/app_config_prod.dart` (prod)

Ou use variáveis de ambiente com `--dart-define`:
```bash
flutter run --dart-define=SUPABASE_URL=sua_url --dart-define=SUPABASE_ANON_KEY=sua_key
```
