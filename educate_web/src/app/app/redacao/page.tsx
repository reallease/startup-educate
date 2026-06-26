"use client";

import { useState } from "react";
import { Sparkles, Check, AlertCircle, RotateCcw, Send } from "lucide-react";
import { Card, Button, cx } from "@/components/ui";
import { MascotStudying } from "@/components/mascot";

type Competencia = { numero: number; titulo: string; nota: number; comentario: string };
type Resultado = {
  competencias: Competencia[];
  notaTotal: number;
  pontosFortes: string[];
  pontosMelhorar: string[];
  comentarioGeral: string;
};

function notaColor(nota: number, max = 200) {
  const p = nota / max;
  if (p >= 0.8) return "text-success";
  if (p >= 0.6) return "text-gold-dark";
  return "text-coral";
}
function barColor(nota: number, max = 200) {
  const p = nota / max;
  if (p >= 0.8) return "bg-success";
  if (p >= 0.6) return "bg-gold";
  return "bg-coral";
}

export default function RedacaoPage() {
  const [tema, setTema] = useState("");
  const [texto, setTexto] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<Resultado | null>(null);

  async function corrigir() {
    setError(null);
    setLoading(true);
    try {
      const res = await fetch("/api/corrigir-redacao", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ tema, texto }),
      });
      const data = await res.json();
      if (!res.ok) {
        setError(data?.error ?? "Não foi possível corrigir agora.");
      } else {
        setResult(data as Resultado);
      }
    } catch {
      setError("Erro de conexão. Tente novamente.");
    } finally {
      setLoading(false);
    }
  }

  function reset() {
    setResult(null);
    setError(null);
    setTexto("");
    setTema("");
  }

  if (loading) {
    return (
      <div className="grid min-h-[60vh] place-items-center text-center">
        <div>
          <MascotStudying size={150} floaty />
          <p className="mt-4 font-display text-xl text-ink">Corrigindo sua redação...</p>
          <p className="mt-1 font-semibold text-ink-soft">Isso leva alguns segundos.</p>
        </div>
      </div>
    );
  }

  if (result) {
    const pct = Math.min(1, result.notaTotal / 1000);
    return (
      <div className="animate-fade-up space-y-6">
        <div className="overflow-hidden rounded-[24px] bg-brand-gradient p-7 text-center text-white shadow-tinted">
          <p className="font-semibold text-white/80">Sua nota estimada</p>
          <p className="font-display text-6xl leading-none">{result.notaTotal}</p>
          <p className="mt-1 font-semibold text-white/80">de 1000</p>
          <div className="mx-auto mt-4 h-2.5 max-w-xs overflow-hidden rounded-full bg-white/25">
            <div className="h-full rounded-full bg-white transition-[width] duration-700" style={{ width: `${pct * 100}%` }} />
          </div>
        </div>

        <div className="space-y-3">
          {result.competencias.map((c) => (
            <Card key={c.numero} className="p-5">
              <div className="mb-2 flex items-start justify-between gap-3">
                <h3 className="font-display text-lg text-ink">Competência {c.numero}</h3>
                <span className={cx("font-display text-xl", notaColor(c.nota))}>{c.nota}<span className="text-sm text-ink-faint">/200</span></span>
              </div>
              <p className="mb-2 text-sm font-bold text-ink-soft">{c.titulo}</p>
              <div className="mb-3 h-2 overflow-hidden rounded-full bg-line">
                <div className={cx("h-full rounded-full", barColor(c.nota))} style={{ width: `${(c.nota / 200) * 100}%` }} />
              </div>
              <p className="font-semibold leading-relaxed text-ink-soft">{c.comentario}</p>
            </Card>
          ))}
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <Card className="p-5">
            <h3 className="mb-3 font-display text-lg text-success">Pontos fortes</h3>
            <ul className="space-y-2">
              {result.pontosFortes.map((p, i) => (
                <li key={i} className="flex items-start gap-2 font-semibold text-ink-soft">
                  <Check size={18} className="mt-0.5 shrink-0 text-success" /> {p}
                </li>
              ))}
            </ul>
          </Card>
          <Card className="p-5">
            <h3 className="mb-3 font-display text-lg text-gold-dark">O que melhorar</h3>
            <ul className="space-y-2">
              {result.pontosMelhorar.map((p, i) => (
                <li key={i} className="flex items-start gap-2 font-semibold text-ink-soft">
                  <AlertCircle size={18} className="mt-0.5 shrink-0 text-gold-dark" /> {p}
                </li>
              ))}
            </ul>
          </Card>
        </div>

        <Card className="p-5">
          <h3 className="mb-2 font-display text-lg text-ink">Comentário geral</h3>
          <p className="font-semibold leading-relaxed text-ink-soft">{result.comentarioGeral}</p>
        </Card>

        <Button variant="grass" onClick={reset} className="w-full">
          <RotateCcw size={18} /> Corrigir outra redação
        </Button>
      </div>
    );
  }

  return (
    <div className="animate-fade-up space-y-6">
      <div className="flex items-center gap-4">
        <MascotStudying size={84} />
        <div>
          <h1 className="font-display text-3xl text-ink">Correção de redação</h1>
          <p className="font-semibold text-ink-soft">Receba sua nota nas 5 competências do ENEM.</p>
        </div>
      </div>

      <Card className="space-y-4 p-5">
        <div>
          <label className="mb-1.5 block font-bold text-ink">Tema da redação</label>
          <input
            value={tema}
            onChange={(e) => setTema(e.target.value)}
            placeholder="Ex.: Desafios para a valorização da educação no Brasil"
            className="w-full rounded-xl border-2 border-line bg-surface px-4 py-3 font-semibold text-ink outline-none focus:border-primary"
          />
        </div>
        <div>
          <div className="mb-1.5 flex items-center justify-between">
            <label className="font-bold text-ink">Sua redação</label>
            <span className={cx("text-sm font-bold", texto.trim().length < 200 ? "text-ink-faint" : "text-success")}>
              {texto.trim().length < 200 ? `${texto.trim().length} / 200 mínimo` : `${texto.length} caracteres`}
            </span>
          </div>
          <textarea
            value={texto}
            onChange={(e) => setTexto(e.target.value)}
            rows={14}
            placeholder="Escreva ou cole sua redação dissertativo-argumentativa aqui..."
            className="w-full resize-y rounded-xl border-2 border-line bg-surface px-4 py-3 font-semibold leading-relaxed text-ink outline-none focus:border-primary"
          />
        </div>

        {error && (
          <p className="flex items-center gap-2 rounded-2xl bg-coral/10 px-4 py-3 text-sm font-bold text-coral">
            <AlertCircle size={18} /> {error}
          </p>
        )}

        <Button onClick={corrigir} disabled={texto.trim().length < 200} className="w-full py-4 text-lg">
          <Sparkles size={20} /> Corrigir minha redação
        </Button>
        {texto.trim().length < 200 ? (
          <p className="text-center text-xs font-bold text-ink-faint">
            Escreva pelo menos 200 caracteres (~3 linhas) para liberar a correção.
          </p>
        ) : (
          <p className="text-center text-xs font-semibold text-ink-faint">
            A correção por IA é uma estimativa para treino e não substitui a banca oficial.
          </p>
        )}
      </Card>
    </div>
  );
}
