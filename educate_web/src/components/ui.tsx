"use client";

import { type ReactNode, type ButtonHTMLAttributes } from "react";
import { Sprout, BookOpen, Flame, Star, Trophy, type LucideProps } from "lucide-react";

export function cx(...parts: (string | false | null | undefined)[]) {
  return parts.filter(Boolean).join(" ");
}

const LEVEL_ICONS: Record<string, React.ComponentType<LucideProps>> = {
  sprout: Sprout,
  book: BookOpen,
  flame: Flame,
  star: Star,
  trophy: Trophy,
};

export function LevelIcon({ name, size = 16, className }: { name: string; size?: number; className?: string }) {
  const Icon = LEVEL_ICONS[name] ?? Sprout;
  return <Icon size={size} className={className} />;
}

export function Card({
  children,
  className,
  onClick,
  variant = "pop",
}: {
  children: ReactNode;
  className?: string;
  onClick?: () => void;
  variant?: "pop" | "soft" | "plain";
}) {
  const base = variant === "soft" ? "card-soft" : variant === "plain" ? "bg-surface rounded-[24px]" : "card-pop";
  return (
    <div
      onClick={onClick}
      className={cx(
        base,
        onClick && "cursor-pointer transition-transform hover:-translate-y-0.5 active:translate-y-0",
        className
      )}
    >
      {children}
    </div>
  );
}

type BtnProps = ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: "primary" | "grass" | "gold" | "coral" | "light";
  loading?: boolean;
};

export function Button({ variant = "primary", loading, className, children, disabled, ...rest }: BtnProps) {
  if (variant === "light") {
    return (
      <button {...rest} disabled={disabled || loading} className={cx("btn-3d-light", className)}>
        {loading ? <Spinner dark /> : children}
      </button>
    );
  }
  const mod = variant === "grass" ? "is-grass" : variant === "gold" ? "is-gold" : variant === "coral" ? "is-coral" : "";
  return (
    <button {...rest} disabled={disabled || loading} className={cx("btn-3d", mod, className)}>
      {loading ? <Spinner /> : children}
    </button>
  );
}

function Spinner({ dark }: { dark?: boolean }) {
  return <span className={cx("h-5 w-5 animate-spin rounded-full border-2", dark ? "border-ink/30 border-t-ink" : "border-white/40 border-t-white")} />;
}

export function Ring({
  progress,
  size = 76,
  stroke = 8,
  track = "rgba(255,255,255,0.28)",
  color = "#ffffff",
  children,
}: {
  progress: number;
  size?: number;
  stroke?: number;
  track?: string;
  color?: string;
  children?: ReactNode;
}) {
  const r = size / 2 - stroke;
  const c = 2 * Math.PI * r;
  const clamped = Math.min(1, Math.max(0, progress));
  return (
    <div className="relative grid place-items-center" style={{ width: size, height: size }}>
      <svg width={size} height={size} className="-rotate-90">
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={track} strokeWidth={stroke} />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={r}
          fill="none"
          stroke={color}
          strokeWidth={stroke}
          strokeLinecap="round"
          strokeDasharray={c}
          strokeDashoffset={c * (1 - clamped)}
          style={{ transition: "stroke-dashoffset 0.7s cubic-bezier(0.22,1,0.36,1)" }}
        />
      </svg>
      <div className="absolute inset-0 grid place-items-center text-center">{children}</div>
    </div>
  );
}

export function ProgressBar({ value, className, color = "bg-grass" }: { value: number; className?: string; color?: string }) {
  return (
    <div className={cx("h-3 w-full overflow-hidden rounded-full bg-line", className)}>
      <div
        className={cx("h-full rounded-full transition-[width] duration-500", color)}
        style={{ width: `${Math.min(100, Math.max(0, value * 100))}%` }}
      />
    </div>
  );
}

export function SectionTitle({ children, action }: { children: ReactNode; action?: ReactNode }) {
  return (
    <div className="mb-3 flex items-center justify-between">
      <h2 className="font-display text-xl text-ink">{children}</h2>
      {action}
    </div>
  );
}

export function GoogleButton({ onClick, loading, label = "Continuar com Google" }: { onClick: () => void; loading?: boolean; label?: string }) {
  return (
    <button
      onClick={onClick}
      disabled={loading}
      className="btn-3d-light w-full"
      type="button"
    >
      {loading ? (
        <span className="h-5 w-5 animate-spin rounded-full border-2 border-ink/30 border-t-ink" />
      ) : (
        <>
          <svg width="20" height="20" viewBox="0 0 48 48" aria-hidden>
            <path fill="#FFC107" d="M43.6 20.5H42V20H24v8h11.3C33.7 32.4 29.3 35 24 35c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.9 1.2 8 3.1l5.7-5.7C34.5 5.1 29.5 3 24 3 12.4 3 3 12.4 3 24s9.4 21 21 21c10.5 0 20-7.6 20-21 0-1.2-.1-2.3-.4-3.5Z" />
            <path fill="#FF3D00" d="m6.3 14.7 6.6 4.8C14.7 16 19 13 24 13c3.1 0 5.9 1.2 8 3.1l5.7-5.7C34.5 5.1 29.5 3 24 3 16 3 9.1 7.6 6.3 14.7Z" />
            <path fill="#4CAF50" d="M24 45c5.2 0 10-2 13.6-5.2l-6.3-5.3C29.2 35.9 26.7 37 24 37c-5.3 0-9.7-2.6-11.3-7l-6.5 5C9 41.3 16 45 24 45Z" />
            <path fill="#1976D2" d="M43.6 20.5H42V20H24v8h11.3c-.8 2.2-2.2 4.1-4 5.5l6.3 5.3C41.9 36.4 44 30.9 44 24c0-1.2-.1-2.3-.4-3.5Z" />
          </svg>
          {label}
        </>
      )}
    </button>
  );
}
