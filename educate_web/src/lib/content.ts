import type { Question, Flashcard } from "./types";

export const QUESTIONS: Question[] = [

  { id: "m1", subject: "Matemática", category: "ENEM", question: "Uma loja oferece um desconto de 20% sobre o preço original de um produto. Se o preço final é R$ 64,00, qual era o preço original?", options: ["R$ 70,00", "R$ 75,00", "R$ 80,00", "R$ 85,00", "R$ 90,00"], correctIndex: 2, explanation: "Se P × (1 - 0,20) = 64, então P × 0,8 = 64, logo P = 64/0,8 = R$ 80,00." },
  { id: "m2", subject: "Matemática", category: "ENEM", question: "Qual é o valor de x na equação 2x + 5 = 15?", options: ["3", "4", "5", "6", "7"], correctIndex: 2, explanation: "2x = 15 - 5 = 10, então x = 10/2 = 5." },
  { id: "m3", subject: "Matemática", category: "ENEM", question: "A soma dos ângulos internos de um triângulo é sempre igual a:", options: ["90°", "180°", "270°", "360°", "450°"], correctIndex: 1, explanation: "A soma dos ângulos internos de qualquer triângulo é sempre 180°." },
  { id: "m4", subject: "Matemática", category: "ENEM", question: "Qual é a área de um círculo de raio 5cm? (π = 3,14)", options: ["28,14 cm²", "30,00 cm²", "62,80 cm²", "78,50 cm²", "100,00 cm²"], correctIndex: 3, explanation: "A = π × r² = 3,14 × 25 = 78,50 cm²." },
  { id: "m5", subject: "Matemática", category: "ENEM", question: "Um produto de R$ 200,00 sofre dois aumentos sucessivos de 10%. Qual o preço final?", options: ["R$ 220,00", "R$ 240,00", "R$ 242,00", "R$ 244,00", "R$ 250,00"], correctIndex: 2, explanation: "200 × 1,1 = 220; 220 × 1,1 = 242. Aumentos sucessivos se multiplicam." },
  { id: "m6", subject: "Matemática", category: "ENEM", question: "Qual é a média aritmética dos números 4, 8, 10 e 6?", options: ["6", "7", "7,5", "8", "28"], correctIndex: 1, explanation: "(4 + 8 + 10 + 6) / 4 = 28 / 4 = 7." },
  { id: "m7", subject: "Matemática", category: "ENEM", question: "Em uma PA de razão 3 e primeiro termo 2, qual é o 5º termo?", options: ["11", "12", "14", "15", "17"], correctIndex: 2, explanation: "aₙ = a₁ + (n-1)·r = 2 + 4·3 = 14." },
  { id: "m8", subject: "Matemática", category: "ENEM", question: "Quanto é 30% de 250?", options: ["55", "65", "70", "75", "80"], correctIndex: 3, explanation: "0,30 × 250 = 75." },
  { id: "m9", subject: "Matemática", category: "ENEM", question: "Qual o valor de 2³ + 3²?", options: ["12", "15", "17", "18", "25"], correctIndex: 2, explanation: "2³ = 8 e 3² = 9, logo 8 + 9 = 17." },

  { id: "p1", subject: "Português", category: "ENEM", question: 'Em "Os alunos estudaram porque a prova era difícil", a oração subordinada é:', options: ["causal", "consecutiva", "conformativa", "proporcional", "final"], correctIndex: 0, explanation: 'A oração "porque a prova era difícil" indica causa (subordinada adverbial causal).' },
  { id: "p2", subject: "Português", category: "ENEM", question: "Qual alternativa apresenta uma palavra escrita corretamente?", options: ["Prejuizo", "Prejuízo", "Prezuízo", "Prejuizo", "Prejuizi"], correctIndex: 1, explanation: 'A forma correta é "prejuízo", com acento agudo no "i".' },
  { id: "p3", subject: "Português", category: "ENEM", question: 'Qual a classe gramatical da palavra "rapidamente"?', options: ["Adjetivo", "Substantivo", "Advérbio", "Verbo", "Pronome"], correctIndex: 2, explanation: '"Rapidamente" é um advérbio de modo, formado pelo sufixo -mente.' },
  { id: "p4", subject: "Português", category: "ENEM", question: 'A figura de linguagem em "Chorei rios de lágrimas" é:', options: ["Metáfora", "Hipérbole", "Metonímia", "Ironia", "Eufemismo"], correctIndex: 1, explanation: "Hipérbole é o exagero proposital para dar ênfase." },
  { id: "p5", subject: "Português", category: "ENEM", question: "Assinale a frase com crase correta:", options: ["Vou a escola.", "Refiro-me à você.", "Cheguei às 8 horas.", "Ele foi à pé.", "Dei o livro à ele."], correctIndex: 2, explanation: 'Usa-se crase antes de horas determinadas femininas: "às 8 horas".' },
  { id: "p6", subject: "Português", category: "ENEM", question: 'O plural de "cidadão" é:', options: ["Cidadões", "Cidadãos", "Cidadães", "Cidadans", "Cidadons"], correctIndex: 1, explanation: 'O plural correto de "cidadão" é "cidadãos".' },
  { id: "p7", subject: "Português", category: "ENEM", question: 'Em "Comprei livros, cadernos e canetas", a vírgula separa:', options: ["Orações", "Aposto", "Vocativo", "Elementos de uma enumeração", "Adjunto adverbial"], correctIndex: 3, explanation: "A vírgula separa itens de uma mesma série (enumeração)." },

  { id: "h1", subject: "História", category: "ENEM", question: "A Proclamação da República do Brasil ocorreu em:", options: ["1822", "1888", "1889", "1891", "1930"], correctIndex: 2, explanation: "A República foi proclamada em 15 de novembro de 1889 pelo Marechal Deodoro da Fonseca." },
  { id: "h2", subject: "História", category: "ENEM", question: "A Lei Áurea, que aboliu a escravidão no Brasil, foi assinada em:", options: ["1808", "1822", "1850", "1888", "1889"], correctIndex: 3, explanation: "A Lei Áurea foi assinada em 13 de maio de 1888 pela Princesa Isabel." },
  { id: "h3", subject: "História", category: "ENEM", question: 'O Brasil foi "descoberto" pelos portugueses no ano de:', options: ["1492", "1500", "1502", "1512", "1530"], correctIndex: 1, explanation: "A esquadra de Pedro Álvares Cabral chegou ao Brasil em 22 de abril de 1500." },
  { id: "h4", subject: "História", category: "ENEM", question: "A Era Vargas teve início em qual ano?", options: ["1922", "1930", "1937", "1945", "1964"], correctIndex: 1, explanation: "Getúlio Vargas assumiu o poder em 1930, após a Revolução de 1930." },
  { id: "h5", subject: "História", category: "ENEM", question: "A Segunda Guerra Mundial terminou em:", options: ["1918", "1939", "1942", "1945", "1950"], correctIndex: 3, explanation: "A Segunda Guerra Mundial terminou em 1945, com a rendição do Japão." },

  { id: "g1", subject: "Geografia", category: "ENEM", question: "Qual é a maior região do Brasil em extensão territorial?", options: ["Nordeste", "Sudeste", "Centro-Oeste", "Norte", "Sul"], correctIndex: 3, explanation: "A região Norte é a maior do Brasil com aproximadamente 3,85 milhões de km²." },
  { id: "g2", subject: "Geografia", category: "ENEM", question: "O bioma que cobre a maior parte do território brasileiro é:", options: ["Caatinga", "Cerrado", "Amazônia", "Mata Atlântica", "Pampa"], correctIndex: 2, explanation: "O bioma Amazônia ocupa cerca de 49% do território nacional." },
  { id: "g3", subject: "Geografia", category: "ENEM", question: "Qual é a capital do Brasil?", options: ["Rio de Janeiro", "São Paulo", "Brasília", "Salvador", "Belo Horizonte"], correctIndex: 2, explanation: "Brasília é a capital federal desde 1960." },
  { id: "g4", subject: "Geografia", category: "ENEM", question: "O processo de saída da população do campo para as cidades chama-se:", options: ["Êxodo rural", "Migração pendular", "Nomadismo", "Urbanização forçada", "Transumância"], correctIndex: 0, explanation: "Êxodo rural é a migração do campo para a cidade." },
  { id: "g5", subject: "Geografia", category: "ENEM", question: "A linha imaginária que divide a Terra em hemisférios Norte e Sul é:", options: ["Meridiano de Greenwich", "Trópico de Câncer", "Linha do Equador", "Trópico de Capricórnio", "Círculo Polar"], correctIndex: 2, explanation: "A Linha do Equador divide a Terra nos hemisférios Norte e Sul." },

  { id: "c1", subject: "Ciências", category: "ENEM", question: "A velocidade do som se propaga mais rapidamente em qual meio?", options: ["Ar", "Água", "Vácuo", "Metal", "Madeira"], correctIndex: 3, explanation: "O som se propaga mais rápido em sólidos como o metal, pois as moléculas estão mais próximas." },
  { id: "c2", subject: "Ciências", category: "ENEM", question: "Qual é o elemento químico mais abundante no universo?", options: ["Oxigênio", "Carbono", "Hidrogênio", "Hélio", "Nitrogênio"], correctIndex: 2, explanation: "O hidrogênio representa cerca de 75% da matéria do universo." },
  { id: "f1", subject: "Física", category: "ENEM", question: "Segunda Lei de Newton: se aplicamos uma força de 10N em um corpo de 2kg, qual é a aceleração?", options: ["2 m/s²", "5 m/s²", "10 m/s²", "20 m/s²", "0,2 m/s²"], correctIndex: 1, explanation: "Pela fórmula F = m × a: a = F/m = 10/2 = 5 m/s²." },
  { id: "f2", subject: "Física", category: "ENEM", question: "A unidade de medida de força no Sistema Internacional é:", options: ["Joule", "Watt", "Newton", "Pascal", "Volt"], correctIndex: 2, explanation: "A força é medida em Newton (N) no SI." },
  { id: "q1", subject: "Química", category: "ENEM", question: "Qual é o símbolo do elemento químico Ouro na tabela periódica?", options: ["Or", "Ou", "Au", "Ag", "Go"], correctIndex: 2, explanation: 'O ouro é representado por Au, do latim "aurum".' },
  { id: "q2", subject: "Química", category: "ENEM", question: "O pH de uma solução neutra é:", options: ["0", "5", "7", "10", "14"], correctIndex: 2, explanation: "Uma solução neutra tem pH igual a 7 a 25°C." },
  { id: "q3", subject: "Química", category: "ENEM", question: "A água é formada por quais elementos?", options: ["Hidrogênio e Carbono", "Hidrogênio e Oxigênio", "Oxigênio e Nitrogênio", "Carbono e Oxigênio", "Hidrogênio e Hélio"], correctIndex: 1, explanation: "A água (H₂O) é formada por hidrogênio e oxigênio." },
  { id: "b1", subject: "Biologia", category: "ENEM", question: "As mitocôndrias são organelas responsáveis por:", options: ["Síntese de proteínas", "Respiração celular", "Fotossíntese", "Digestão celular", "Armazenamento de água"], correctIndex: 1, explanation: "As mitocôndrias são responsáveis pela respiração celular, produzindo ATP." },
  { id: "b2", subject: "Biologia", category: "ENEM", question: "O processo pelo qual as plantas produzem seu alimento é:", options: ["Respiração", "Fotossíntese", "Digestão", "Fermentação", "Transpiração"], correctIndex: 1, explanation: "A fotossíntese converte luz, CO₂ e água em glicose e oxigênio." },
  { id: "b3", subject: "Biologia", category: "ENEM", question: "Qual estrutura celular contém o material genético (DNA)?", options: ["Mitocôndria", "Ribossomo", "Núcleo", "Lisossomo", "Vacúolo"], correctIndex: 2, explanation: "O núcleo armazena o DNA nas células eucariontes." },

  { id: "i1", subject: "Informática", category: "Concurso", question: "Qual protocolo é utilizado para envio de e-mails?", options: ["POP3", "IMAP", "SMTP", "HTTP", "FTP"], correctIndex: 2, explanation: "O SMTP (Simple Mail Transfer Protocol) é usado para envio de e-mails." },
  { id: "i2", subject: "Informática", category: "Concurso", question: 'No Windows 10, qual atalho abre o painel de "Executar"?', options: ["Win + R", "Win + E", "Win + D", "Win + L", "Ctrl + R"], correctIndex: 0, explanation: 'Win + R abre a caixa de diálogo "Executar".' },
  { id: "i3", subject: "Informática", category: "Concurso", question: "No Windows, o atalho Ctrl + C serve para:", options: ["Colar", "Copiar", "Recortar", "Desfazer", "Salvar"], correctIndex: 1, explanation: "Ctrl + C copia o conteúdo selecionado." },
  { id: "i4", subject: "Informática", category: "Concurso", question: "Qual destes é um navegador de internet?", options: ["Excel", "Photoshop", "Google Chrome", "Windows Defender", "PowerPoint"], correctIndex: 2, explanation: "O Google Chrome é um navegador (browser) de internet." },
  { id: "rl1", subject: "Raciocínio Lógico", category: "Concurso", question: "Se todo A é B, e todo B é C, então:", options: ["Todo C é A", "Todo A é C", "Nenhum A é C", "Algum C não é A", "Nada se conclui"], correctIndex: 1, explanation: "Por transitividade: se A⊂B e B⊂C, então A⊂C." },
  { id: "rl2", subject: "Raciocínio Lógico", category: "Concurso", question: "Qual o próximo número da sequência: 2, 4, 8, 16, ...?", options: ["18", "24", "30", "32", "64"], correctIndex: 3, explanation: "Cada termo é o dobro do anterior: 16 × 2 = 32." },
  { id: "d1", subject: "Direito", category: "Concurso", question: "Qual artigo da CF prevê os fundamentos da República?", options: ["Art. 1º", "Art. 2º", "Art. 3º", "Art. 4º", "Art. 5º"], correctIndex: 0, explanation: "O Art. 1º da CF prevê os fundamentos: soberania, cidadania, dignidade da pessoa humana, valores sociais do trabalho e pluralismo político." },
  { id: "d2", subject: "Direito", category: "Concurso", question: "Os direitos e garantias fundamentais estão previstos principalmente em qual artigo da CF/88?", options: ["Art. 1º", "Art. 5º", "Art. 37", "Art. 100", "Art. 226"], correctIndex: 1, explanation: "O Art. 5º trata dos direitos e deveres individuais e coletivos." },
  { id: "d3", subject: "Direito", category: "Concurso", question: "Qual princípio da Administração Pública exige que o agente público aja conforme a lei?", options: ["Eficiência", "Moralidade", "Legalidade", "Publicidade", "Impessoalidade"], correctIndex: 2, explanation: "Pelo princípio da legalidade, o administrador só pode fazer o que a lei autoriza." },
];

export const FLASHCARDS: Flashcard[] = [
  { id: "f1", subject: "Matemática", front: "Fórmula de Bhaskara", back: "x = (-b ± √Δ) / 2a, onde Δ = b² - 4ac" },
  { id: "f2", subject: "Matemática", front: "Área do Círculo", back: "A = π × r²" },
  { id: "f3", subject: "Matemática", front: "Teorema de Pitágoras", back: "Em um triângulo retângulo: a² = b² + c²" },
  { id: "f4", subject: "Matemática", front: "Soma dos ângulos internos de um polígono", back: "S = (n - 2) × 180°, onde n é o número de lados" },
  { id: "f5", subject: "Física", front: "2ª Lei de Newton", back: "F = m × a (Força = massa × aceleração)" },
  { id: "f6", subject: "Física", front: "Velocidade média", back: "Vm = ΔS / Δt" },
  { id: "f7", subject: "Física", front: "Energia Cinética", back: "Ec = m × v² / 2" },
  { id: "f8", subject: "Química", front: "Número de Avogadro", back: "6,022 × 10²³" },
  { id: "f9", subject: "Química", front: "pH neutro", back: "pH = 7 (a 25°C)" },
  { id: "f10", subject: "Química", front: "Fórmula da água", back: "H₂O" },
  { id: "f11", subject: "Português", front: "O que é sujeito?", back: "Termo da oração sobre o qual se faz uma declaração. Pode ser simples, composto, oculto ou inexistente." },
  { id: "f12", subject: "Português", front: "O que é oração subordinada?", back: "Oração que depende de outra (principal) para ter sentido completo." },
  { id: "f13", subject: "Biologia", front: "O que é mitocôndria?", back: "Organela responsável pela respiração celular e produção de energia (ATP)." },
  { id: "f14", subject: "Biologia", front: "Fotossíntese", back: "6CO₂ + 6H₂O + luz → C₆H₁₂O₆ + 6O₂" },
  { id: "f15", subject: "História", front: "Revolução Francesa", back: "1789 - Marcou o fim do Antigo Regime na França. Lema: Liberdade, Igualdade, Fraternidade." },
  { id: "f16", subject: "História", front: "Proclamação da República", back: "15 de novembro de 1889, liderada pelo Marechal Deodoro da Fonseca." },
];

export function randomQuestions(count: number, subject?: string | null): Question[] {
  const pool = subject ? QUESTIONS.filter((q) => q.subject === subject) : [...QUESTIONS];
  for (let i = pool.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [pool[i], pool[j]] = [pool[j], pool[i]];
  }
  return pool.slice(0, count);
}
