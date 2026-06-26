import { supabase } from "./supabase";
import { today } from "./local";
import { areaToObjective } from "./gamification";
import type { Profile, QuizResult, LeaderboardRow } from "./types";

export async function saveOnboarding(userId: string, args: { name: string; areas: string[]; state: string | null }) {
  const objective = areaToObjective(args.areas[0]);
  const full = { name: args.name.trim(), objective, state: args.state, areas: args.areas, onboarded: true };
  const { error } = await supabase.from("profiles").update(full).eq("id", userId);
  if (error) {
    await supabase.from("profiles").update({ name: args.name.trim(), objective, state: args.state }).eq("id", userId);
  }
  try {
    localStorage.setItem(`onboarded_${userId}`, "1");
  } catch {}
}

export function needsOnboarding(profile: Profile | null, userId: string): boolean {
  if (!profile) return false;
  if (profile.onboarded === true) return false;
  if (profile.areas && profile.areas.length > 0) return false;
  if (typeof window !== "undefined" && localStorage.getItem(`onboarded_${userId}`) === "1") return false;
  return true;
}

export async function fetchProfile(userId: string): Promise<Profile | null> {
  const { data, error } = await supabase.from("profiles").select("*").eq("id", userId).single();
  if (error) return null;
  return data as Profile;
}

export async function updateProfile(userId: string, patch: Partial<Profile>) {
  await supabase.from("profiles").update(patch).eq("id", userId);
}

export async function syncQuizCompletion(args: {
  userId: string;
  title: string;
  totalQuestions: number;
  correctAnswers: number;
  timeSpentSeconds: number;
  answers: boolean[];
  streak: number;
  xpEarned: number;
}) {
  const { userId } = args;

  await supabase.from("quiz_results").insert({
    user_id: userId,
    title: args.title,
    total_questions: args.totalQuestions,
    correct_answers: args.correctAnswers,
    time_spent_seconds: args.timeSpentSeconds,
    answers: args.answers,
  });

  const { data } = await supabase
    .from("profiles")
    .select("total_quizzes, total_questions, xp, study_minutes")
    .eq("id", userId)
    .single();

  if (data) {
    await supabase
      .from("profiles")
      .update({
        total_quizzes: (data.total_quizzes ?? 0) + 1,
        total_questions: (data.total_questions ?? 0) + args.totalQuestions,
        xp: (data.xp ?? 0) + args.xpEarned,
        study_minutes: (data.study_minutes ?? 0) + Math.floor(args.timeSpentSeconds / 60),
        streak: args.streak,
      })
      .eq("id", userId);
  }

  const t = new Date();
  const dateStr = `${t.getFullYear()}-${String(t.getMonth() + 1).padStart(2, "0")}-${String(t.getDate()).padStart(2, "0")}`;
  await supabase.from("study_days").upsert(
    { user_id: userId, study_date: dateStr },
    { onConflict: "user_id,study_date" }
  );

  today.add(args.totalQuestions, Math.floor(args.timeSpentSeconds / 60));
}

export async function fetchQuizResults(userId: string, limit = 30): Promise<QuizResult[]> {
  const { data } = await supabase
    .from("quiz_results")
    .select("*")
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(limit);
  return (data ?? []) as QuizResult[];
}

export async function fetchStudyDays(userId: string, lastDays = 120): Promise<string[]> {
  const start = new Date();
  start.setDate(start.getDate() - lastDays);
  const dateStr = `${start.getFullYear()}-${String(start.getMonth() + 1).padStart(2, "0")}-${String(start.getDate()).padStart(2, "0")}`;
  const { data } = await supabase
    .from("study_days")
    .select("study_date")
    .eq("user_id", userId)
    .gte("study_date", dateStr);
  return (data ?? []).map((r: { study_date: string }) => r.study_date);
}

export async function fetchLeaderboard(state?: string | null): Promise<LeaderboardRow[]> {
  const { data, error } = await supabase.rpc("get_leaderboard", {
    page_size: 20,
    page_offset: 0,
    state_filter: state ?? null,
  });
  if (error) throw error;
  return (data ?? []) as LeaderboardRow[];
}
