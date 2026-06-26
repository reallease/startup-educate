import Link from "next/link";
import { Mail, Heart } from "lucide-react";

function InstagramIcon() {
  return (
    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
      <rect x="2" y="2" width="20" height="20" rx="5.5" />
      <circle cx="12" cy="12" r="4" />
      <circle cx="17.5" cy="6.5" r="1.2" fill="currentColor" stroke="none" />
    </svg>
  );
}

function YoutubeIcon() {
  return (
    <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor" aria-hidden>
      <path d="M23 12s0-3.8-.5-5.6a2.9 2.9 0 0 0-2-2C18.7 4 12 4 12 4s-6.7 0-8.5.4a2.9 2.9 0 0 0-2 2C1 8.2 1 12 1 12s0 3.8.5 5.6a2.9 2.9 0 0 0 2 2C5.3 20 12 20 12 20s6.7 0 8.5-.4a2.9 2.9 0 0 0 2-2C23 15.8 23 12 23 12ZM10 15.5v-7l6 3.5-6 3.5Z" />
    </svg>
  );
}

const INSTAGRAM_URL = "https://instagram.com/educate";
const YOUTUBE_URL = "https://youtube.com/@educateacc";
const CONTACT_EMAIL = "educateacc@gmail.com";

const columns = [
  {
    title: "Estudar",
    links: [
      { label: "Simulados", href: "/cadastro" },
      { label: "Flashcards", href: "/cadastro" },
      { label: "Cronômetro", href: "/cadastro" },
      { label: "Ranking", href: "/cadastro" },
    ],
  },
  {
    title: "Educate",
    links: [
      { label: "Sobre nós", href: "/sobre" },
      { label: "Contato", href: `mailto:${CONTACT_EMAIL}` },
      { label: "Entrar", href: "/login" },
      { label: "Criar conta", href: "/cadastro" },
    ],
  },
  {
    title: "Legal",
    links: [
      { label: "Política de Privacidade", href: "/privacidade" },
      { label: "Termos de Uso", href: "/termos" },
    ],
  },
];

export function SiteFooter() {
  return (
    <footer className="border-t border-line bg-surface">
      <div className="mx-auto grid max-w-6xl gap-10 px-5 py-14 md:grid-cols-[1.4fr_1fr_1fr_1fr]">

        <div>

          <img src="/assets/educate-logo-horizontal.svg" alt="Educate" className="h-11 w-auto object-contain" />
          <p className="mt-4 max-w-xs font-semibold text-ink-soft">
            A plataforma de estudos para você passar no ENEM e nos concursos — estudando um pouco todo dia.
          </p>
          <div className="mt-5 flex gap-3">
            <SocialIcon href={INSTAGRAM_URL} label="Instagram"><InstagramIcon /></SocialIcon>
            <SocialIcon href={YOUTUBE_URL} label="YouTube"><YoutubeIcon /></SocialIcon>
            <SocialIcon href={`mailto:${CONTACT_EMAIL}`} label="E-mail"><Mail size={20} /></SocialIcon>
          </div>
        </div>

        {columns.map((col) => (
          <div key={col.title}>
            <h3 className="font-display text-lg text-ink">{col.title}</h3>
            <ul className="mt-3 space-y-2.5">
              {col.links.map((l) => (
                <li key={l.label}>
                  <Link href={l.href} className="font-semibold text-ink-soft transition hover:text-primary">
                    {l.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>

      <div className="border-t border-line">
        <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-2 px-5 py-5 text-sm font-semibold text-ink-faint sm:flex-row">
          <span>© {new Date().getFullYear()} Educate. Todos os direitos reservados.</span>
          <span className="flex items-center gap-1.5">
            Feito com <Heart size={14} className="text-coral" fill="currentColor" /> no Brasil
          </span>
        </div>
      </div>
    </footer>
  );
}

function SocialIcon({ href, label, children }: { href: string; label: string; children: React.ReactNode }) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      aria-label={label}
      className="grid h-11 w-11 place-items-center rounded-2xl border-2 border-line bg-surface text-ink-soft transition hover:-translate-y-0.5 hover:border-primary hover:text-primary"
    >
      {children}
    </a>
  );
}
