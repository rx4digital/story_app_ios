import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  final _auth = AuthService();
  String? _msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Digite seu e-mail para receber instruções.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 16),

            if (_msg != null)
              Text(_msg!, style: const TextStyle(color: Colors.green)),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                await _auth.resetPassword(_email.text.trim());
                setState(() {
                  _msg = 'E-mail enviado! Verifique sua caixa de entrada.';
                });
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
