import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contato'),
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
              'Entre em Contato',
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
                      'Formulário de Contato',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Mensagem',
                        prefixIcon: Icon(Icons.message),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Enviar Mensagem'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações de Contato',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: const Text('contato@schoolbox.com'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Telefone'),
                      subtitle: const Text('(11) 99999-9999'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Endereço'),
                      subtitle: const Text('São Paulo, SP - Brasil'),
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
