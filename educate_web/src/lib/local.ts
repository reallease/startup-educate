

const isBrowser = () => typeof window !== "undefined";

function getInt(key: string, fallback: number): number {
  if (!isBrowser()) return fallback;
  const v = window.localStorage.getItem(key);
  return v === null ? fallback : parseInt(v, 10);
}

function setInt(key: string, value: number) {
  if (isBrowser()) window.localStorage.setItem(key, String(value));
}

const todayStr = () => {
  const t = new Date();
  return `${t.getFullYear()}-${t.getMonth() + 1}-${t.getDate()}`;
};

function rollover() {
  if (!isBrowser()) return;
  if (window.localStorage.getItem("today_date") !== todayStr()) {
    window.localStorage.setItem("today_date", todayStr());
    setInt("today_questions", 0);
    setInt("today_minutes", 0);
  }
}

export const goals = {
  getQuestions: () => getInt("goal_questions", 20),
  setQuestions: (v: number) => setInt("goal_questions", v),
  getMinutes: () => getInt("goal_minutes", 60),
  setMinutes: (v: number) => setInt("goal_minutes", v),
};

export const today = {
  questions: () => {
    rollover();
    return getInt("today_questions", 0);
  },
  minutes: () => {
    rollover();
    return getInt("today_minutes", 0);
  },
  add: (questions: number, minutes: number) => {
    rollover();
    setInt("today_questions", getInt("today_questions", 0) + questions);
    setInt("today_minutes", getInt("today_minutes", 0) + minutes);
  },
};

export const masteredCards = {
  all: (): string[] => {
    if (!isBrowser()) return [];
    const v = window.localStorage.getItem("mastered_cards");
    return v ? (JSON.parse(v) as string[]) : [];
  },
  toggle: (id: string): string[] => {
    const set = new Set(masteredCards.all());
    if (set.has(id)) set.delete(id);
    else set.add(id);
    const arr = [...set];
    if (isBrowser()) window.localStorage.setItem("mastered_cards", JSON.stringify(arr));
    return arr;
  },
};
