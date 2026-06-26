"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { User, MapPin, Check } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { saveOnboarding } from "@/lib/cloud";
import { STUDY_AREAS, BR_STATES } from "@/lib/gamification";
import { Button, cx } from "@/components/ui";
import { MascotStudying } from "@/components/mascot";

export default function OnboardingPage() {
  const router = useRouter();
  const { session, profile, loading, refreshProfile } = useAuth();

  const [name, setName] = useState("");
  const [areas, setAreas] = useState<string[]>([]);
  const [state, setState] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!loading && !session) router.replace("/login");
  }, [loading, session, router]);

  useEffect(() => {
    if (profile?.name && !profile.name.includes("@")) setName((n) => n || profile.name);
    if (profile?.state) setState((s) => s || profile.state || "");
  }, [profile]);

  function toggleArea(id: string) {
    setAreas((prev) => (prev.includes(id) ? prev.filter((a) => a !== id) : [...prev, id]));
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    if (name.trim().length < 3) return setError("Digite seu nome completo.");
    if (areas.length === 0) return setError("Selecione ao menos uma área de estudo.");
    if (!session) return;
    setSaving(true);
    await saveOnboarding(session.user.id, { name, areas, state: state || null });
    await refreshProfile();
    router.replace("/app/inicio");
  }

  if (loading || !session) {
    return (
      <div className="grid min-h-screen place-items-center">
        <div className="h-10 w-10 animate-spin rounded-full border-4 border-primary/30 border-t-primary" />
      </div>
    );
  }

  return (
    <main className="bg-mesh min-h-screen px-5 py-10">
      <div className="mx-auto w-full max-w-xl animate-fade-up">
        <div className="flex flex-col items-center text-center">
          <MascotStudying size={130} floaty />
          <h1 className="mt-2 font-display text-3xl text-ink sm:text-4xl">Vamos personalizar seus estudos</h1>
          <p className="mt-2 font-semibold text-ink-soft">Leva 30 segundos. Isso ajuda a montar seu conteúdo.</p>
        </div>

        <form onSubmit={handleSubmit} className="mt-8 space-y-7">

          <div>
            <label className="mb-1.5 block font-bold text-ink">Como podemos te chamar?</label>
            <span className="flex items-center gap-3 rounded-2xl border-2 border-line bg-surface px-4 py-3.5 transition focus-within:border-primary">
              <User size={18} className="text-ink-faint" />
              <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Seu nome completo" className="w-full bg-transparent font-semibold text-ink outline-none" />
            </span>
          </div>

          <div>
            <label className="mb-1.5 block font-bold text-ink">O que você quer estudar?</label>
            <p className="mb-3 text-sm font-semibold text-ink-faint">Pode escolher mais de uma — ou todas.</p>
            <div className="grid gap-3 sm:grid-cols-2">
              {STUDY_AREAS.map((a) => {
                const active = areas.includes(a.id);
                return (
                  <button
                    type="button"
                    key={a.id}
                    onClick={() => toggleArea(a.id)}
                    className={cx(
                      "flex items-center gap-3 rounded-2xl border-2 p-4 text-left transition",
                      active ? "border-primary bg-primary/10" : "border-line bg-surface hover:border-primary/40"
                    )}
                  >
                    <span className={cx("grid h-7 w-7 shrink-0 place-items-center rounded-lg border-2 transition", active ? "border-primary bg-primary text-white" : "border-line text-transparent")}>
                      <Check size={16} strokeWidth={3} />
                    </span>
                    <span>
                      <span className="block font-display text-lg text-ink">{a.label}</span>
                      <span className="block text-sm font-semibold text-ink-soft">{a.desc}</span>
                    </span>
                  </button>
                );
              })}
            </div>
          </div>

          <div>
            <label className="mb-1.5 block font-bold text-ink">Seu estado (para o ranking)</label>
            <span className="flex items-center gap-3 rounded-2xl border-2 border-line bg-surface px-4 py-3.5 transition focus-within:border-primary">
              <MapPin size={18} className="text-ink-faint" />
              <select value={state} onChange={(e) => setState(e.target.value)} className="w-full bg-transparent font-semibold text-ink outline-none">
                <option value="">Selecione sua UF (opcional)</option>
                {Object.entries(BR_STATES).map(([uf, nome]) => (
                  <option key={uf} value={uf}>{uf} — {nome}</option>
                ))}
              </select>
            </span>
          </div>

          {error && <p className="rounded-2xl bg-coral/10 px-4 py-3 text-sm font-bold text-coral">{error}</p>}

          <Button type="submit" variant="grass" loading={saving} className="w-full py-4 text-lg">Começar a estudar</Button>
        </form>
      </div>
    </main>
  );
}
