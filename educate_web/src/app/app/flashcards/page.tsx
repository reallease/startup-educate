"use client";

import { useEffect, useMemo, useState } from "react";
import { ArrowLeft, ArrowRight, Check, CheckCircle2, RotateCw } from "lucide-react";
import { FLASHCARDS } from "@/lib/content";
import { masteredCards } from "@/lib/local";
import { cx } from "@/components/ui";

export default function FlashcardsPage() {
  const [subject, setSubject] = useState<string | null>(null);
  const [index, setIndex] = useState(0);
  const [flipped, setFlipped] = useState(false);
  const [mastered, setMastered] = useState<string[]>([]);

  useEffect(() => setMastered(masteredCards.all()), []);

  const subjects = useMemo(() => Array.from(new Set(FLASHCARDS.map((c) => c.subject))), []);
  const cards = useMemo(() => (subject ? FLASHCARDS.filter((c) => c.subject === subject) : FLASHCARDS), [subject]);

  const safeIndex = Math.min(index, cards.length - 1);
  const card = cards[safeIndex];
  const masteredCount = FLASHCARDS.filter((c) => mastered.includes(c.id)).length;
  const isMastered = card ? mastered.includes(card.id) : false;

  function go(delta: number) {
    const next = Math.min(Math.max(safeIndex + delta, 0), cards.length - 1);
    if (next !== safeIndex) {
      setFlipped(false);
      setIndex(next);
    }
  }

  function toggleMastered() {
    if (!card) return;
    const updated = masteredCards.toggle(card.id);
    setMastered(updated);
    if (updated.includes(card.id) && safeIndex < cards.length - 1) {
      setTimeout(() => go(1), 220);
    }
  }

  return (
    <div className="animate-fade-up mx-auto max-w-xl space-y-5">
      <div>
        <h1 className="font-display text-3xl text-ink">Flashcards</h1>
        <div className="mt-2 flex items-center justify-between text-sm">
          <span className="text-ink-soft">{masteredCount} de {FLASHCARDS.length} dominados</span>
          <span className="font-bold text-primary">{Math.round((masteredCount / FLASHCARDS.length) * 100)}%</span>
        </div>
        <div className="mt-1.5 h-2 overflow-hidden rounded-full bg-line">
          <div className="h-full rounded-full bg-primary transition-[width] duration-500" style={{ width: `${(masteredCount / FLASHCARDS.length) * 100}%` }} />
        </div>
      </div>

      <div className="flex gap-2 overflow-x-auto pb-1">
        <Chip label="Todos" active={subject === null} onClick={() => { setSubject(null); setIndex(0); setFlipped(false); }} />
        {subjects.map((s) => (
          <Chip key={s} label={s} active={subject === s} onClick={() => { setSubject(s); setIndex(0); setFlipped(false); }} />
        ))}
      </div>

      {card && (
        <div className="perspective">
          <div
            onClick={() => setFlipped((f) => !f)}
            className="preserve-3d relative h-80 w-full cursor-pointer transition-transform duration-500"
            style={{ transform: flipped ? "rotateY(180deg)" : "rotateY(0deg)" }}
          >

            <div className="backface-hidden absolute inset-0 flex flex-col rounded-3xl border border-line bg-surface p-7 shadow-soft">
              <div className="flex items-center justify-between">
                <span className="rounded-full bg-primary/10 px-3 py-1 text-xs font-bold text-primary">{card.subject}</span>
                {isMastered && <CheckCircle2 className="text-success" size={20} />}
              </div>
              <div className="flex flex-1 items-center justify-center text-center">
                <p className="text-2xl font-bold leading-snug">{card.front}</p>
              </div>
              <p className="flex items-center justify-center gap-1.5 text-xs text-ink-faint"><RotateCw size={14} /> Toque para ver a resposta</p>
            </div>

            <div className="backface-hidden rotate-y-180 absolute inset-0 flex flex-col rounded-3xl bg-brand-gradient p-7 text-white shadow-tinted">
              <p className="text-xs font-bold tracking-widest text-white/70">RESPOSTA</p>
              <div className="flex flex-1 items-center justify-center text-center">
                <p className="text-xl font-semibold leading-relaxed">{card.back}</p>
              </div>
              <p className="text-center text-xs text-white/60">Toque para voltar</p>
            </div>
          </div>
        </div>
      )}

      <p className="text-center text-sm text-ink-faint">{safeIndex + 1} / {cards.length}</p>

      <div className="flex items-center gap-3">
        <button onClick={() => go(-1)} disabled={safeIndex === 0} className="grid h-12 w-12 place-items-center rounded-full bg-surface text-primary shadow-soft disabled:opacity-40">
          <ArrowLeft size={20} />
        </button>
        <button
          onClick={toggleMastered}
          className={cx("flex h-12 flex-1 items-center justify-center gap-2 rounded-2xl font-semibold text-white transition", isMastered ? "bg-success" : "bg-primary shadow-tinted")}
        >
          <Check size={18} /> {isMastered ? "Dominado" : "Dominei"}
        </button>
        <button onClick={() => go(1)} disabled={safeIndex >= cards.length - 1} className="grid h-12 w-12 place-items-center rounded-full bg-surface text-primary shadow-soft disabled:opacity-40">
          <ArrowRight size={20} />
        </button>
      </div>
    </div>
  );
}

function Chip({ label, active, onClick }: { label: string; active: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={cx(
        "shrink-0 rounded-full border px-4 py-2 text-sm font-semibold transition",
        active ? "border-primary bg-primary text-white" : "border-line bg-surface text-ink-soft hover:bg-bg"
      )}
    >
      {label}
    </button>
  );
}
