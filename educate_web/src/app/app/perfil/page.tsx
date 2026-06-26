"use client";

import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import { Flame, Zap, FileText, Clock, LogOut, Trophy, MapPin, Save, Medal, Globe } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { levelOf, nextThreshold, progressInLevel, BR_STATES } from "@/lib/gamification";
import { fetchLeaderboard, updateProfile } from "@/lib/cloud";
import { goals } from "@/lib/local";
import type { LeaderboardRow } from "@/lib/types";
import { Card, Button, cx, LevelIcon } from "@/components/ui";

export default function PerfilPage() {
  const { profile, session, signOut, refreshProfile } = useAuth();
  const router = useRouter();

  const [tab, setTab] = useState<"brasil" | "estado">("brasil");
  const [rows, setRows] = useState<LeaderboardRow[] | null>(null);
  const [rankError, setRankError] = useState(false);

  const [editing, setEditing] = useState(false);
  const [name, setName] = useState("");
  const [state, setState] = useState("");
  const [goalQ, setGoalQ] = useState(20);
  const [goalM, setGoalM] = useState(60);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (profile) {
      setName(profile.name ?? "");
      setState(profile.state ?? "");
    }
    setGoalQ(goals.getQuestions());
    setGoalM(goals.getMinutes());
  }, [profile]);

  const loadRank = useCallback(async () => {
    setRows(null);
    setRankError(false);
    try {
      const data = await fetchLeaderboard(tab === "estado" ? profile?.state ?? null : null);
      setRows(data);
    } catch {
      setRankError(true);
    }
  }, [tab, profile?.state]);

  useEffect(() => {
    if (tab === "estado" && !profile?.state) return;
    loadRank();
  }, [loadRank, tab, profile?.state]);

  async function handleSave() {
    if (!session) return;
    setSaving(true);
    goals.setQuestions(goalQ);
    goals.setMinutes(goalM);
    try {
      await updateProfile(session.user.id, { name: name.trim(), state: state || null });
      await refreshProfile();
    } catch {

    }
    setSaving(false);
    setEditing(false);
  }

  async function handleLogout() {
    await signOut();
    router.replace("/login");
  }

  const xp = profile?.xp ?? 0;
  const tier = levelOf(xp);
  const displayName = profile?.name ?? "Estudante";

  return (
    <div className="animate-fade-up space-y-6">

      <div className="overflow-hidden rounded-[24px] bg-brand-gradient p-6 text-white shadow-tinted">
        <div className="flex items-center gap-4">
          <div className="grid h-16 w-16 place-items-center rounded-full bg-white/20 text-2xl font-extrabold">
            {displayName.charAt(0).toUpperCase()}
          </div>
          <div className="min-w-0 flex-1">
            <h1 className="truncate text-xl font-extrabold">{displayName}</h1>
            <p className="truncate text-sm text-white/80">{profile?.email}</p>
            <div className="mt-1 inline-flex items-center gap-1.5 rounded-full bg-white/20 px-3 py-1 text-xs font-semibold">
              <LevelIcon name={tier.icon} size={13} /> {tier.name} · {profile?.objective ?? "ENEM"}
            </div>
          </div>
        </div>
        <div className="mt-5">
          <div className="mb-1 flex justify-between text-xs text-white/80">
            <span>{xp} XP</span>
            <span>Próximo: {nextThreshold(xp)} XP</span>
          </div>
          <div className="h-2 overflow-hidden rounded-full bg-white/25">
            <div className="h-full rounded-full bg-white transition-[width] duration-700" style={{ width: `${progressInLevel(xp) * 100}%` }} />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-4 gap-3">
        <MiniStat icon={<Flame className="text-streak" size={18} />} value={profile?.streak ?? 0} label="Streak" />
        <MiniStat icon={<Zap className="text-primary" size={18} />} value={profile?.total_quizzes ?? 0} label="Simulados" />
        <MiniStat icon={<FileText className="text-primary" size={18} />} value={profile?.total_questions ?? 0} label="Questões" />
        <MiniStat icon={<Clock className="text-primary" size={18} />} value={`${profile?.study_minutes ?? 0}m`} label="Estudo" />
      </div>

      <div>
        <div className="mb-3 flex items-center gap-2">
          <Trophy className="text-primary" size={20} />
          <h2 className="text-[17px] font-bold">Ranking</h2>
        </div>
        <div className="mb-3 flex gap-2">
          <TabBtn active={tab === "brasil"} onClick={() => setTab("brasil")}>
            <Globe size={15} /> Brasil
          </TabBtn>
          <TabBtn active={tab === "estado"} onClick={() => setTab("estado")}>
            <MapPin size={15} /> {profile?.state ? BR_STATES[profile.state] ?? profile.state : "Meu Estado"}
          </TabBtn>
        </div>

        {tab === "estado" && !profile?.state ? (
          <Card className="flex flex-col items-center gap-3 p-6 text-center">
            <MapPin className="text-primary" size={28} />
            <p className="font-semibold">Defina seu estado para ver o ranking regional</p>
            <Button onClick={() => setEditing(true)}>Escolher estado</Button>
          </Card>
        ) : rankError ? (
          <Card className="p-6 text-center text-sm text-ink-soft">
            Não foi possível carregar o ranking agora.
            <br />
            <span className="text-xs text-ink-faint">(Rode a migration 002 no Supabase para ativar o ranking ao vivo.)</span>
          </Card>
        ) : rows === null ? (
          <Card className="grid place-items-center p-10"><div className="h-7 w-7 animate-spin rounded-full border-4 border-primary/30 border-t-primary" /></Card>
        ) : rows.length === 0 ? (
          <Card className="p-6 text-center text-sm text-ink-soft">Ninguém no ranking ainda. Seja o primeiro!</Card>
        ) : (
          <div className="space-y-2">
            {rows.map((r, i) => (
              <Card key={i} className={cx("flex items-center gap-3 p-3", i === 0 && "ring-1 ring-primary/20")}>
                <div className={cx("grid h-9 w-9 place-items-center rounded-full text-sm font-bold", i < 3 ? "bg-primary text-white" : "bg-bg text-ink-soft")}>
                  {i === 0 ? <Medal size={18} /> : i + 1}
                </div>
                <div className="min-w-0 flex-1">
                  <p className="truncate font-semibold">{r.name ?? "Anônimo"}</p>
                  {r.state && <p className="text-xs text-ink-faint">{r.state}</p>}
                </div>
                <span className="font-bold text-primary">{r.xp} XP</span>
              </Card>
            ))}
          </div>
        )}
      </div>

      <div>
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-[17px] font-bold">Configurações</h2>
          {!editing && <button onClick={() => setEditing(true)} className="text-sm font-semibold text-primary">Editar</button>}
        </div>
        {editing ? (
          <Card className="space-y-4 p-5">
            <label className="block">
              <span className="mb-1.5 block text-sm font-semibold">Nome</span>
              <input value={name} onChange={(e) => setName(e.target.value)} className="w-full rounded-xl border border-line px-4 py-3 outline-none focus:border-primary" />
            </label>
            <label className="block">
              <span className="mb-1.5 block text-sm font-semibold">Estado</span>
              <select value={state} onChange={(e) => setState(e.target.value)} className="w-full rounded-xl border border-line bg-surface px-4 py-3 outline-none focus:border-primary">
                <option value="">Selecione</option>
                {Object.entries(BR_STATES).map(([uf, nome]) => <option key={uf} value={uf}>{uf} — {nome}</option>)}
              </select>
            </label>
            <div>
              <div className="mb-1 flex justify-between text-sm"><span className="font-semibold">Meta de questões/dia</span><span className="font-bold text-primary">{goalQ}</span></div>
              <input type="range" min={5} max={100} step={5} value={goalQ} onChange={(e) => setGoalQ(Number(e.target.value))} className="w-full accent-primary" />
            </div>
            <div>
              <div className="mb-1 flex justify-between text-sm"><span className="font-semibold">Meta de minutos/dia</span><span className="font-bold text-primary">{goalM}</span></div>
              <input type="range" min={10} max={180} step={10} value={goalM} onChange={(e) => setGoalM(Number(e.target.value))} className="w-full accent-primary" />
            </div>
            <div className="flex gap-3">
              <Button variant="light" className="flex-1" onClick={() => setEditing(false)}>Cancelar</Button>
              <Button className="flex-1" loading={saving} onClick={handleSave}><Save size={18} /> Salvar</Button>
            </div>
          </Card>
        ) : (
          <Card onClick={handleLogout} className="flex items-center gap-3 p-4 text-danger">
            <LogOut size={20} />
            <span className="font-semibold">Sair da conta</span>
          </Card>
        )}
      </div>
    </div>
  );
}

function MiniStat({ icon, value, label }: { icon: React.ReactNode; value: React.ReactNode; label: string }) {
  return (
    <Card className="flex flex-col items-center gap-1 px-2 py-3 text-center">
      {icon}
      <span className="text-base font-extrabold">{value}</span>
      <span className="text-[10px] text-ink-soft">{label}</span>
    </Card>
  );
}

function TabBtn({ active, onClick, children }: { active: boolean; onClick: () => void; children: React.ReactNode }) {
  return (
    <button
      onClick={onClick}
      className={cx("flex flex-1 items-center justify-center gap-1.5 truncate rounded-xl px-3 py-2.5 text-sm font-semibold transition", active ? "bg-primary text-white shadow-tinted" : "bg-bg text-ink-soft hover:bg-line")}
    >
      {children}
    </button>
  );
}
