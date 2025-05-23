import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sobre o School Box',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'O que é o School Box?',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'O School Box é uma aplicação desenvolvida para gerenciar e organizar fotos de alunos de forma segura e eficiente. Com uma interface intuitiva e recursos avançados, facilitamos o trabalho de escolas e instituições educacionais.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Recursos Principais',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.security),
                      title: const Text('Segurança Avançada'),
                      subtitle: const Text('Proteção de dados e privacidade'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Organização Inteligente'),
                      subtitle: const Text('Categorização automática de fotos'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Compartilhamento Seguro'),
                      subtitle: const Text('Compartilhe fotos com autorização'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
