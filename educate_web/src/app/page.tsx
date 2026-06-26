import Link from "next/link";
import { Target, Flame, BookOpen, Trophy, Timer, CalendarDays, ArrowRight, Star, Zap, ChevronDown, Sparkles, PenLine, Check } from "lucide-react";
import { Mascot, MascotStudying } from "@/components/mascot";
import { Logo } from "@/components/logo";
import { SiteFooter } from "@/components/site-footer";

const features = [
  { icon: Target, title: "Simulados", desc: "Questões de ENEM e concursos com correção e explicação na hora.", chip: "bg-primary/12 text-primary" },
  { icon: BookOpen, title: "Flashcards", desc: "Memorize fórmulas e conceitos virando cartões interativos.", chip: "bg-sky/12 text-sky" },
  { icon: Flame, title: "Sequências", desc: "Estude todo dia e mantenha sua ofensiva acesa.", chip: "bg-streak/15 text-streak" },
  { icon: Timer, title: "Modo foco", desc: "Cronômetro Pomodoro para estudar sem distração.", chip: "bg-coral/12 text-coral" },
  { icon: Trophy, title: "Ranking", desc: "Dispute o topo do Brasil e do seu estado.", chip: "bg-gold/20 text-gold-dark" },
  { icon: CalendarDays, title: "Agenda", desc: "Veja seu histórico e nunca perca o ritmo.", chip: "bg-grass/15 text-grass-dark" },
];

const steps = [
  { n: "1", t: "Escolha seu objetivo", d: "ENEM, concurso público ou carreira militar." },
  { n: "2", t: "Estude um pouco por dia", d: "Simulados curtos, flashcards e metas diárias." },
  { n: "3", t: "Veja sua evolução", d: "Ganhe XP, suba de nível e mantenha a sequência." },
];

const faqs = [
  { q: "O Educate é gratuito?", a: "Sim! Você cria sua conta e estuda de graça, sem pegadinha." },
  { q: "Serve para qual prova?", a: "ENEM, vestibulares, concursos públicos e carreiras militares. Você escolhe seu objetivo no cadastro e o conteúdo se adapta." },
  { q: "Preciso instalar alguma coisa?", a: "Não. O Educate funciona direto no navegador, tanto no computador quanto no celular." },
  { q: "Como funciona o ranking?", a: "Você ganha XP estudando e disputa o topo do Brasil e do seu estado com outros estudantes — uma motivação a mais pra manter o ritmo." },
  { q: "Meus dados estão seguros?", a: "Sim. Levamos privacidade a sério e você controla seus dados. Confira nossa Política de Privacidade." },
];

export default function Landing() {
  return (
    <main className="bg-mesh min-h-screen overflow-hidden">

      <header className="sticky top-0 z-30 border-b border-line/70 bg-bg/80 backdrop-blur-md">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-5 py-3">
          <div className="flex items-center">
            <Logo variant="horizontal" height={34} />
          </div>
          <div className="flex items-center gap-2">
            <Link href="/login" className="hidden rounded-2xl px-4 py-2 font-bold text-ink-soft transition hover:text-ink sm:block">
              Entrar
            </Link>
            <Link href="/cadastro" className="btn-3d text-sm">Começar grátis</Link>
          </div>
        </div>
      </header>

      <section className="mx-auto grid max-w-6xl items-center gap-8 px-5 pt-10 pb-16 lg:grid-cols-2 lg:pt-16">
        <div className="animate-fade-up text-center lg:text-left">
          <div className="mx-auto mb-5 inline-flex items-center gap-2 rounded-full border-2 border-line bg-surface px-4 py-1.5 text-sm font-bold text-ink-soft lg:mx-0">
            <Star size={15} className="text-gold" /> +10 mil questões resolvidas por estudantes
          </div>
          <h1 className="font-display text-5xl leading-[1.02] text-ink sm:text-6xl">
            Estude jogando.
            <br />
            <span className="text-primary">Conquiste</span> sua vaga.
          </h1>
          <p className="mx-auto mt-5 max-w-md text-lg font-semibold text-ink-soft lg:mx-0">
            Simulados, flashcards e metas diárias para você estudar com foco e ver sua evolução todo dia — do jeito mais leve.
          </p>
          <div className="mt-8 flex flex-col items-center gap-3 sm:flex-row lg:justify-start">
            <Link href="/cadastro" className="btn-3d w-full px-8 py-4 text-lg sm:w-auto">
              Começar agora <ArrowRight size={20} />
            </Link>
            <Link href="/login" className="btn-3d-light w-full px-8 py-4 text-lg sm:w-auto">
              Já tenho conta
            </Link>
          </div>
        </div>

        <div className="relative grid place-items-center">
          <div className="absolute h-72 w-72 rounded-full bg-primary/10 blur-3xl" />
          <div className="relative">
            <Mascot size={300} floaty />

            <div className="absolute -left-4 top-10 flex items-center gap-2 rounded-2xl border-2 border-line bg-surface px-3 py-2 shadow-soft animate-bobble">
              <Flame className="text-streak" size={20} /> <span className="font-display text-sm">7 dias!</span>
            </div>
            <div className="absolute -right-2 top-28 flex items-center gap-2 rounded-2xl border-2 border-line bg-surface px-3 py-2 shadow-soft animate-floaty">
              <Zap className="text-gold" size={20} /> <span className="font-display text-sm">+120 XP</span>
            </div>
            <div className="absolute bottom-6 left-2 flex items-center gap-2 rounded-2xl border-2 border-line bg-surface px-3 py-2 shadow-soft animate-bobble">
              <Trophy className="text-primary" size={20} /> <span className="font-display text-sm">Top 3 SP</span>
            </div>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-12">
        <div className="grid gap-4 sm:grid-cols-3">
          {steps.map((s) => (
            <div key={s.n} className="card-pop p-6">
              <div className="grid h-11 w-11 place-items-center rounded-2xl bg-brand-gradient font-display text-lg text-white">{s.n}</div>
              <h3 className="mt-4 font-display text-xl text-ink">{s.t}</h3>
              <p className="mt-1 font-semibold text-ink-soft">{s.d}</p>
            </div>
          ))}
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-14">
        <h2 className="text-center font-display text-4xl text-ink">Tudo para você passar</h2>
        <p className="mt-2 text-center text-lg font-semibold text-ink-soft">Ferramentas que mantêm o estudo leve e constante.</p>
        <div className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {features.map((f) => (
            <div key={f.title} className="card-pop p-6 transition hover:-translate-y-1">
              <div className={`grid h-12 w-12 place-items-center rounded-2xl ${f.chip}`}>
                <f.icon size={24} />
              </div>
              <h3 className="mt-4 font-display text-xl text-ink">{f.title}</h3>
              <p className="mt-1 font-semibold leading-relaxed text-ink-soft">{f.desc}</p>
            </div>
          ))}
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-16">
        <div className="flex flex-col items-center text-center">
          <MascotStudying size={150} floaty className="mb-2" />
          <span className="inline-flex items-center gap-1.5 rounded-full border-2 border-line bg-surface px-4 py-1.5 text-sm font-bold text-primary">
            <Sparkles size={15} /> Em breve no Educate
          </span>
          <h2 className="mt-4 font-display text-4xl text-ink sm:text-5xl">Sua redação corrigida do seu jeito</h2>
          <p className="mx-auto mt-3 max-w-xl text-lg font-semibold text-ink-soft">
            Escreva, envie e receba sua nota nas 5 competências do ENEM — pela nossa IA na hora, ou por corretores humanos de verdade.
          </p>
        </div>

        <div className="mt-10 grid gap-5 md:grid-cols-2">

          <div className="card-pop p-7">
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-2xl bg-primary/10 text-primary"><Sparkles size={24} /></div>
              <div>
                <h3 className="font-display text-2xl text-ink">Correção por IA</h3>
                <span className="text-sm font-bold text-primary">Resultado na hora</span>
              </div>
            </div>
            <ul className="mt-5 space-y-3">
              {["Nota nas 5 competências, igual ao ENEM", "Feedback detalhado explicando cada nota", "Quantas redações você quiser, quando quiser"].map((b) => (
                <Bullet key={b}>{b}</Bullet>
              ))}
            </ul>
          </div>

          <div className="card-pop relative overflow-hidden p-7">
            <span className="absolute right-5 top-6 rounded-full bg-gold/20 px-3 py-1 text-xs font-bold text-gold-dark">Premium</span>
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-2xl bg-grass/15 text-grass-dark"><PenLine size={24} /></div>
              <div>
                <h3 className="font-display text-2xl text-ink">Correção humana</h3>
                <span className="text-sm font-bold text-grass-dark">Por corretores de verdade</span>
              </div>
            </div>
            <ul className="mt-5 space-y-3">
              {["Corretores especialistas em redação", "Comentários linha a linha no seu texto", "Aquele olhar humano que faz a diferença"].map((b) => (
                <Bullet key={b}>{b}</Bullet>
              ))}
            </ul>
          </div>
        </div>

        <div className="mt-6 flex flex-wrap items-center justify-center gap-x-3 gap-y-2 rounded-2xl bg-primary/[0.06] px-6 py-5 text-center font-bold text-ink-soft">
          <span>Você envia a redação</span>
          <ArrowRight size={18} className="text-primary" />
          <span>o Educate escolhe pelo seu plano</span>
          <ArrowRight size={18} className="text-primary" />
          <span className="text-primary">IA na hora ou corretor humano</span>
        </div>
      </section>

      <section className="mx-auto max-w-3xl px-5 py-14">
        <h2 className="text-center font-display text-4xl text-ink">Perguntas frequentes</h2>
        <div className="mt-10 space-y-3">
          {faqs.map((f) => (
            <details key={f.q} className="card-pop group p-5 [&_summary]:list-none">
              <summary className="flex cursor-pointer items-center justify-between gap-4 font-display text-lg text-ink">
                {f.q}
                <ChevronDown size={20} className="shrink-0 text-ink-soft transition group-open:rotate-180" />
              </summary>
              <p className="mt-3 font-semibold leading-relaxed text-ink-soft">{f.a}</p>
            </details>
          ))}
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-16">
        <div className="bg-brand-gradient relative overflow-hidden rounded-[32px] px-8 py-14 text-center shadow-tinted">
          <div className="absolute -right-6 -top-6 opacity-90">
            <Mascot size={150} className="rotate-12" />
          </div>
          <h2 className="font-display text-4xl text-white sm:text-5xl">Bora começar hoje?</h2>
          <p className="mx-auto mt-3 max-w-md text-lg font-semibold text-white/85">
            Crie sua conta de graça e faça seu primeiro simulado em menos de um minuto.
          </p>
          <Link href="/cadastro" className="btn-3d is-gold mt-8 px-8 py-4 text-lg">
            Quero estudar agora <ArrowRight size={20} />
          </Link>
        </div>
      </section>

      <SiteFooter />
    </main>
  );
}

function Bullet({ children }: { children: React.ReactNode }) {
  return (
    <li className="flex items-start gap-3">
      <span className="mt-0.5 grid h-5 w-5 shrink-0 place-items-center rounded-full bg-grass/15 text-grass-dark">
        <Check size={13} strokeWidth={3} />
      </span>
      <span className="font-semibold text-ink-soft">{children}</span>
    </li>
  );
}
