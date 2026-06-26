export const XP_PER_CORRECT = 10;
export const XP_PER_STREAK_DAY = 5;

export function calculateXP(correctAnswers: number, streakDays: number) {
  return correctAnswers * XP_PER_CORRECT + streakDays * XP_PER_STREAK_DAY;
}

export const LEVEL_TIERS = [
  { name: "Iniciante", min: 0, icon: "sprout" },
  { name: "Estudante", min: 100, icon: "book" },
  { name: "Dedicado", min: 300, icon: "flame" },
  { name: "Mestre", min: 600, icon: "star" },
  { name: "Gênio", min: 1000, icon: "trophy" },
];

export const STUDY_AREAS = [
  { id: "ENEM", label: "ENEM", desc: "Exame Nacional do Ensino Médio" },
  { id: "Vestibulares", label: "Vestibulares", desc: "Fuvest, Unicamp, UERJ e outros" },
  { id: "Concursos", label: "Concursos", desc: "Concursos públicos em geral" },
  { id: "Militares", label: "Militares", desc: "ESA, EsPCEx, AFA, EFOMM" },
];

export function areaToObjective(area: string | undefined): string {
  if (area === "Concursos") return "Concurso Público";
  if (area === "Militares") return "Militares";
  return "ENEM";
}

export function levelOf(xp: number) {
  let tier = LEVEL_TIERS[0];
  for (const t of LEVEL_TIERS) if (xp >= t.min) tier = t;
  return tier;
}

export function nextThreshold(xp: number) {
  for (const t of LEVEL_TIERS) if (xp < t.min) return t.min;
  return 1500;
}

export function currentThreshold(xp: number) {
  let min = 0;
  for (const t of LEVEL_TIERS) if (xp >= t.min) min = t.min;
  return min;
}

export function progressInLevel(xp: number) {
  const lo = currentThreshold(xp);
  const hi = nextThreshold(xp);
  if (hi <= lo) return 1;
  return Math.min(1, Math.max(0, (xp - lo) / (hi - lo)));
}

export type Achievement = {
  id: string;
  title: string;
  description: string;
  icon: string;
  unlocked: boolean;
};

export function getAchievements(args: {
  totalCorrect: number;
  totalQuestions: number;
  totalQuizzes: number;
  streak: number;
  bestAccuracy: number;
}): Achievement[] {
  const { totalCorrect, totalQuestions, totalQuizzes, streak, bestAccuracy } = args;
  return [
    { id: "first_question", title: "Primeira Questão", description: "Responda sua primeira questão", icon: "check", unlocked: totalQuestions >= 1 },
    { id: "streak_7", title: "Em Chamas", description: "7 dias consecutivos de estudo", icon: "fire", unlocked: streak >= 7 },
    { id: "streak_30", title: "Super Sequência", description: "30 dias consecutivos de estudo", icon: "fire", unlocked: streak >= 30 },
    { id: "fifty_correct", title: "Meio-Caminho", description: "Acerte 50 questões", icon: "star", unlocked: totalCorrect >= 50 },
    { id: "hundred_questions", title: "Centurião", description: "Responda 100 questões", icon: "trophy", unlocked: totalQuestions >= 100 },
    { id: "perfect_quiz", title: "Nota Máxima", description: "Acerte 90%+ em um simulado", icon: "star", unlocked: bestAccuracy >= 0.9 },
    { id: "five_hundred", title: "Mestre do Conhecimento", description: "Acerte 500 questões", icon: "medal", unlocked: totalCorrect >= 500 },
    { id: "quiz_10", title: "Persistente", description: "Complete 10 simulados", icon: "task", unlocked: totalQuizzes >= 10 },
  ];
}

export const BR_STATES: Record<string, string> = {
  AC: "Acre", AL: "Alagoas", AP: "Amapá", AM: "Amazonas", BA: "Bahia",
  CE: "Ceará", DF: "Distrito Federal", ES: "Espírito Santo", GO: "Goiás",
  MA: "Maranhão", MT: "Mato Grosso", MS: "Mato Grosso do Sul", MG: "Minas Gerais",
  PA: "Pará", PB: "Paraíba", PR: "Paraná", PE: "Pernambuco", PI: "Piauí",
  RJ: "Rio de Janeiro", RN: "Rio Grande do Norte", RS: "Rio Grande do Sul",
  RO: "Rondônia", RR: "Roraima", SC: "Santa Catarina", SP: "São Paulo",
  SE: "Sergipe", TO: "Tocantins",
};

export function greeting() {
  const h = new Date().getHours();
  if (h < 12) return "Bom dia";
  if (h < 18) return "Boa tarde";
  return "Boa noite";
}
