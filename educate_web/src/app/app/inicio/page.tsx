"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Flame, Target, Zap, Timer, Layers, CalendarDays, CheckCircle2, RotateCcw, Trophy } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { greeting, levelOf } from "@/lib/gamification";
import { goals, today } from "@/lib/local";
import { fetchQuizResults } from "@/lib/cloud";
import type { QuizResult } from "@/lib/types";
import { Card, Ring, SectionTitle, LevelIcon } from "@/components/ui";
import { Mascot } from "@/components/mascot";

export default function InicioPage() {
  const { profile, session } = useAuth();
  const router = useRouter();
  const [results, setResults] = useState<QuizResult[]>([]);
  const [todayQ, setTodayQ] = useState(0);
  const [todayM, setTodayM] = useState(0);
  const [goalQ, setGoalQ] = useState(20);
  const [goalM, setGoalM] = useState(60);

  useEffect(() => {
    setTodayQ(today.questions());
    setTodayM(today.minutes());
    setGoalQ(goals.getQuestions());
    setGoalM(goals.getMinutes());
    if (session) fetchQuizResults(session.user.id, 3).then(setResults);
  }, [session]);

  const name = (profile?.name ?? "Estudante").split(" ")[0];
  const xp = profile?.xp ?? 0;
  const streak = profile?.streak ?? 0;
  const tier = levelOf(xp);

  const qProg = goalQ > 0 ? Math.min(1, todayQ / goalQ) : 0;
  const mProg = goalM > 0 ? Math.min(1, todayM / goalM) : 0;
  const overall = (qProg + mProg) / 2;
  const done = qProg >= 1 && mProg >= 1;

  const totalQ = profile?.total_questions ?? 0;

  const actions = [
    { label: "Simulado", icon: Zap, color: "text-primary", bg: "bg-primary/10", href: "/app/simulado" },
    { label: "Cronômetro", icon: Timer, color: "text-indigo", bg: "bg-indigo/10", href: "/app/pomodoro" },
    { label: "Flashcards", icon: Layers, color: "text-accent", bg: "bg-accent/10", href: "/app/flashcards" },
    { label: "Agenda", icon: CalendarDays, color: "text-streak", bg: "bg-streak/10", href: "/app/agenda" },
  ];

  return (
    <div className="animate-fade-up space-y-6">

      <div className="flex items-center justify-between">
        <div>
          <p className="font-semibold text-ink-soft">{greeting()},</p>
          <h1 className="font-display text-3xl text-ink">{name}</h1>
        </div>
        <div className="flex items-center gap-2 rounded-full border-2 border-line bg-surface px-3 py-2">
          <LevelIcon name={tier.icon} size={15} className="text-primary" />
          <span className="font-display text-sm text-primary">{xp} XP</span>
        </div>
      </div>

      <div className="rounded-[20px] bg-brand-gradient p-6 text-white shadow-tinted">
        <div className="flex items-center gap-5">
          <Ring progress={overall}>
            <div>
              <div className="text-lg font-extrabold leading-none">{Math.round(overall * 100)}%</div>
              <div className="text-[10px] text-white/70">hoje</div>
            </div>
          </Ring>
          <div className="flex-1">
            <h2 className="text-lg font-bold">{done ? "Meta de hoje batida!" : "Meta de hoje"}</h2>
            <div className="mt-3 space-y-2.5">
              <GoalLine icon={<Target size={15} />} label={`${todayQ} de ${goalQ} questões`} progress={qProg} />
              <GoalLine icon={<Timer size={15} />} label={`${todayM} de ${goalM} min de estudo`} progress={mProg} />
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <Card className="p-4">
          <div className="flex items-center gap-2">
            <Flame className="text-streak" size={22} />
            <span className="text-2xl font-extrabold">{streak}</span>
          </div>
          <p className="mt-1 text-sm text-ink-soft">dias de sequência</p>
        </Card>
        <Card className="p-4">
          <div className="flex items-center gap-2">
            <Trophy className="text-primary" size={22} />
            <span className="text-2xl font-extrabold">{totalQ}</span>
          </div>
          <p className="mt-1 text-sm text-ink-soft">questões resolvidas</p>
        </Card>
      </div>

      <div>
        <SectionTitle>Atalhos</SectionTitle>
        <div className="grid grid-cols-4 gap-3">
          {actions.map((a) => (
            <Card key={a.label} className="p-4" onClick={() => router.push(a.href)}>
              <div className="flex flex-col items-center gap-2">
                <div className={`grid h-11 w-11 place-items-center rounded-2xl ${a.bg}`}>
                  <a.icon className={a.color} size={22} />
                </div>
                <span className="text-center text-[11px] font-semibold leading-tight">{a.label}</span>
              </div>
            </Card>
          ))}
        </div>
      </div>

      <div>
        <SectionTitle action={<Link href="/app/conquistas" className="text-sm font-semibold text-primary">Conquistas</Link>}>
          Atividade recente
        </SectionTitle>
        {results.length === 0 ? (
          <Card className="flex flex-col items-center gap-2 px-6 py-8 text-center">
            <Mascot size={120} floaty />
            <p className="font-display text-xl text-ink">Comece seu primeiro simulado</p>
            <p className="font-semibold text-ink-faint">Seu progresso vai aparecer aqui.</p>
            <Link href="/app/simulado" className="btn-3d mt-3">Fazer simulado</Link>
          </Card>
        ) : (
          <div className="space-y-3">
            {results.map((r) => {
              const pct = r.total_questions > 0 ? Math.round((r.correct_answers / r.total_questions) * 100) : 0;
              const good = pct >= 70;
              return (
                <Card key={r.id} className="flex items-center gap-3 p-4">
                  <div className={`grid h-11 w-11 place-items-center rounded-xl ${good ? "bg-success/10" : "bg-warning/10"}`}>
                    {good ? <CheckCircle2 className="text-success" size={22} /> : <RotateCcw className="text-warning" size={22} />}
                  </div>
                  <div className="flex-1">
                    <p className="font-semibold">{r.title}</p>
                    <p className="text-xs text-ink-faint">{r.correct_answers}/{r.total_questions} acertos</p>
                  </div>
                  <span className={`text-lg font-extrabold ${good ? "text-success" : "text-warning"}`}>{pct}%</span>
                </Card>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

function GoalLine({ icon, label, progress }: { icon: React.ReactNode; label: string; progress: number }) {
  return (
    <div>
      <div className="mb-1 flex items-center gap-1.5 text-[12.5px] font-medium">
        {icon} {label}
      </div>
      <div className="h-1.5 w-full overflow-hidden rounded-full bg-white/25">
        <div className="h-full rounded-full bg-white transition-[width] duration-500" style={{ width: `${progress * 100}%` }} />
      </div>
    </div>
  );
}
