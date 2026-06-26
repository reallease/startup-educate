"use client";

import { useEffect, useState } from "react";
import { Sun, Moon } from "lucide-react";
import { getTheme, applyTheme, type Theme } from "@/lib/theme";
import { cx } from "./ui";

export function ThemeToggle({ className = "" }: { className?: string }) {
  const [theme, setTheme] = useState<Theme>("light");
  useEffect(() => setTheme(getTheme()), []);

  function toggle() {
    const next: Theme = theme === "dark" ? "light" : "dark";
    applyTheme(next);
    setTheme(next);
  }

  return (
    <button
      onClick={toggle}
      aria-label={theme === "dark" ? "Ativar tema claro" : "Ativar tema escuro"}
      className={cx("grid h-10 w-10 place-items-center rounded-xl border-2 border-line bg-surface text-ink-soft transition hover:text-primary", className)}
    >
      {theme === "dark" ? <Sun size={18} /> : <Moon size={18} />}
    </button>
  );
}

export function ThemeSelector() {
  const [theme, setTheme] = useState<Theme>("light");
  useEffect(() => setTheme(getTheme()), []);

  function choose(t: Theme) {
    applyTheme(t);
    setTheme(t);
  }

  return (
    <div className="flex gap-2">
      {(["light", "dark"] as Theme[]).map((t) => (
        <button
          key={t}
          onClick={() => choose(t)}
          className={cx(
            "flex flex-1 items-center justify-center gap-2 rounded-xl border-2 px-4 py-3 font-bold transition",
            theme === t ? "border-primary bg-primary/10 text-primary" : "border-line bg-surface text-ink-soft hover:bg-bg"
          )}
        >
          {t === "light" ? <Sun size={18} /> : <Moon size={18} />}
          {t === "light" ? "Claro" : "Escuro"}
        </button>
      ))}
    </div>
  );
}
