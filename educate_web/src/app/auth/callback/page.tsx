"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { Mascot } from "@/components/mascot";

export default function AuthCallback() {
  const router = useRouter();
  const { session, loading } = useAuth();

  useEffect(() => {
    if (loading) return;
    if (session) {

      if (typeof window !== "undefined" && window.location.hash) {
        window.history.replaceState(null, "", "/auth/callback");
      }
      router.replace("/app/inicio");
    } else {
      const t = setTimeout(() => router.replace("/login"), 3000);
      return () => clearTimeout(t);
    }
  }, [loading, session, router]);

  return (
    <div className="bg-mesh grid min-h-screen place-items-center">
      <div className="text-center">
        <Mascot size={130} floaty />
        <p className="mt-4 font-display text-xl text-ink">Entrando...</p>
      </div>
    </div>
  );
}
