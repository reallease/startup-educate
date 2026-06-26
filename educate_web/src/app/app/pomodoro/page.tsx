"use client";

import { useEffect, useRef, useState } from "react";
import { Play, Pause, RotateCcw, SkipForward, Coffee, BookOpen } from "lucide-react";
import { today } from "@/lib/local";
import { Ring } from "@/components/ui";

const WORK = 25 * 60;
const BREAK = 5 * 60;
const LONG_BREAK = 15 * 60;

export default function PomodoroPage() {
  const [isBreak, setIsBreak] = useState(false);
  const [running, setRunning] = useState(false);
  const [remaining, setRemaining] = useState(WORK);
  const [completed, setCompleted] = useState(0);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const phaseTotal = isBreak ? (completed > 0 && completed % 4 === 0 ? LONG_BREAK : BREAK) : WORK;

  useEffect(() => {
    if (!running) return;
    intervalRef.current = setInterval(() => {
      setRemaining((r) => {
        if (r > 1) return r - 1;

        if (!isBreak) {
          const nextCompleted = completed + 1;
          setCompleted(nextCompleted);
          today.add(0, 25);
          setIsBreak(true);
          return (nextCompleted % 4 === 0 ? LONG_BREAK : BREAK);
        } else {
          setIsBreak(false);
          setRunning(false);
          return WORK;
        }
      });
    }, 1000);
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [running, isBreak, completed]);

  function reset() {
    setRunning(false);
    setIsBreak(false);
    setRemaining(WORK);
  }
  function skip() {
    setRunning(false);
    setIsBreak(false);
    setRemaining(WORK);
  }

  const mm = String(Math.floor(remaining / 60)).padStart(2, "0");
  const ss = String(remaining % 60).padStart(2, "0");
  const progress = phaseTotal > 0 ? remaining / phaseTotal : 0;

  return (
    <div className="animate-fade-up mx-auto flex max-w-md flex-col items-center">
      <h1 className="font-display text-3xl text-ink">Cronômetro Pomodoro</h1>

      <div className={`mt-6 inline-flex items-center gap-2 rounded-full px-5 py-2 text-sm font-bold ${isBreak ? "bg-success/12 text-success" : "bg-primary/10 text-primary"}`}>
        {isBreak ? <Coffee size={16} /> : <BookOpen size={16} />}
        {isBreak ? "Hora do intervalo" : "Foco no estudo"}
      </div>

      <div className="my-10">
        <Ring
          progress={progress}
          size={260}
          stroke={14}
          track="var(--color-line)"
          color={isBreak ? "var(--color-success)" : "var(--color-primary)"}
        >
          <div>
            <div className="text-6xl font-extrabold tabular-nums tracking-tight text-ink">{mm}:{ss}</div>
            <div className="mt-1 text-sm text-ink-soft">{isBreak ? "Relaxe um pouco" : "Mantenha o foco"}</div>
          </div>
        </Ring>
      </div>

      <div className="flex items-center gap-6">
        <button onClick={reset} className="grid h-14 w-14 place-items-center rounded-full bg-surface text-ink-soft shadow-soft">
          <RotateCcw size={24} />
        </button>
        <button
          onClick={() => setRunning((r) => !r)}
          className={`grid h-20 w-20 place-items-center rounded-full text-white shadow-tinted ${isBreak ? "bg-success" : "bg-primary"}`}
        >
          {running ? <Pause size={40} /> : <Play size={40} />}
        </button>
        <button onClick={skip} disabled={!isBreak} className="grid h-14 w-14 place-items-center rounded-full bg-surface text-ink-soft shadow-soft disabled:opacity-40">
          <SkipForward size={24} />
        </button>
      </div>

      <div className="mt-10 grid w-full grid-cols-3 gap-px overflow-hidden rounded-2xl bg-line shadow-soft">
        {[
          { v: completed, l: "Pomodoros" },
          { v: completed * 25, l: "Minutos" },
          { v: `${Math.min(100, Math.round((completed / 4) * 100))}%`, l: "Ciclo" },
        ].map((s) => (
          <div key={s.l} className="bg-surface px-2 py-5 text-center">
            <div className="text-2xl font-extrabold text-primary">{s.v}</div>
            <div className="text-xs text-ink-soft">{s.l}</div>
          </div>
        ))}
      </div>
    </div>
  );
}
