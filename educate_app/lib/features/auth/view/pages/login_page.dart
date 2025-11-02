import 'package:educate_app/features/auth/view/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'custom_field.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // fundo escuro igual na imagem
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo e título
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Educate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
                        'Vestibulares & Concursos',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bem-vindo de volta!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Continue sua jornada de estudos e conquiste seus objetivos',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),

                // Campos de entrada
                CustomTextField(
                  label: 'E-mail',
                  hint: 'seu@email.com',
                  icon: Icons.email_outlined,
                  controller: emailController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Senha',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (v) {},
                          activeColor: const Color(0xFF00B97E),
                        ),
                        const Text('Lembrar de mim'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Esqueci minha senha'),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B97E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {},
                    child: const Text('Entrar', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 15),
                const Center(child: Text('ou continue com')),
                const SizedBox(height: 15),

                // Botões de login social
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/google.png', height: 22),
                        const SizedBox(width: 12),
                        const Text(
                          'Continuar com Google',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const SizedBox(height: 25),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não tem uma conta? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => RegisterScreen())
                          );
                        },
                        child: const Text(
                          'Cadastre-se gratuitamente',
                          style: TextStyle(
                            color: Color(0xFF00B97E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
