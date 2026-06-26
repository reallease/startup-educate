"use client";

import { createContext, useContext, useEffect, useState, useCallback, type ReactNode } from "react";
import type { Session } from "@supabase/supabase-js";
import { supabase } from "./supabase";
import { fetchProfile } from "./cloud";
import type { Profile } from "./types";

type AuthState = {
  session: Session | null;
  profile: Profile | null;
  loading: boolean;
  refreshProfile: () => Promise<void>;
  signIn: (email: string, password: string) => Promise<void>;
  signInWithGoogle: () => Promise<void>;
  signUp: (args: { email: string; password: string }) => Promise<void>;
  signOut: () => Promise<void>;
};

const AuthContext = createContext<AuthState | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);

  const loadProfile = useCallback(async (userId: string) => {
    let p = await fetchProfile(userId);

    if (!p) {
      const { data: userData } = await supabase.auth.getUser();
      const u = userData.user;
      if (u) {
        const meta = u.user_metadata ?? {};
        await supabase.from("profiles").upsert(
          {
            id: u.id,
            name: meta.name ?? meta.full_name ?? u.email?.split("@")[0] ?? "Estudante",
            email: u.email ?? "",
            objective: meta.objective ?? "ENEM",
            state: meta.state ?? null,
            xp: 0,
            streak: 1,
            total_quizzes: 0,
            total_questions: 0,
            study_minutes: 0,
          },
          { onConflict: "id" }
        );
        p = await fetchProfile(userId);
      }
    }
    setProfile(p);
  }, []);

  useEffect(() => {
    let active = true;
    supabase.auth.getSession().then(async ({ data }) => {
      if (!active) return;
      setSession(data.session);
      if (data.session) await loadProfile(data.session.user.id);
      setLoading(false);
    });

    const { data: sub } = supabase.auth.onAuthStateChange((_event, newSession) => {
      setSession(newSession);
      if (newSession) loadProfile(newSession.user.id);
      else setProfile(null);
    });

    return () => {
      active = false;
      sub.subscription.unsubscribe();
    };
  }, [loadProfile]);

  const refreshProfile = useCallback(async () => {
    if (session) await loadProfile(session.user.id);
  }, [session, loadProfile]);

  const signIn = useCallback(async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({ email: email.trim(), password });
    if (error) throw error;
  }, []);

  const signInWithGoogle = useCallback(async () => {
    const redirectTo = `${window.location.origin}/auth/callback`;
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: { redirectTo },
    });
    if (error) throw error;
  }, []);

  const signUp = useCallback(async ({ email, password }: { email: string; password: string }) => {
    const { data, error } = await supabase.auth.signUp({ email: email.trim(), password });
    if (error) throw error;

    if (data.user) {
      await supabase.from("profiles").upsert(
        {
          id: data.user.id,
          name: email.split("@")[0],
          email: email.trim(),
          objective: "ENEM",
          xp: 0,
          streak: 1,
          total_quizzes: 0,
          total_questions: 0,
          study_minutes: 0,
        },
        { onConflict: "id" }
      );
    }

    if (!data.session) {
      await supabase.auth.signInWithPassword({ email: email.trim(), password });
    }
  }, []);

  const signOut = useCallback(async () => {
    await supabase.auth.signOut();
    setProfile(null);
  }, []);

  return (
    <AuthContext.Provider value={{ session, profile, loading, refreshProfile, signIn, signInWithGoogle, signUp, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth deve ser usado dentro de AuthProvider");
  return ctx;
}
