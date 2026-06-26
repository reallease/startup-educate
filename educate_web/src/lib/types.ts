export type Question = {
  id: string;
  subject: string;
  category: string;
  question: string;
  options: string[];
  correctIndex: number;
  explanation: string;
};

export type Flashcard = {
  id: string;
  subject: string;
  front: string;
  back: string;
};

export type Profile = {
  id: string;
  name: string;
  email: string;
  objective: string;
  areas: string[] | null;
  onboarded: boolean | null;
  state: string | null;
  xp: number;
  streak: number;
  total_quizzes: number;
  total_questions: number;
  study_minutes: number;
};

export type QuizResult = {
  id: string;
  title: string;
  total_questions: number;
  correct_answers: number;
  time_spent_seconds: number;
  created_at: string;
};

export type LeaderboardRow = {
  name: string;
  state: string | null;
  xp: number;
  streak: number;
  total_quizzes: number;
  rank: number;
};
