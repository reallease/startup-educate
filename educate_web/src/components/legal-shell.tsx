import { type ReactNode } from "react";
import { MarketingHeader } from "./marketing-header";
import { SiteFooter } from "./site-footer";

export function LegalShell({ title, updated, intro, children }: { title: string; updated: string; intro?: string; children: ReactNode }) {
  return (
    <main className="min-h-screen bg-bg">
      <MarketingHeader />
      <article className="mx-auto max-w-3xl px-5 py-14">
        <h1 className="font-display text-4xl text-ink sm:text-5xl">{title}</h1>
        <p className="mt-3 font-semibold text-ink-faint">Última atualização: {updated}</p>
        {intro && <p className="mt-6 text-lg font-semibold leading-relaxed text-ink-soft">{intro}</p>}
        <div className="mt-10 space-y-9">{children}</div>
      </article>
      <SiteFooter />
    </main>
  );
}

export function LegalSection({ heading, children }: { heading: string; children: ReactNode }) {
  return (
    <section>
      <h2 className="font-display text-2xl text-ink">{heading}</h2>
      <div className="mt-3 space-y-3 font-semibold leading-relaxed text-ink-soft">{children}</div>
    </section>
  );
}
