"use client";

import { useEffect } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { Home, BookOpen, BarChart3, User, Timer, CalendarDays, Trophy, LogOut, Settings, PenLine } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { levelOf } from "@/lib/gamification";
import { needsOnboarding } from "@/lib/cloud";
import { cx, LevelIcon } from "@/components/ui";
import { Logo } from "@/components/logo";
import { ThemeToggle } from "@/components/theme-toggle";

const mainNav = [
  { href: "/app/inicio", label: "Início", icon: Home },
  { href: "/app/estudar", label: "Estudar", icon: BookOpen },
  { href: "/app/progresso", label: "Progresso", icon: BarChart3 },
  { href: "/app/perfil", label: "Perfil", icon: User },
];

const toolNav = [
  { href: "/app/redacao", label: "Redação", icon: PenLine },
  { href: "/app/pomodoro", label: "Cronômetro", icon: Timer },
  { href: "/app/agenda", label: "Agenda", icon: CalendarDays },
  { href: "/app/conquistas", label: "Conquistas", icon: Trophy },
  { href: "/app/configuracoes", label: "Configurações", icon: Settings },
];

export default function AppLayout({ children }: { children: React.ReactNode }) {
  const { session, profile, loading, signOut } = useAuth();
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    if (!loading && !session) router.replace("/login");
  }, [loading, session, router]);

  const mustOnboard = !!session && !!profile && needsOnboarding(profile, session.user.id);

  useEffect(() => {
    if (mustOnboard) router.replace("/onboarding");
  }, [mustOnboard, router]);

  if (loading || !session || mustOnboard) {
    return (
      <div className="grid min-h-screen place-items-center">
        <div className="h-10 w-10 animate-spin rounded-full border-4 border-primary/30 border-t-primary" />
      </div>
    );
  }

  const name = profile?.name ?? "Estudante";
  const tier = levelOf(profile?.xp ?? 0);

  async function handleLogout() {
    await signOut();
    router.replace("/login");
  }

  return (
    <div className="min-h-screen lg:flex">

      <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col border-r border-line bg-surface p-5 lg:flex">
        <Link href="/app/inicio" className="mb-8 flex items-center px-1">
          <Logo variant="horizontal" height={32} />
        </Link>

        <nav className="flex flex-1 flex-col gap-1">
          {mainNav.map((it) => (
            <NavLink key={it.href} {...it} active={pathname === it.href} />
          ))}
          <div className="my-3 px-3 text-xs font-semibold uppercase tracking-wide text-ink-faint">Ferramentas</div>
          {toolNav.map((it) => (
            <NavLink key={it.href} {...it} active={pathname === it.href} />
          ))}
        </nav>

        <div className="mt-4 flex items-center gap-2">
          <div className="flex min-w-0 flex-1 items-center gap-3 rounded-2xl bg-bg p-3">
            <div className="grid h-10 w-10 place-items-center rounded-full bg-brand-gradient font-bold text-white">
              {name.charAt(0).toUpperCase()}
            </div>
            <div className="min-w-0 flex-1">
              <div className="truncate text-sm font-semibold text-ink">{name.split(" ")[0]}</div>
              <div className="flex items-center gap-1 text-xs text-ink-soft">
                <LevelIcon name={tier.icon} size={13} className="text-primary" /> {tier.name}
              </div>
            </div>
            <button onClick={handleLogout} title="Sair" className="text-ink-faint transition hover:text-danger">
              <LogOut size={18} />
            </button>
          </div>
          <ThemeToggle />
        </div>
      </aside>

      <main className="flex-1 pb-24 lg:pb-0">
        <div className="mx-auto max-w-3xl px-4 py-6 sm:px-6 lg:py-10">{children}</div>
      </main>

      <nav className="fixed inset-x-0 bottom-0 z-40 flex border-t border-line bg-surface/95 backdrop-blur lg:hidden">
        {mainNav.map((it) => {
          const active = pathname === it.href;
          return (
            <Link key={it.href} href={it.href} className="flex flex-1 flex-col items-center gap-1 py-2.5">
              <it.icon size={22} className={active ? "text-primary" : "text-ink-faint"} />
              <span className={cx("text-[11px] font-medium", active ? "text-primary" : "text-ink-faint")}>{it.label}</span>
            </Link>
          );
        })}
      </nav>
    </div>
  );
}

function NavLink({ href, label, icon: Icon, active }: { href: string; label: string; icon: React.ElementType; active: boolean }) {
  return (
    <Link
      href={href}
      className={cx(
        "flex items-center gap-3 rounded-xl px-3 py-2.5 font-semibold transition",
        active ? "bg-primary/10 text-primary" : "text-ink-soft hover:bg-bg"
      )}
    >
      <Icon size={20} />
      {label}
    </Link>
  );
}
