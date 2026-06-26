"use client";

import { useEffect, useMemo, useState } from "react";
import { ChevronLeft, ChevronRight, CalendarDays } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { fetchStudyDays, fetchQuizResults } from "@/lib/cloud";
import type { QuizResult } from "@/lib/types";
import { Card } from "@/components/ui";

const WEEK = ["D", "S", "T", "Q", "Q", "S", "S"];
const MONTHS = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];

const key = (d: Date) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;

export default function AgendaPage() {
  const { session } = useAuth();
  const [cursor, setCursor] = useState(() => new Date());
  const [selected, setSelected] = useState(() => new Date());
  const [studyDays, setStudyDays] = useState<Set<string>>(new Set());
  const [results, setResults] = useState<QuizResult[]>([]);

  useEffect(() => {
    if (!session) return;
    fetchStudyDays(session.user.id).then((d) => setStudyDays(new Set(d.map(normalize))));
    fetchQuizResults(session.user.id, 100).then(setResults);
  }, [session]);

  const grid = useMemo(() => {
    const year = cursor.getFullYear();
    const month = cursor.getMonth();
    const first = new Date(year, month, 1);
    const startWeekday = first.getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const cells: (Date | null)[] = [];
    for (let i = 0; i < startWeekday; i++) cells.push(null);
    for (let d = 1; d <= daysInMonth; d++) cells.push(new Date(year, month, d));
    return cells;
  }, [cursor]);

  const selectedActivities = results.filter((r) => {
    const rd = new Date(r.created_at);
    return key(rd) === key(selected);
  });

  const today = new Date();

  return (
    <div className="animate-fade-up space-y-6">
      <div>
        <h1 className="font-display text-3xl text-ink">Agenda</h1>
        <p className="font-semibold text-ink-soft">Acompanhe seus dias de estudo</p>
      </div>

      <Card className="p-5">
        <div className="mb-4 flex items-center justify-between">
          <button onClick={() => setCursor(new Date(cursor.getFullYear(), cursor.getMonth() - 1, 1))} className="grid h-9 w-9 place-items-center rounded-full hover:bg-bg">
            <ChevronLeft size={20} />
          </button>
          <span className="font-bold">{MONTHS[cursor.getMonth()]} {cursor.getFullYear()}</span>
          <button onClick={() => setCursor(new Date(cursor.getFullYear(), cursor.getMonth() + 1, 1))} className="grid h-9 w-9 place-items-center rounded-full hover:bg-bg">
            <ChevronRight size={20} />
          </button>
        </div>

        <div className="mb-2 grid grid-cols-7 text-center text-xs font-semibold text-ink-faint">
          {WEEK.map((w, i) => <div key={i}>{w}</div>)}
        </div>
        <div className="grid grid-cols-7 gap-1">
          {grid.map((d, i) => {
            if (!d) return <div key={i} />;
            const studied = studyDays.has(key(d));
            const isToday = key(d) === key(today);
            const isSelected = key(d) === key(selected);
            return (
              <button
                key={i}
                onClick={() => setSelected(d)}
                className={[
                  "relative mx-auto grid h-10 w-10 place-items-center rounded-full text-sm font-medium transition",
                  isSelected ? "bg-primary text-white" : isToday ? "bg-primary/10 text-primary" : "hover:bg-bg",
                ].join(" ")}
              >
                {d.getDate()}
                {studied && !isSelected && <span className="absolute bottom-1 h-1.5 w-1.5 rounded-full bg-primary" />}
              </button>
            );
          })}
        </div>
      </Card>

      <div>
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-[17px] font-bold">Atividades do dia</h2>
          <span className="text-sm text-ink-soft">{String(selected.getDate()).padStart(2, "0")}/{String(selected.getMonth() + 1).padStart(2, "0")}</span>
        </div>
        {selectedActivities.length === 0 ? (
          <Card className="flex flex-col items-center gap-2 px-6 py-10 text-center">
            <CalendarDays className="text-ink-faint" size={40} />
            <p className="text-ink-soft">Nenhuma atividade neste dia</p>
          </Card>
        ) : (
          <div className="space-y-3">
            {selectedActivities.map((r) => (
              <Card key={r.id} className="flex items-center gap-3 p-4">
                <span className="h-2.5 w-2.5 rounded-full bg-primary" />
                <span className="flex-1 font-medium">{r.title}</span>
                <span className="text-sm font-bold text-primary">{r.correct_answers}/{r.total_questions}</span>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

function normalize(s: string) {

  const [y, m, d] = s.split("-").map((x) => parseInt(x, 10));
  return `${y}-${String(m).padStart(2, "0")}-${String(d).padStart(2, "0")}`;
}
