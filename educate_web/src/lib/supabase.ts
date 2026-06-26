import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL =
  process.env.NEXT_PUBLIC_SUPABASE_URL ?? "https://ekyyjhvybvifxlmbumah.supabase.co";
const SUPABASE_ANON_KEY =
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ??
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVreXlqaHZ5YnZpZnhsbWJ1bWFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU0MTI1MzcsImV4cCI6MjA5MDk4ODUzN30.bCEKugD31gg62j2IVPaB7SDsSC39Jv6FX270gNf9OoI";

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
    flowType: "implicit",
  },
});
