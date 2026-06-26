"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Mail, Lock } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { Button, GoogleButton } from "@/components/ui";
import { Field } from "@/app/login/page";
import { Mascot } from "@/components/mascot";
import { Logo } from "@/components/logo";

export default function CadastroPage() {
  const router = useRouter();
  const { signUp, signInWithGoogle, session } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (session) router.replace("/app/inicio");
  }, [session, router]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    if (password.length < 6) return setError("A senha deve ter ao menos 6 caracteres.");
    setLoading(true);
    try {
      await signUp({ email, password });
      router.replace("/onboarding");
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Erro ao cadastrar";
      if (msg.includes("already registered") || msg.includes("already been registered")) setError("E-mail já cadastrado. Faça login.");
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
          <h2 className="mt-6 max-w-sm text-center font-display text-4xl leading-tight">Vamos começar?</h2>
          <p className="mt-3 max-w-sm text-center font-semibold text-white/80">Crie sua conta e faça seu primeiro simulado hoje.</p>
        </div>
        <div className="font-semibold text-white/60">© Educate</div>
      </div>

      <div className="bg-mesh flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-sm animate-fade-up">
          <div className="mb-6 lg:hidden"><Logo variant="horizontal" height={34} /></div>
          <h1 className="font-display text-4xl text-ink">Criar conta</h1>
          <p className="mt-2 font-semibold text-ink-soft">É grátis e leva menos de um minuto.</p>

          <div className="mt-7">
            <GoogleButton onClick={handleGoogle} loading={googleLoading} label="Cadastrar com Google" />
          </div>
          <div className="my-5 flex items-center gap-3 text-sm font-bold text-ink-faint">
            <div className="h-px flex-1 bg-line" /> ou <div className="h-px flex-1 bg-line" />
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <Field icon={<Mail size={18} />} label="E-mail">
              <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="seu@email.com" className="w-full bg-transparent font-semibold text-ink outline-none" />
            </Field>
            <Field icon={<Lock size={18} />} label="Senha">
              <input type="password" required value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Mínimo 6 caracteres" className="w-full bg-transparent font-semibold text-ink outline-none" />
            </Field>

            {error && <p className="rounded-2xl bg-coral/10 px-4 py-3 text-sm font-bold text-coral">{error}</p>}

            <Button type="submit" variant="grass" loading={loading} className="w-full py-4 text-lg">Continuar</Button>
          </form>

          <p className="mt-6 text-center font-semibold text-ink-soft">
            Já tem conta?{" "}
            <Link href="/login" className="font-bold text-primary hover:underline">Entrar</Link>
          </p>
        </div>
      </div>
    </main>
  );
}
