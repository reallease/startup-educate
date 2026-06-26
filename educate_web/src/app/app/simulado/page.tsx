"use client";

import { useEffect, useMemo, useRef, useState, Suspense } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Clock, Check, X, ArrowRight, Home, Zap } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { randomQuestions } from "@/lib/content";
import { calculateXP, XP_PER_CORRECT } from "@/lib/gamification";
import { syncQuizCompletion } from "@/lib/cloud";
import type { Question } from "@/lib/types";
import { Button, Card, cx } from "@/components/ui";
import { Mascot } from "@/components/mascot";

function fmt(s: number) {
  const m = Math.floor(s / 60);
  const ss = s % 60;
  return `${String(m).padStart(2, "0")}:${String(ss).padStart(2, "0")}`;
}

function SimuladoInner() {
  const router = useRouter();
  const params = useSearchParams();
  const { session, profile, refreshProfile } = useAuth();

  const title = params.get("title") ?? "Simulado Rápido";
  const subject = params.get("subject");
  const count = parseInt(params.get("count") ?? "10", 10);

  const questions = useMemo<Question[]>(() => randomQuestions(count, subject), [count, subject]);

  const [index, setIndex] = useState(0);
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const [answers, setAnswers] = useState<boolean[]>([]);
  const [seconds, setSeconds] = useState(0);
  const [finished, setFinished] = useState(false);
  const syncedRef = useRef(false);

  useEffect(() => {
    if (finished) return;
    const t = setInterval(() => setSeconds((s) => s + 1), 1000);
    return () => clearInterval(t);
  }, [finished]);

  if (questions.length === 0) {
    return (
      <div className="grid place-items-center py-20 text-center">
        <p className="text-ink-soft">Nenhuma questão disponível para esta matéria.</p>
        <Link href="/app/estudar" className="mt-4 font-semibold text-primary">Voltar</Link>
      </div>
    );
  }

  const q = questions[index];
  const correct = answers.filter(Boolean).length;

  function select(i: number) {
    if (answered) return;
    setSelected(i);
    setAnswered(true);
    setAnswers((a) => [...a, i === q.correctIndex]);
  }

  async function next() {
    if (index + 1 >= questions.length) {
      setFinished(true);
      if (!syncedRef.current && session) {
        syncedRef.current = true;
        const finalCorrect = answers.filter(Boolean).length;
        const xpEarned = finalCorrect * XP_PER_CORRECT;
        try {
          await syncQuizCompletion({
            userId: session.user.id,
            title,
            totalQuestions: answers.length,
            correctAnswers: finalCorrect,
            timeSpentSeconds: seconds,
            answers,
            streak: profile?.streak ?? 1,
            xpEarned,
          });
          await refreshProfile();
        } catch {

        }
      }
    } else {
      setIndex((i) => i + 1);
      setSelected(null);
      setAnswered(false);
    }
  }

  if (finished) {
    const pct = answers.length > 0 ? Math.round((correct / answers.length) * 100) : 0;
    const good = pct >= 70;
    const xp = calculateXP(correct, 0);
    return (
      <div className="animate-fade-up mx-auto max-w-md py-6 text-center">
        <div className="animate-pop mx-auto w-fit"><Mascot size={150} floaty /></div>
        <h1 className="mt-2 font-display text-3xl text-ink">{good ? "Mandou bem!" : "Bom esforço!"}</h1>
        <p className="mt-1 font-semibold text-ink-soft">{title}</p>

        <div className="mt-6 grid grid-cols-3 gap-3">
          <Stat value={`${pct}%`} label="Acerto" />
          <Stat value={`${correct}/${answers.length}`} label="Acertos" />
          <Stat value={fmt(seconds)} label="Tempo" />
        </div>
        <div className="mt-4 inline-flex items-center gap-2 rounded-2xl bg-gold/20 px-5 py-3 font-display text-lg text-gold-dark">
          <Zap size={20} /> +{xp} XP conquistados
        </div>

        <div className="mt-8 flex gap-3">
          <Button variant="light" className="flex-1" onClick={() => router.push("/app/inicio")}>
            <Home size={18} /> Início
          </Button>
          <Button variant="grass" className="flex-1" onClick={() => window.location.reload()}>
            Novo simulado
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="animate-fade-up mx-auto max-w-2xl">

      <div className="mb-5 flex items-center justify-between">
        <Link href="/app/estudar" className="text-ink-soft hover:text-ink"><X size={24} /></Link>
        <div className="flex items-center gap-2 rounded-full bg-surface px-3 py-1.5 text-sm font-semibold shadow-soft">
          <Clock size={16} className="text-primary" /> {fmt(seconds)}
        </div>
      </div>

      <div className="mb-2 flex justify-between text-sm text-ink-soft">
        <span>Questão {index + 1} de {questions.length}</span>
        <span>{correct} acertos</span>
      </div>
      <div className="mb-6 h-2 overflow-hidden rounded-full bg-line">
        <div className="h-full rounded-full bg-primary transition-[width] duration-300" style={{ width: `${((index + (answered ? 1 : 0)) / questions.length) * 100}%` }} />
      </div>

      <Card className="p-6">
        <span className="inline-block rounded-full bg-primary/10 px-3 py-1 text-xs font-bold text-primary">{q.subject}</span>
        <h2 className="mt-4 text-lg font-bold leading-snug">{q.question}</h2>

        <div className="mt-5 space-y-2.5">
          {q.options.map((opt, i) => {
            const isCorrect = i === q.correctIndex;
            const isSelected = i === selected;
            let style = "border-line bg-surface hover:border-primary/40";
            if (answered) {
              if (isCorrect) style = "border-success bg-success/10";
              else if (isSelected) style = "border-danger bg-danger/10";
              else style = "border-line bg-surface opacity-60";
            }
            return (
              <button
                key={i}
                onClick={() => select(i)}
                disabled={answered}
                className={cx("flex w-full items-center gap-3 rounded-2xl border-2 px-4 py-3.5 text-left font-medium transition", style)}
              >
                <span className={cx(
                  "grid h-7 w-7 shrink-0 place-items-center rounded-full text-sm font-bold",
                  answered && isCorrect ? "bg-success text-white" : answered && isSelected ? "bg-danger text-white" : "bg-bg text-ink-soft"
                )}>
                  {answered && isCorrect ? <Check size={16} /> : answered && isSelected ? <X size={16} /> : String.fromCharCode(65 + i)}
                </span>
                <span className="flex-1">{opt}</span>
              </button>
            );
          })}
        </div>

        {answered && (
          <div className="animate-fade-up mt-5 rounded-2xl bg-bg p-4">
            <p className="text-sm font-bold text-ink">Explicação</p>
            <p className="mt-1 text-sm leading-relaxed text-ink-soft">{q.explanation}</p>
          </div>
        )}
      </Card>

      {answered && (
        <div className="animate-fade-up mt-5">
          <Button className="w-full" onClick={next}>
            {index + 1 >= questions.length ? "Ver resultado" : "Próxima questão"} <ArrowRight size={18} />
          </Button>
        </div>
      )}
    </div>
  );
}

function Stat({ value, label }: { value: string; label: string }) {
  return (
    <div className="rounded-2xl bg-surface px-2 py-4 shadow-soft">
      <div className="text-xl font-extrabold text-primary">{value}</div>
      <div className="text-xs text-ink-soft">{label}</div>
    </div>
  );
}

export default function SimuladoPage() {
  return (
    <Suspense fallback={<div className="grid place-items-center py-20"><div className="h-8 w-8 animate-spin rounded-full border-4 border-primary/30 border-t-primary" /></div>}>
      <SimuladoInner />
    </Suspense>
  );
}
