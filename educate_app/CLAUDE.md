# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Sobre o projeto

**Educate** — app Flutter de estudos para vestibulandos (ENEM) e concurseiros no Brasil. Todo o conteúdo, UI e comunicação com o usuário são em **português (pt-BR)**. Backend: Supabase (auth + Postgres com RLS).

## Comandos

```bash
flutter pub get        # instalar dependências
flutter run            # rodar o app (escolha o device)
flutter analyze        # lint/análise estática
flutter test           # rodar testes (test/ existe mas não há testes reais)
```

Não há build_runner, codegen nem flavors. O lint usa `flutter_lints` (analysis_options.yaml padrão). O código legado tem muitos avisos pré-existentes (`withOpacity` deprecado, imports não usados) — não introduza novos, mas não é preciso corrigi-los em massa.

## Arquitetura

### Dois armazenamentos em paralelo (ponto mais importante)

- **`services/storage_service.dart`** — SharedPreferences **local**: streak, resultados de quiz, minutos de estudo, nome/email. É a fonte que as telas Home/Progresso/Vestibulares leem.
- **`services/cloud_storage_service.dart`** — **Supabase**: tabelas `profiles`, `quiz_results`, `study_days`, `flashcard_progress`. As telas Estudar e Perfil leem o `profiles` da nuvem.

O fluxo de conclusão de quiz (`quiz_page.dart` → `_finishQuiz`) salva **primeiro localmente** (`StorageService.saveQuizResult`, que também atualiza o streak) e depois dispara `CloudStorageService.syncQuizCompletion` em segundo plano (fire-and-forget com try/catch — o app precisa funcionar offline). Ao mexer em progresso/XP/streak, mantenha os dois lados consistentes.

### Supabase

- Credenciais em `lib/config/app_config.dart` (anon key hardcoded; segurança vem da RLS).
- Schema completo em `supabase/migrations/001_initial_schema.sql` — precisa ser aplicado manualmente pelo SQL Editor do dashboard (instruções em `SUPABASE_SETUP.md`). Não há CLI do Supabase configurada.
- Trigger `handle_new_user` cria o `profiles` no signup; `auth_service.dart` também tenta inserir manualmente como fallback.
- **Pegadinha de RLS**: as policies de `profiles` só permitem `select` do próprio usuário, então `getLeaderboard()` retorna apenas a própria linha. Corrigir exige mudança no SQL (policy de leitura pública ou função `security definer`).

### Navegação e fluxos

- `main.dart` → `AuthGate`: com sessão Supabase ou nome local salvo → `MainScreen` (4 abas via `IndexedStack`: Home, Estudar, Progresso, Perfil); senão → `LoginScreen`. Navegação por `Navigator.push` direto, sem rotas nomeadas.
- O campo `objective` do profile (`'ENEM'` | `'Concurso Público'` | militares) muda as categorias exibidas na `StudyPage`, que leva a `VestibularScreen`/`ConcursosScreen` → `QuizPage`.
- `features/auth/viewmodel/*.dart` estão vazios (MVVM nunca implementado); `provider` está no pubspec mas não é usado. O padrão real é `StatefulWidget` + services estáticos.

### Conteúdo e gamificação

- Questões são **hardcoded** em `services/question_bank.dart` (~18 questões) e flashcards em `flashcards_page.dart` (16 cards). Migrar para o Supabase é objetivo conhecido do projeto.
- XP: `core/gamification.dart` — `Gamification.xpPerCorrect` (10/acerto) + 5/dia de streak; níveis Iniciante→Gênio (duplicados em `home_page.dart`, `progress_page.dart` e `profile_page.dart`); 8 conquistas calculadas on-the-fly.

### Sistema de design (`lib/core/design.dart`)

Telas novas e refatorações **devem** usar os tokens de `design.dart`: `AppColor` (cores como `Color`), `AppGap` (espaçamento), `AppRadius`, `AppShadow.soft/tinted`, `AppText` (tipografia), o widget `AppCard`, `LevelSystem` (fonte única dos níveis de gamificação) e `fadeRoute()` (transição suave). O `app_colors.dart` antigo (ints) está **obsoleto** — não use. Direção visual: limpo/premium estilo apps de banco (sombras suaves > bordas, bastante respiro, roxo como acento).

## Convenções

- Cor primária roxa `#7C3AED`, Material 3, fundo `#F7F7FB` (via `AppColor`).
- Services são classes com membros `static` (sem injeção de dependência).
- Commits curtos em pt-BR no padrão `feat:`/`chore:`.

## Build Android

O AGP em `android/settings.gradle.kts` precisa ser **≥ 8.9.1** (dependências transitivas do Supabase exigem). Não rebaixe — `flutter build apk` falha em `checkDebugAarMetadata` se voltar para 8.7.x.
