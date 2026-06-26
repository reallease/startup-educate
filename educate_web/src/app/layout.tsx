import type { Metadata } from "next";
import { Nunito, Baloo_2 } from "next/font/google";
import "./globals.css";
import { AuthProvider } from "@/lib/auth-context";
import { themeNoFlashScript } from "@/lib/theme";

const nunito = Nunito({ subsets: ["latin"], variable: "--font-nunito", weight: ["400", "500", "600", "700", "800", "900"] });
const baloo = Baloo_2({ subsets: ["latin"], variable: "--font-baloo", weight: ["500", "600", "700", "800"] });

export const metadata: Metadata = {
  title: "Educate — Estude jogando, conquiste sua aprovação",
  description: "A plataforma de estudos para ENEM e concursos. Simulados, flashcards, metas diárias, sequências e ranking. Estude todo dia e veja sua evolução.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="pt-BR" className={`${nunito.variable} ${baloo.variable} h-full`} suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeNoFlashScript }} />
      </head>
      <body className="min-h-full">
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}
