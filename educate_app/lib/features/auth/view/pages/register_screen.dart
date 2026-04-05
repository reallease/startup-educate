import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/storage_service.dart';
import '../../../pages/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureP = true;
  bool _obscureC = true;
  String _object = 'ENEM';
  bool _accept = false;

  InputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      );
  InputBorder _borderFocus() => const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0xFF7C3AED), width: 2),
      );
  InputBorder _borderError() => const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      );

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? kt,
    Widget? suffixIcon,
    String? Function(String?)? val,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: kt,
          validator: val,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixIcon: suffixIcon,
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _borderFocus(),
            errorBorder: _borderError(),
          ),
        ),
      ],
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_accept) {
      _showError('Aceite os Termos de Uso e Política de Privacidade.');
      return;
    }
    setState(() => _isLoading = true);

    try {
      await AuthService.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        name: _nameCtrl.text.trim(),
        objective: _object,
      );

      // Salvar localmente
      await StorageService.setUserName(_nameCtrl.text.trim());
      await StorageService.setUserEmail(_emailCtrl.text.trim());

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (_) => false,
      );
    } on Exception catch (e) {
      if (!mounted) return;
      // Log completo do erro para debug
      debugPrint('=== REGISTER ERROR: $e ===');
      _showError('Erro: ${e.toString()}');
    } catch (e) {
      if (!mounted) return;
      _showError('Erro ao criar conta. Verifique sua conexão.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _err(String msg) {
    if (msg.contains('already been registered') || msg.contains('already registered'))
      return 'E-mail já cadastrado. Faça login.';
    if (msg.contains('Password')) return 'Senha fraca. Use pelo menos 6 caracteres.';
    if (msg.contains('Unable')) return 'Erro de servidor. Tente novamente mais tarde.';
    return msg;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Crie sua conta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Junte-se ao Educate!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.school, color: Color(0xFF7C3AED), size: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _field(
                        ctrl: _nameCtrl,
                        label: 'Nome',
                        hint: 'Seu nome completo',
                        icon: Icons.person_outline,
                        val: (v) => v == null || v.trim().length < 3
                            ? 'Digite seu nome (min. 3 caracteres)'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        ctrl: _emailCtrl,
                        label: 'E-mail',
                        hint: 'seu@email.com',
                        icon: Icons.email_outlined,
                        kt: TextInputType.emailAddress,
                        val: (v) => v == null || !v.contains('@') ? 'E-mail inválido' : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        ctrl: _passCtrl,
                        label: 'Senha',
                        hint: 'Mínimo 6 caracteres',
                        icon: Icons.shield,
                        obscure: _obscureP,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureP ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => _obscureP = !_obscureP),
                        ),
                        val: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        ctrl: _confirmCtrl,
                        label: 'Confirmar Senha',
                        hint: 'Repita a senha',
                        icon: Icons.check_circle_outline,
                        obscure: _obscureC,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureC ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => _obscureC = !_obscureC),
                        ),
                        val: (v) => v != _passCtrl.text ? 'Senhas não conferem' : null,
                      ),
                      const SizedBox(height: 16),

                      const Text('Seu Objetivo',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 8),
                      Row(
                        children: ['ENEM', 'Concurso', 'Militares'].map((opt) {
                          final chosen = (_object == opt ||
                              (opt == 'Concurso' && _object == 'Concurso Público'));
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Material(
                                color: chosen ? const Color(0xFF7C3AED) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () => setState(() => _object = opt == 'Concurso' ? 'Concurso Público' : opt),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      opt,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: chosen ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _accept,
                        onChanged: (v) => setState(() => _accept = v ?? false),
                        title: RichText(
                          text: const TextSpan(
                            text: 'Li e aceito os ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Termos de Uso',
                                style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: ' e '),
                              TextSpan(
                                text: 'Política de Privacidade',
                                style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        activeColor: const Color(0xFF7C3AED),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text.rich(
                            TextSpan(
                              text: 'Já tem conta? ',
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'Entrar',
                                  style: TextStyle(
                                    color: Color(0xFF7C3AED),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
