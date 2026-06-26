"use client";

import Link from "next/link";
import { ChevronRight, Layers, Sparkles } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { Card, SectionTitle } from "@/components/ui";

type Simulado = { title: string; subtitle: string; tags: string[]; difficulty: string; subject?: string; count: number };

const ENEM: Simulado[] = [
  { title: "ENEM Completo", subtitle: "Todas as matérias", tags: ["Geral"], difficulty: "Alta", count: 10 },
  { title: "Matemática", subtitle: "Álgebra, Geometria", tags: ["Matemática"], difficulty: "Média", subject: "Matemática", count: 9 },
  { title: "Linguagens", subtitle: "Português e interpretação", tags: ["Português"], difficulty: "Média", subject: "Português", count: 7 },
  { title: "Ciências da Natureza", subtitle: "Física, Química, Biologia", tags: ["Ciências"], difficulty: "Alta", subject: "Biologia", count: 3 },
  { title: "Ciências Humanas", subtitle: "História e Geografia", tags: ["Humanas"], difficulty: "Média", subject: "História", count: 5 },
  { title: "História", subtitle: "Brasil e mundo", tags: ["História"], difficulty: "Média", subject: "História", count: 5 },
  { title: "Geografia", subtitle: "Brasil e biomas", tags: ["Geografia"], difficulty: "Média", subject: "Geografia", count: 5 },
];

const CONCURSO: Simulado[] = [
  { title: "Simulado Geral", subtitle: "Português, Lógica, Informática", tags: ["Geral"], difficulty: "Média", count: 10 },
  { title: "Português", subtitle: "Gramática e interpretação", tags: ["Português"], difficulty: "Média", subject: "Português", count: 7 },
  { title: "Raciocínio Lógico", subtitle: "Lógica e sequências", tags: ["Lógica"], difficulty: "Alta", subject: "Raciocínio Lógico", count: 2 },
  { title: "Informática", subtitle: "Windows, Office, Internet", tags: ["Informática"], difficulty: "Média", subject: "Informática", count: 4 },
  { title: "Direito Constitucional", subtitle: "CF/88", tags: ["Direito"], difficulty: "Alta", subject: "Direito", count: 3 },
];

function diffColor(d: string) {
  if (d === "Alta") return "bg-danger/10 text-danger";
  if (d === "Média") return "bg-warning/10 text-warning";
  return "bg-success/10 text-success";
}

export default function EstudarPage() {
  const { profile } = useAuth();
  const objective = profile?.objective ?? "ENEM";
  const list = objective === "Concurso Público" ? CONCURSO : ENEM;

  return (
    <div className="animate-fade-up space-y-6">
      <div>
        <h1 className="font-display text-3xl text-ink">Estudar</h1>
        <p className="font-bold text-primary">Objetivo: {objective}</p>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <Link href="/app/simulado?title=Simulado%20R%C3%A1pido&count=10">
          <Card className="flex items-center gap-3 p-4">
            <div className="grid h-11 w-11 place-items-center rounded-2xl bg-primary/10"><Sparkles className="text-primary" size={22} /></div>
            <div>
              <p className="font-bold leading-tight">Simulado rápido</p>
              <p className="text-xs text-ink-soft">10 questões</p>
            </div>
          </Card>
        </Link>
        <Link href="/app/flashcards">
          <Card className="flex items-center gap-3 p-4">
            <div className="grid h-11 w-11 place-items-center rounded-2xl bg-accent/10"><Layers className="text-accent" size={22} /></div>
            <div>
              <p className="font-bold leading-tight">Flashcards</p>
              <p className="text-xs text-ink-soft">Revisão rápida</p>
            </div>
          </Card>
        </Link>
      </div>

      <div>
        <SectionTitle>Simulados</SectionTitle>
        <div className="space-y-3">
          {list.map((s) => {
            const href = `/app/simulado?title=${encodeURIComponent(s.title)}&count=${s.count}${s.subject ? `&subject=${encodeURIComponent(s.subject)}` : ""}`;
            return (
              <Link key={s.title} href={href}>
                <Card className="flex items-center gap-4 p-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <p className="font-bold">{s.title}</p>
                      <span className={`rounded-full px-2 py-0.5 text-[10px] font-bold ${diffColor(s.difficulty)}`}>{s.difficulty}</span>
                    </div>
                    <p className="mt-0.5 text-sm text-ink-soft">{s.subtitle}</p>
                    <p className="mt-1 text-xs text-ink-faint">{s.count} questões</p>
                  </div>
                  <ChevronRight className="text-ink-faint" size={20} />
                </Card>
              </Link>
            );
          })}
        </div>
      </div>
    </div>
  );
}
