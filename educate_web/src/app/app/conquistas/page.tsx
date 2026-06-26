"use client";

import { useEffect, useState } from "react";
import { Trophy, Lock, CheckCircle2, Flame, Star, Award, Medal, ListChecks } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { getAchievements, type Achievement } from "@/lib/gamification";
import { fetchQuizResults } from "@/lib/cloud";

const ICONS: Record<string, React.ElementType> = {
  check: CheckCircle2, fire: Flame, star: Star, trophy: Trophy, medal: Medal, task: ListChecks,
};

export default function ConquistasPage() {
  const { profile, session } = useAuth();
  const [items, setItems] = useState<Achievement[]>([]);

  useEffect(() => {
    async function load() {
      let totalCorrect = 0, totalQuestions = 0, bestAccuracy = 0;
      if (session) {
        const results = await fetchQuizResults(session.user.id, 100);
        for (const r of results) {
          totalCorrect += r.correct_answers;
          totalQuestions += r.total_questions;
          const acc = r.total_questions > 0 ? r.correct_answers / r.total_questions : 0;
          if (acc > bestAccuracy) bestAccuracy = acc;
        }
      }
      setItems(
        getAchievements({
          totalCorrect,
          totalQuestions: totalQuestions || (profile?.total_questions ?? 0),
          totalQuizzes: profile?.total_quizzes ?? 0,
          streak: profile?.streak ?? 0,
          bestAccuracy,
        })
      );
    }
    load();
  }, [session, profile]);

  const unlocked = items.filter((a) => a.unlocked).length;

  return (
    <div className="animate-fade-up space-y-6">
      <h1 className="font-display text-3xl text-ink">Conquistas</h1>

      <div className="flex items-center gap-4 rounded-[20px] bg-brand-gradient p-5 text-white shadow-tinted">
        <Trophy size={40} />
        <div>
          <p className="text-lg font-bold">{unlocked} de {items.length} conquistas</p>
          <p className="text-sm text-white/80">{unlocked === items.length && items.length > 0 ? "Você desbloqueou tudo!" : "Continue estudando para desbloquear mais"}</p>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4 sm:grid-cols-3">
        {items.map((a) => {
          const Icon = a.unlocked ? (ICONS[a.icon] ?? Award) : Lock;
          return (
            <div
              key={a.id}
              className={`flex flex-col items-center rounded-[20px] border p-5 text-center ${a.unlocked ? "border-primary/25 bg-surface shadow-soft" : "border-line bg-surface"}`}
            >
              <div className={`grid h-14 w-14 place-items-center rounded-full ${a.unlocked ? "bg-primary/10 text-primary" : "bg-line text-ink-faint"}`}>
                <Icon size={26} />
              </div>
              <p className={`mt-3 text-sm font-bold ${a.unlocked ? "text-ink" : "text-ink-soft"}`}>{a.title}</p>
              <p className="mt-1 text-xs leading-snug text-ink-faint">{a.description}</p>
            </div>
          );
        })}
      </div>
    </div>
  );
}
