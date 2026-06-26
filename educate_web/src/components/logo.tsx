"use client";

import { useState } from "react";
import { MascotMark } from "./mascot";

type Variant = "horizontal" | "horizontal-white" | "mark" | "mark-white" | "vertical" | "vertical-white" | "wordmark" | "wordmark-white";

const SRC: Record<Variant, string> = {
  horizontal: "/assets/educate-logo-horizontal.svg",
  "horizontal-white": "/assets/educate-logo-horizontal-white.svg",
  mark: "/assets/educate-mark.svg",
  "mark-white": "/assets/educate-mark-white.svg",
  vertical: "/assets/educate-logo-vertical.svg",
  "vertical-white": "/assets/educate-logo-vertical-white.svg",
  wordmark: "/assets/educate-wordmark.svg",
  "wordmark-white": "/assets/educate-wordmark-white.svg",
};

export function Logo({ height = 32, variant = "horizontal", className = "" }: { height?: number; variant?: Variant; className?: string }) {
  const [failed, setFailed] = useState(false);
  if (failed) return <MascotMark size={height} className={className} />;
  return (

    <img
      src={SRC[variant]}
      alt="Educate"
      style={{ height, width: "auto" }}
      className={`object-contain ${className}`}
      onError={() => setFailed(true)}
    />
  );
}
