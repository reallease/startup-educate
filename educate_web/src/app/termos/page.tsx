import type { Metadata } from "next";
import { LegalShell, LegalSection } from "@/components/legal-shell";

export const metadata: Metadata = {
  title: "Termos de Uso — Educate",
  description: "As regras para usar a plataforma Educate.",
};

export default function TermosPage() {
  return (
    <LegalShell
      title="Termos de Uso"
      updated="25 de junho de 2026"
      intro="Ao criar uma conta e usar o Educate, você concorda com estes termos. Leia com atenção — escrevemos do jeito mais direto possível."
    >
      <LegalSection heading="1. Sobre o serviço">
        <p>O Educate é uma plataforma de estudos com simulados, flashcards, metas e ranking, voltada à preparação para o ENEM, concursos públicos e carreiras militares. O conteúdo tem finalidade educativa e de apoio aos estudos.</p>
      </LegalSection>

      <LegalSection heading="2. Sua conta">
        <p>Você é responsável por manter a confidencialidade da sua senha e por toda a atividade na sua conta. Os dados informados no cadastro devem ser verdadeiros.</p>
      </LegalSection>

      <LegalSection heading="3. Uso adequado">
        <p>Você concorda em não usar a plataforma para fins ilegais, não tentar burlar o ranking com dados falsos e não prejudicar o funcionamento do serviço ou a experiência de outros estudantes.</p>
      </LegalSection>

      <LegalSection heading="4. Conteúdo">
        <p>As questões e materiais são oferecidos para estudo. Nos esforçamos pela precisão do conteúdo, mas ele não substitui materiais oficiais das bancas e instituições.</p>
      </LegalSection>

      <LegalSection heading="5. Gratuidade e alterações">
        <p>O Educate é gratuito no momento. Podemos atualizar recursos, estes termos e a estrutura da plataforma para melhorá-la, avisando sobre mudanças relevantes.</p>
      </LegalSection>

      <LegalSection heading="6. Encerramento">
        <p>Você pode excluir sua conta quando quiser. Podemos suspender contas que violem estes termos.</p>
      </LegalSection>

      <LegalSection heading="7. Contato">
        <p>Ficou com alguma dúvida? Escreva para <a href="mailto:contato@educate.com.br" className="text-primary hover:underline">contato@educate.com.br</a>.</p>
      </LegalSection>
    </LegalShell>
  );
}
