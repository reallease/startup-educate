import type { Metadata } from "next";
import { LegalShell, LegalSection } from "@/components/legal-shell";

export const metadata: Metadata = {
  title: "Política de Privacidade — Educate",
  description: "Como o Educate coleta, usa e protege os seus dados.",
};

export default function PrivacidadePage() {
  return (
    <LegalShell
      title="Política de Privacidade"
      updated="25 de junho de 2026"
      intro="No Educate, levamos a sua privacidade a sério. Esta política explica, de forma clara, quais dados coletamos, por que coletamos e como você pode controlá-los."
    >
      <LegalSection heading="1. Dados que coletamos">
        <p>Coletamos apenas o necessário para o funcionamento da plataforma:</p>
        <ul className="ml-5 list-disc space-y-1.5">
          <li><strong>Cadastro:</strong> nome, e-mail, objetivo de estudo (ENEM, concurso ou militar) e estado (UF).</li>
          <li><strong>Uso:</strong> resultados de simulados, sequência de estudos, XP, flashcards revisados e tempo de estudo.</li>
          <li><strong>Login social:</strong> ao entrar com o Google, recebemos seu nome e e-mail da conta Google.</li>
        </ul>
      </LegalSection>

      <LegalSection heading="2. Como usamos seus dados">
        <p>Usamos seus dados para registrar seu progresso, exibir suas estatísticas, montar o ranking e personalizar sua experiência de estudo. Não vendemos seus dados a terceiros.</p>
      </LegalSection>

      <LegalSection heading="3. Ranking e visibilidade">
        <p>No ranking, exibimos publicamente apenas seu <strong>primeiro nome, estado, XP e sequência</strong>. Seu e-mail e demais informações nunca são exibidos a outros usuários.</p>
      </LegalSection>

      <LegalSection heading="4. Armazenamento e segurança">
        <p>Seus dados ficam armazenados em servidores seguros (Supabase), com políticas de acesso por linha (Row Level Security) que garantem que cada usuário só acesse os próprios dados.</p>
      </LegalSection>

      <LegalSection heading="5. Seus direitos (LGPD)">
        <p>De acordo com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018), você pode solicitar a qualquer momento o acesso, a correção ou a exclusão dos seus dados. Para isso, basta entrar em contato pelo e-mail abaixo.</p>
      </LegalSection>

      <LegalSection heading="6. Contato">
        <p>Dúvidas sobre privacidade? Fale com a gente em <a href="mailto:contato@educate.com.br" className="text-primary hover:underline">contato@educate.com.br</a>.</p>
      </LegalSection>
    </LegalShell>
  );
}
