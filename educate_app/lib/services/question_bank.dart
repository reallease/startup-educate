import '../core/models.dart';

class QuestionBank {
  static List<Question> getQuestions({String? subject, String? category}) {
    var questions = _allQuestions;
    if (subject != null) {
      questions = questions.where((q) => q.subject == subject).toList();
    }
    if (category != null) {
      questions = questions.where((q) => q.category == category).toList();
    }
    return questions;
  }

  static List<String> getSubjects() {
    return _allQuestions.map((q) => q.subject).toSet().toList()..sort();
  }

  static List<Question> getRandomQuestions({required int count, String? subject}) {
    final pool = subject != null
        ? _allQuestions.where((q) => q.subject == subject).toList()
        : List.from(_allQuestions);
    pool.shuffle();
    return List<Question>.from(pool.take(count));
  }

  static final List<Question> _allQuestions = [
    // MATEMÁTICA
    Question(
      id: 'm1',
      subject: 'Matemática',
      category: 'ENEM',
      question: 'Uma loja oferece um desconto de 20% sobre o preço original de um produto. Se o preço final é R\$ 64,00, qual era o preço original?',
      options: ['R\$ 70,00', 'R\$ 75,00', 'R\$ 80,00', 'R\$ 85,00', 'R\$ 90,00'],
      correctIndex: 2,
      explanation: 'Se P × (1 - 0,20) = 64, então P × 0,8 = 64, logo P = 64/0,8 = R\$ 80,00.',
    ),
    Question(
      id: 'm2',
      subject: 'Matemática',
      category: 'ENEM',
      question: 'Qual é o valor de x na equação 2x + 5 = 15?',
      options: ['3', '4', '5', '6', '7'],
      correctIndex: 2,
      explanation: '2x = 15 - 5 = 10, então x = 10/2 = 5.',
    ),
    Question(
      id: 'm3',
      subject: 'Matemática',
      category: 'ENEM',
      question: 'A soma dos ângulos internos de um triângulo é sempre igual a:',
      options: ['90°', '180°', '270°', '360°', '450°'],
      correctIndex: 1,
      explanation: 'A soma dos ângulos internos de qualquer triângulo é sempre 180°.',
    ),
    Question(
      id: 'm4',
      subject: 'Matemática',
      category: 'ENEM',
      question: 'Qual é a área de um círculo de raio 5cm? (π = 3,14)',
      options: ['28,14 cm²', '30,00 cm²', '62,80 cm²', '78,50 cm²', '100,00 cm²'],
      correctIndex: 3,
      explanation: 'A = π × r² = 3,14 × 25 = 78,50 cm².',
    ),
    // PORTUGUÊS
    Question(
      id: 'p1',
      subject: 'Português',
      category: 'ENEM',
      question: 'Em "Os alunos estudaram porque a prova era difícil", a oração subordinada é:',
      options: ['causal', 'consecutiva', 'conformativa', 'proporcional', 'final'],
      correctIndex: 0,
      explanation: 'A oração "porque a prova era difícil" indica causa, é uma subordinada adverbial causal.',
    ),
    Question(
      id: 'p2',
      subject: 'Português',
      category: 'ENEM',
      question: 'Qual alternativa apresenta uma palavra escrita corretamente?',
      options: ['Prejuizo', 'Prejuízo', 'Prejuízo', 'Prejuizo', 'Prejuizi'],
      correctIndex: 1,
      explanation: 'A forma correta é "prejuízo", com acento agudo no "i".',
    ),
    Question(
      id: 'p3',
      subject: 'Português',
      category: 'ENEM',
      question: 'Qual a classe gramatical da palavra "rapidamente"?',
      options: ['Adjetivo', 'Substantivo', 'Advérbio', 'Verbo', 'Pronome'],
      correctIndex: 2,
      explanation: '"Rapidamente" é um advérbio de modo, formado pelo sufixo -mente.',
    ),
    // HISTÓRIA
    Question(
      id: 'h1',
      subject: 'História',
      category: 'ENEM',
      question: 'A Proclamação da República do Brasil ocorreu em:',
      options: ['1822', '1888', '1889', '1891', '1930'],
      correctIndex: 2,
      explanation: 'A República foi proclamada em 15 de novembro de 1889 pelo Marechal Deodoro da Fonseca.',
    ),
    Question(
      id: 'h2',
      subject: 'História',
      category: 'ENEM',
      question: 'A Lei Áurea, que aboliu a escravidão no Brasil, foi assinada em:',
      options: ['1808', '1822', '1850', '1888', '1889'],
      correctIndex: 3,
      explanation: 'A Lei Áurea (Lei nº 3.353) foi assinada em 13 de maio de 1888 pela Princesa Isabel.',
    ),
    // CIÊNCIAS
    Question(
      id: 'c1',
      subject: 'Ciências',
      category: 'ENEM',
      question: 'A velocidade do som se propaga mais rapidamente em qual meio?',
      options: ['Ar', 'Água', 'Vácuo', 'Metal', 'Madeira'],
      correctIndex: 3,
      explanation: 'O som se propaga mais rapidamente em sólidos como o metal, pois as moléculas estão mais próximas.',
    ),
    Question(
      id: 'c2',
      subject: 'Ciências',
      category: 'ENEM',
      question: 'Qual é o elemento químico mais abundante no universo?',
      options: ['Oxigênio', 'Carbono', 'Hidrogênio', 'Hélio', 'Nitrogênio'],
      correctIndex: 2,
      explanation: 'O hidrogênio (H) é o elemento mais abundante, representando cerca de 75% da matéria do universo.',
    ),
    // GEOGRAFIA
    Question(
      id: 'g1',
      subject: 'Geografia',
      category: 'ENEM',
      question: 'Qual é a maior região do Brasil em extensão territorial?',
      options: ['Nordeste', 'Sudeste', 'Centro-Oeste', 'Norte', 'Sul'],
      correctIndex: 3,
      explanation: 'A região Norte é a maior do Brasil com aproximadamente 3,85 milhões de km².',
    ),
    Question(
      id: 'g2',
      subject: 'Geografia',
      category: 'ENEM',
      question: 'O bioma que cobre a maior parte do território brasileiro é:',
      options: ['Caatinga', 'Cerrado', 'Amazônia', 'Mata Atlântica', 'Pampa'],
      correctIndex: 2,
      explanation: 'O bioma Amazônia ocupa cerca de 49% do território nacional.',
    ),
    // FÍSICA
    Question(
      id: 'f1',
      subject: 'Física',
      category: 'ENEM',
      question: 'Segunda Lei de Newton: se aplicamos uma força de 10N em um corpo de 2kg, qual é a aceleração?',
      options: ['2 m/s²', '5 m/s²', '10 m/s²', '20 m/s²', '0,2 m/s²'],
      correctIndex: 1,
      explanation: 'Pela fórmula F = m × a: a = F/m = 10/2 = 5 m/s².',
    ),
    // QUÍMICA
    Question(
      id: 'q1',
      subject: 'Química',
      category: 'ENEM',
      question: 'Qual é o símbolo do elemento químico Ouro na tabela periódica?',
      options: ['Or', 'Ou', 'Au', 'Ag', 'Go'],
      correctIndex: 2,
      explanation: 'O ouro é representado por Au, do latim "aurum".',
    ),
    Question(
      id: 'q2',
      subject: 'Química',
      category: 'ENEM',
      question: 'O pH de uma solução neutra é:',
      options: ['0', '5', '7', '10', '14'],
      correctIndex: 2,
      explanation: 'Uma solução neutra tem pH igual a 7 a 25°C.',
    ),
    // BIOLOGIA
    Question(
      id: 'b1',
      subject: 'Biologia',
      category: 'ENEM',
      question: 'As mitocôndrias são organelas responsáveis por:',
      options: ['Síntese de proteínas', 'Respiração celular', 'Fotossíntese', 'Digestão celular', 'Armazenamento de água'],
      correctIndex: 1,
      explanation: 'As mitocôndrias são responsáveis pela respiração celular, produzindo ATP através da fosforilação oxidativa.',
    ),
    // INFORMÁTICA (Concursos)
    Question(
      id: 'i1',
      subject: 'Informática',
      category: 'Concurso',
      question: 'Qual protocolo é utilizado para envio de e-mails?',
      options: ['POP3', 'IMAP', 'SMTP', 'HTTP', 'FTP'],
      correctIndex: 2,
      explanation: 'O SMTP (Simple Mail Transfer Protocol) é o protocolo utilizado para envio de e-mails.',
    ),
    Question(
      id: 'i2',
      subject: 'Informática',
      category: 'Concurso',
      question: 'No Windows 10, qual atalho abre o painel de "Executar"?',
      options: ['Win + R', 'Win + E', 'Win + D', 'Win + L', 'Ctrl + R'],
      correctIndex: 0,
      explanation: 'Win + R abre a caixa de diálogo "Executar" no Windows.',
    ),
    // DIREITO (Concursos)
    Question(
      id: 'd1',
      subject: 'Direito',
      category: 'Concurso',
      question: 'Segundo a Constituição Federal, a soberania é um princípio fundamental. Qual é o artigo que prevê os fundamentos da República?',
      options: ['Art. 1º', 'Art. 2º', 'Art. 3°', 'Art. 4º', 'Art. 5°'],
      correctIndex: 0,
      explanation: 'O Art. 1° da CF prevê os fundamentos da República: soberania, cidadania, dignidade da pessoa humana, valores sociais do trabalho e pluralismo político.',
    ),
  ];
}
