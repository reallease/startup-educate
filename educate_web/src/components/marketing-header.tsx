import Link from "next/link";
import { Logo } from "./logo";

export function MarketingHeader() {
  return (
    <header className="sticky top-0 z-30 border-b border-line/70 bg-bg/80 backdrop-blur-md">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-5 py-3">
        <Link href="/" className="flex items-center">
          <Logo variant="horizontal" height={34} />
        </Link>
        <div className="flex items-center gap-2">
          <Link href="/login" className="hidden rounded-2xl px-4 py-2 font-bold text-ink-soft transition hover:text-ink sm:block">
            Entrar
          </Link>
          <Link href="/cadastro" className="btn-3d text-sm">Começar grátis</Link>
        </div>
      </div>
    </header>
  );
}
