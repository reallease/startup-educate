"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Mail, Lock, Eye, EyeOff } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { Button, GoogleButton } from "@/components/ui";
import { Mascot } from "@/components/mascot";
import { Logo } from "@/components/logo";

export default function LoginPage() {
  const router = useRouter();
  const { signIn, signInWithGoogle, session } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [show, setShow] = useState(false);
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (session) router.replace("/app/inicio");
  }, [session, router]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      await signIn(email, password);
      router.replace("/app/inicio");
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Erro ao entrar";
      if (msg.includes("Invalid login")) setError("E-mail ou senha incorretos.");
      else if (msg.includes("Email not confirmed")) setError("E-mail não confirmado. Verifique sua caixa de entrada.");
      else setError(msg);
    } finally {
      setLoading(false);
    }
  }

  async function handleGoogle() {
    setError(null);
    setGoogleLoading(true);
    try {
      await signInWithGoogle();

    } catch {
      setError("Não foi possível entrar com Google. Tente novamente.");
      setGoogleLoading(false);
    }
  }

  return (
    <main className="grid min-h-screen lg:grid-cols-2">

      <div className="bg-brand-gradient relative hidden flex-col justify-between overflow-hidden p-12 text-white lg:flex">
        <Link href="/" className="flex items-center">
          <Logo variant="horizontal-white" height={34} />
        </Link>
        <div className="grid place-items-center">
          <Mascot size={240} floaty />
          <h2 className="mt-6 max-w-sm text-center font-display text-4xl leading-tight">Que bom te ver de volta!</h2>
          <p className="mt-3 max-w-sm text-center font-semibold text-white/80">Sua sequência e suas metas esperam por você.</p>
        </div>
        <div className="font-semibold text-white/60">© Educate</div>
      </div>

      <div className="bg-mesh flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-sm animate-fade-up">
          <div className="mb-6 lg:hidden"><Logo variant="horizontal" height={34} /></div>
          <h1 className="font-display text-4xl text-ink">Entrar</h1>
          <p className="mt-2 font-semibold text-ink-soft">Continue de onde parou.</p>

          <div className="mt-7">
            <GoogleButton onClick={handleGoogle} loading={googleLoading} />
          </div>

          <div className="my-5 flex items-center gap-3 text-sm font-bold text-ink-faint">
            <div className="h-px flex-1 bg-line" /> ou <div className="h-px flex-1 bg-line" />
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <Field icon={<Mail size={18} />} label="E-mail">
              <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="seu@email.com" className="w-full bg-transparent font-semibold outline-none" />
            </Field>
            <Field icon={<Lock size={18} />} label="Senha" trailing={
              <button type="button" onClick={() => setShow((s) => !s)} className="text-ink-faint hover:text-ink-soft">
                {show ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            }>
              <input type={show ? "text" : "password"} required value={password} onChange={(e) => setPassword(e.target.value)} placeholder="••••••••" className="w-full bg-transparent font-semibold outline-none" />
            </Field>

            {error && <p className="rounded-2xl bg-coral/10 px-4 py-3 text-sm font-bold text-coral">{error}</p>}

            <Button type="submit" loading={loading} className="w-full py-4 text-lg">Entrar</Button>
          </form>

          <p className="mt-6 text-center font-semibold text-ink-soft">
            Não tem conta?{" "}
            <Link href="/cadastro" className="font-bold text-primary hover:underline">Cadastre-se</Link>
          </p>
        </div>
      </div>
    </main>
  );
}

export function Field({
  icon,
  label,
  trailing,
  children,
}: {
  icon: React.ReactNode;
  label: string;
  trailing?: React.ReactNode;
  children: React.ReactNode;
}) {
  return (
    <label className="block">
      <span className="mb-1.5 block text-sm font-bold text-ink">{label}</span>
      <span className="flex items-center gap-3 rounded-2xl border-2 border-line bg-surface px-4 py-3.5 transition focus-within:border-primary">
        <span className="text-ink-faint">{icon}</span>
        <span className="flex-1">{children}</span>
        {trailing}
      </span>
    </label>
  );
}
