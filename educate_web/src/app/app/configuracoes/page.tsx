"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Check, LogOut, Save, UserCog, Palette, Target } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { saveOnboarding } from "@/lib/cloud";
import { STUDY_AREAS, BR_STATES, areaToObjective } from "@/lib/gamification";
import { goals } from "@/lib/local";
import { Card, Button, cx } from "@/components/ui";
import { ThemeSelector } from "@/components/theme-toggle";

export default function ConfiguracoesPage() {
  const { profile, session, signOut, refreshProfile } = useAuth();
  const router = useRouter();

  const [name, setName] = useState("");
  const [state, setState] = useState("");
  const [areas, setAreas] = useState<string[]>([]);
  const [goalQ, setGoalQ] = useState(20);
  const [goalM, setGoalM] = useState(60);
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    if (profile) {
      setName(profile.name ?? "");
      setState(profile.state ?? "");
      setAreas(profile.areas && profile.areas.length > 0 ? profile.areas : [profile.objective === "Concurso Público" ? "Concursos" : profile.objective === "Militares" ? "Militares" : "ENEM"]);
    }
    setGoalQ(goals.getQuestions());
    setGoalM(goals.getMinutes());
  }, [profile]);

  function toggleArea(id: string) {
    setAreas((prev) => (prev.includes(id) ? prev.filter((a) => a !== id) : [...prev, id]));
  }

  async function handleSave() {
    if (!session) return;
    setSaving(true);
    setSaved(false);
    goals.setQuestions(goalQ);
    goals.setMinutes(goalM);
    await saveOnboarding(session.user.id, { name, areas: areas.length ? areas : ["ENEM"], state: state || null });
    await refreshProfile();
    setSaving(false);
    setSaved(true);
    setTimeout(() => setSaved(false), 2500);
  }

  async function handleLogout() {
    await signOut();
    router.replace("/login");
  }

  return (
    <div className="animate-fade-up space-y-6">
      <h1 className="font-display text-3xl text-ink">Configurações</h1>

      <Card className="p-6">
        <div className="mb-4 flex items-center gap-2">
          <UserCog className="text-primary" size={20} />
          <h2 className="font-display text-xl text-ink">Conta</h2>
        </div>

        <label className="mb-1.5 block text-sm font-bold text-ink">Nome completo</label>
        <input value={name} onChange={(e) => setName(e.target.value)} className="mb-4 w-full rounded-xl border-2 border-line bg-surface px-4 py-3 font-semibold text-ink outline-none focus:border-primary" />

        <label className="mb-1.5 block text-sm font-bold text-ink">Áreas de estudo</label>
        <div className="mb-4 grid gap-2 sm:grid-cols-2">
          {STUDY_AREAS.map((a) => {
            const active = areas.includes(a.id);
            return (
              <button
                key={a.id}
                type="button"
                onClick={() => toggleArea(a.id)}
                className={cx("flex items-center gap-2.5 rounded-xl border-2 px-3 py-2.5 text-left font-semibold transition", active ? "border-primary bg-primary/10 text-primary" : "border-line bg-surface text-ink-soft hover:border-primary/40")}
              >
                <span className={cx("grid h-5 w-5 shrink-0 place-items-center rounded-md border-2 transition", active ? "border-primary bg-primary text-white" : "border-line text-transparent")}>
                  <Check size={12} strokeWidth={3} />
                </span>
                {a.label}
              </button>
            );
          })}
        </div>

        <label className="mb-1.5 block text-sm font-bold text-ink">Estado (UF)</label>
        <select value={state} onChange={(e) => setState(e.target.value)} className="w-full rounded-xl border-2 border-line bg-surface px-4 py-3 font-semibold text-ink outline-none focus:border-primary">
          <option value="">Selecione</option>
          {Object.entries(BR_STATES).map(([uf, nome]) => (
            <option key={uf} value={uf}>{uf} — {nome}</option>
          ))}
        </select>
      </Card>

      <Card className="p-6">
        <div className="mb-4 flex items-center gap-2">
          <Palette className="text-primary" size={20} />
          <h2 className="font-display text-xl text-ink">Aparência</h2>
        </div>
        <ThemeSelector />
      </Card>

      <Card className="p-6">
        <div className="mb-4 flex items-center gap-2">
          <Target className="text-primary" size={20} />
          <h2 className="font-display text-xl text-ink">Metas diárias</h2>
        </div>
        <div className="mb-1 flex justify-between text-sm"><span className="font-bold text-ink">Questões por dia</span><span className="font-bold text-primary">{goalQ}</span></div>
        <input type="range" min={5} max={100} step={5} value={goalQ} onChange={(e) => setGoalQ(Number(e.target.value))} className="mb-5 w-full accent-primary" />
        <div className="mb-1 flex justify-between text-sm"><span className="font-bold text-ink">Minutos por dia</span><span className="font-bold text-primary">{goalM}</span></div>
        <input type="range" min={10} max={180} step={10} value={goalM} onChange={(e) => setGoalM(Number(e.target.value))} className="w-full accent-primary" />
      </Card>

      <div className="flex items-center gap-3">
        <Button variant="grass" loading={saving} onClick={handleSave} className="flex-1">
          <Save size={18} /> {saved ? "Salvo!" : "Salvar alterações"}
        </Button>
      </div>

      <Card onClick={handleLogout} className="flex items-center gap-3 p-4 text-danger">
        <LogOut size={20} />
        <span className="font-bold">Sair da conta</span>
      </Card>

      <p className="px-1 text-center text-xs font-semibold text-ink-faint">
        {areas.length > 0 ? `Foco: ${areas.join(", ")} · objetivo principal: ${areaToObjective(areas[0])}` : ""}
      </p>
    </div>
  );
}
