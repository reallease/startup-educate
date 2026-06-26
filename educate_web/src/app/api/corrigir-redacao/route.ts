export const dynamic = "force-dynamic";
export const maxDuration = 30;

const MODEL = process.env.GEMINI_MODEL ?? "gemini-2.0-flash";

const schema = {
  type: "OBJECT",
  properties: {
    competencias: {
      type: "ARRAY",
      items: {
        type: "OBJECT",
        properties: {
          numero: { type: "INTEGER" },
          titulo: { type: "STRING" },
          nota: { type: "INTEGER" },
          comentario: { type: "STRING" },
        },
        required: ["numero", "titulo", "nota", "comentario"],
      },
    },
    notaTotal: { type: "INTEGER" },
    pontosFortes: { type: "ARRAY", items: { type: "STRING" } },
    pontosMelhorar: { type: "ARRAY", items: { type: "STRING" } },
    comentarioGeral: { type: "STRING" },
  },
  required: ["competencias", "notaTotal", "pontosFortes", "pontosMelhorar", "comentarioGeral"],
};

const RUBRICA = `Avalie como um corretor oficial do ENEM, atribuindo nota de 0 a 200 para cada uma das 5 competências (a nota total é a soma, de 0 a 1000):
1. Domínio da norma culta da língua escrita.
2. Compreensão da proposta e aplicação de conceitos das várias áreas em um texto dissertativo-argumentativo.
3. Seleção, relação e organização de informações, fatos e argumentos em defesa de um ponto de vista.
4. Conhecimento dos mecanismos linguísticos de coesão (conectivos, referências).
5. Elaboração de proposta de intervenção para o problema, respeitando os direitos humanos.
Para cada competência, dê um comentário específico e construtivo em português. No final, liste pontos fortes, pontos a melhorar e um comentário geral motivador.`;

export async function POST(req: Request) {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey || apiKey.trim().length < 10) {
    return Response.json({ error: "A chave do Gemini não está configurada no servidor (GEMINI_API_KEY)." }, { status: 503 });
  }

  let body: { tema?: string; texto?: string };
  try {
    body = await req.json();
  } catch {
    return Response.json({ error: "Requisição inválida." }, { status: 400 });
  }

  const tema = (body.tema ?? "").toString().trim();
  const texto = (body.texto ?? "").toString().trim();
  if (texto.length < 200) {
    return Response.json({ error: "A redação está muito curta. Escreva pelo menos um texto com início, meio e fim." }, { status: 400 });
  }
  if (texto.length > 8000) {
    return Response.json({ error: "A redação está muito longa." }, { status: 400 });
  }

  const prompt = `${RUBRICA}

Tema proposto: "${tema || "(não informado pelo aluno)"}".

Redação do aluno, delimitada por <<< >>>:
<<<
${texto}
>>>

Responda apenas com o JSON pedido. A soma das notas das competências deve ser igual a notaTotal.`;

  let res: Response;
  try {
    res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`, {
      method: "POST",
      headers: { "Content-Type": "application/json", "x-goog-api-key": apiKey },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: { temperature: 0.4, responseMimeType: "application/json", responseSchema: schema },
      }),
    });
  } catch {
    return Response.json({ error: "Não foi possível contatar o serviço de correção." }, { status: 502 });
  }

  if (!res.ok) {
    const detail = await res.text().catch(() => "");
    return Response.json({ error: "O serviço de correção retornou um erro. Verifique a chave e o modelo do Gemini.", detail: detail.slice(0, 300) }, { status: 502 });
  }

  const data = await res.json();
  const text = data?.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) {
    return Response.json({ error: "O modelo não retornou uma correção. Tente novamente." }, { status: 502 });
  }

  try {
    const parsed = JSON.parse(text);
    return Response.json(parsed);
  } catch {
    return Response.json({ error: "Resposta da IA em formato inesperado. Tente novamente." }, { status: 502 });
  }
}
