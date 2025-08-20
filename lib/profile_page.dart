import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, String> userData;

  const ProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cadastro realizado com sucesso!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Nome: ${userData['nome']}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Nascimento: ${userData['dataNascimento']}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Sexo: ${userData['sexo']}', style: const TextStyle(fontSize: 18)),
                      Text('Telefone: ${userData['telefone'] ?? 'Não informado'}', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: const Text('OK'),
              )
            ],
          ),
        ),
      ),
    );
  }
}