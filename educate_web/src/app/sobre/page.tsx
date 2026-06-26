import type { Metadata } from "next";
import Link from "next/link";
import { Target, Heart, Sparkles, Users } from "lucide-react";
import { MarketingHeader } from "@/components/marketing-header";
import { SiteFooter } from "@/components/site-footer";
import { Mascot } from "@/components/mascot";

export const metadata: Metadata = {
  title: "Sobre o Educate",
  description: "Nossa missão é democratizar o acesso a um estudo de qualidade para o ENEM e concursos.",
};

const values = [
  { icon: Target, title: "Foco no que importa", desc: "Estudo objetivo, sem enrolação. Cada minuto conta." },
  { icon: Heart, title: "Acessível a todos", desc: "Educação de qualidade não pode ser privilégio." },
  { icon: Sparkles, title: "Leve e motivador", desc: "Estudar pode ter constância sem perder a graça." },
  { icon: Users, title: "Junto com você", desc: "Construímos o Educate ouvindo estudantes de verdade." },
];

export default function SobrePage() {
  return (
    <main className="min-h-screen bg-bg">
      <MarketingHeader />

      <section className="bg-mesh">
        <div className="mx-auto grid max-w-6xl items-center gap-8 px-5 py-16 lg:grid-cols-2">
          <div className="animate-fade-up">
            <h1 className="font-display text-4xl text-ink sm:text-5xl">Estudar não precisa ser solitário nem chato.</h1>
            <p className="mt-5 text-lg font-semibold leading-relaxed text-ink-soft">
              O Educate nasceu de uma ideia simples: todo estudante brasileiro merece uma forma leve, constante e motivadora
              de se preparar para o ENEM e para os concursos — independente de onde mora ou de quanto pode pagar.
            </p>
            <Link href="/cadastro" className="btn-3d mt-8">Faça parte</Link>
          </div>
          <div className="grid place-items-center">
            <Mascot size={260} floaty />
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 py-16">
        <div className="grid gap-4 sm:grid-cols-3">
          {[
            { n: "48+", l: "questões e crescendo" },
            { n: "27", l: "estados no ranking" },
            { n: "100%", l: "gratuito" },
          ].map((s) => (
            <div key={s.l} className="card-pop p-8 text-center">
              <div className="font-display text-4xl text-primary">{s.n}</div>
              <div className="mt-1 font-semibold text-ink-soft">{s.l}</div>
            </div>
          ))}
        </div>
      </section>

      <section className="mx-auto max-w-6xl px-5 pb-20">
        <h2 className="text-center font-display text-3xl text-ink">No que a gente acredita</h2>
        <div className="mt-10 grid gap-5 sm:grid-cols-2">
          {values.map((v) => (
            <div key={v.title} className="card-pop flex items-start gap-4 p-6">
              <div className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-primary/10 text-primary">
                <v.icon size={24} />
              </div>
              <div>
                <h3 className="font-display text-xl text-ink">{v.title}</h3>
                <p className="mt-1 font-semibold text-ink-soft">{v.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      <SiteFooter />
    </main>
  );
}
