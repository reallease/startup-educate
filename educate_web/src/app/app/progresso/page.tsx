"use client";

import { useEffect, useState } from "react";
import { BarChart, Bar, XAxis, ResponsiveContainer, Cell } from "recharts";
import { Flame, Target, Zap, Clock } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { levelOf, nextThreshold, progressInLevel } from "@/lib/gamification";
import { fetchQuizResults } from "@/lib/cloud";
import type { QuizResult } from "@/lib/types";
import { Card, ProgressBar, SectionTitle, LevelIcon } from "@/components/ui";

const DAYS = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];

export default function ProgressoPage() {
  const { profile, session } = useAuth();
  const [results, setResults] = useState<QuizResult[]>([]);

  useEffect(() => {
    if (session) fetchQuizResults(session.user.id, 100).then(setResults);
  }, [session]);

  const xp = profile?.xp ?? 0;
  const tier = levelOf(xp);
  const totalQuizzes = results.length;
  const totalQuestions = results.reduce((s, r) => s + r.total_questions, 0);
  const totalCorrect = results.reduce((s, r) => s + r.correct_answers, 0);
  const totalMin = Math.round(results.reduce((s, r) => s + r.time_spent_seconds, 0) / 60);
  const accuracy = totalQuestions > 0 ? Math.round((totalCorrect / totalQuestions) * 100) : 0;

  const weekData = Array.from({ length: 7 }, (_, i) => {
    const d = new Date();
    d.setDate(d.getDate() - (6 - i));
    const dayResults = results.filter((r) => {
      const rd = new Date(r.created_at);
      return rd.getFullYear() === d.getFullYear() && rd.getMonth() === d.getMonth() && rd.getDate() === d.getDate();
    });
    return { day: DAYS[d.getDay()], q: dayResults.reduce((s, r) => s + r.total_questions, 0) };
  });

  return (
    <div className="animate-fade-up space-y-6">
      <h1 className="font-display text-3xl text-ink">Progresso</h1>

      <div className="rounded-[20px] bg-brand-gradient p-6 text-white shadow-tinted">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm text-white/80">Nível atual</p>
            <p className="flex items-center gap-2 text-2xl font-extrabold"><LevelIcon name={tier.icon} size={22} /> {tier.name}</p>
          </div>
          <div className="text-right">
            <p className="text-2xl font-extrabold">{xp}</p>
            <p className="text-sm text-white/80">XP</p>
          </div>
        </div>
        <div className="mt-4">
          <div className="mb-1 flex justify-between text-xs text-white/80">
            <span>Próximo nível</span>
            <span>{nextThreshold(xp)} XP</span>
          </div>
          <div className="h-2 overflow-hidden rounded-full bg-white/25">
            <div className="h-full rounded-full bg-white transition-[width] duration-700" style={{ width: `${progressInLevel(xp) * 100}%` }} />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <StatCard icon={<Target className="text-primary" size={20} />} value={`${accuracy}%`} label="Taxa de acerto" />
        <StatCard icon={<Zap className="text-primary" size={20} />} value={totalQuizzes} label="Simulados" />
        <StatCard icon={<Flame className="text-streak" size={20} />} value={profile?.streak ?? 0} label="Sequência" />
        <StatCard icon={<Clock className="text-primary" size={20} />} value={`${totalMin}min`} label="Tempo de estudo" />
      </div>

      <Card className="p-5">
        <SectionTitle>Questões nos últimos 7 dias</SectionTitle>
        {totalQuestions === 0 ? (
          <p className="py-10 text-center text-sm text-ink-faint">Faça simulados para ver sua evolução aqui.</p>
        ) : (
          <div className="h-44">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={weekData}>
                <XAxis dataKey="day" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: "#9ca3af" }} />
                <Bar dataKey="q" radius={[8, 8, 0, 0]} maxBarSize={36}>
                  {weekData.map((_, i) => (
                    <Cell key={i} fill={i === 6 ? "#7c3aed" : "#ddd6fe"} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </Card>

      <Card className="p-5">
        <SectionTitle>Desempenho geral</SectionTitle>
        <div className="space-y-4">
          <PerfLine label="Acertos" value={totalCorrect} total={totalQuestions} />
          <div className="flex justify-between text-sm">
            <span className="text-ink-soft">Total de questões</span>
            <span className="font-bold">{totalQuestions}</span>
          </div>
        </div>
      </Card>
    </div>
  );
}

function StatCard({ icon, value, label }: { icon: React.ReactNode; value: React.ReactNode; label: string }) {
  return (
    <Card className="p-4">
      <div className="flex items-center gap-2">{icon}<span className="text-2xl font-extrabold">{value}</span></div>
      <p className="mt-1 text-sm text-ink-soft">{label}</p>
    </Card>
  );
}

function PerfLine({ label, value, total }: { label: string; value: number; total: number }) {
  return (
    <div>
      <div className="mb-1.5 flex justify-between text-sm">
        <span className="text-ink-soft">{label}</span>
        <span className="font-bold">{value} / {total}</span>
      </div>
      <ProgressBar value={total > 0 ? value / total : 0} />
    </div>
  );
}
