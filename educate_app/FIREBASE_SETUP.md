# Configuração do Firebase - Educate App

## 1. Criar projeto no Firebase
1. Acesse https://console.firebase.google.com/
2. Clique em **Criar projeto**
3. Nome: `educate-app` (ou outro)
4. Google Analytics (opcional) - clique Criar

## 2. Configurar App Android
1. Na dashboard, clique no ícone **Android**
2. Nome do pacote: `com.educate.app` (ou o que estiver no `android/app/build.gradle`)
3. Baixe o `google-services.json`
4. Coloque o arquivo em: `android/app/google-services.json`
5. Adicione a assinatura SHA-1 nas configurações do projeto

## 3. Configurar Auth
1. No menu lateral, vá em **Authentication**
2. Clique em **Primeiros passos**
3. Ative os métodos:
   - **E-mail/Senha** → clique e ative
   - **Google** → clique, adicione o email de suporte e salve
4. Configurar **Modelos de e-mail**: personalize o email de redefinição de senha em pt-BR

## 4. Configurar Firestore
1. No menu lateral, vá em **Firestore Database**
2. Clique em **Criar banco de dados**
3. Escolha **Iniciar no modo de teste** (pode mudar depois)
4. Selecione a região mais próxima (ex: `southamerica-east1` - São Paulo)

## 5. Regras de segurança do Firestore
Vá em **Regras** e cole:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários - só o próprio usuário acessa
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    // Quizzes - subcoleção do usuário
    match /users/{userId}/quizzes/{quizId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    // Progresso - subcoleção do usuário
    match /users/{userId}/progress/{docId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    // Study days - subcoleção do usuário
    match /users/{userId}/study_days/{dayId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 6. Ativar Firebase no app
1. No `lib/main.dart`, descomente o bloco `Firebase.initializeApp()`
2. Adicione suas credenciais (peça no console Firebase → Configurações do projeto → Apps)
3. Ou use a abordagem com arquivo `google-services.json` (recomendado para Android)

### Ativar no main.dart:
```dart
await Firebase.initializeApp(); // Se o google-services.json está configurado
// OU
await Firebase.initializeApp(options: const FirebaseOptions(
  apiKey: "SUA_API_KEY",
  appId: "SEU_APP_ID",
  messagingSenderId: "SEU_SENDER_ID",
  projectId: "SEU_PROJECT_ID",
));
```

### No android/build.gradle, adicione:
```groovy
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

### No android/app/build.gradle, adicione no final:
```groovy
apply plugin: 'com.google.gms.google-services'
```

## 7. Testar
```bash
flutter pub get
flutter run
```

## Estrutura do Firestore:
```
users/
  {userId}/
    name: string
    email: string
    objective: string
    xp: number
    streak: number
    totalQuizzes: number
    totalQuestions: number
    studyMinutes: number
    createdAt: timestamp
    lastLogin: timestamp
    
    quizzes/ (subcoleção)
      {quizId}/
        title: string
        totalQuestions: number
        correctAnswers: number
        timeSpentSeconds: number
        completedAt: timestamp
    
    progress/ (subcoleção)
      flashcards/
        mastered: array
    
    study_days/ (subcoleção)
      {YYYY-M-D}/
        date: timestamp
        minutes: number
        quizzes: number
```

## 8. Deploy das regras
```bash
firebase deploy --only firestore:rules
```

## Hospedagem
- **Firebase Firestore** (recomendado) - Grátis até 1GB, 50k reads/dia
- **Supabase** - Alternativa open source, também grátis
- **Appwrite** - Self-hosted gratuito
- **AWS Amplify** - Grátis no tier free

Firebase é a melhor escolha para Flutter pela integração nativa.
