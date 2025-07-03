import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../use_cases/listar_usuarios_use_case.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late ListarUsuariosUseCase _listarUsuariosUseCase;
  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  String? _errorMessage;
  UserType? _filtroTipo;

  @override
  void initState() {
    super.initState();
    _listarUsuariosUseCase = ListarUsuariosUseCase(UsuarioRepository());
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final usuarios = await _listarUsuariosUseCase.executar(
        filtroTipo: _filtroTipo,
      );
      setState(() {
        _usuarios = usuarios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filtrarPorTipo(UserType? tipo) {
    setState(() {
      _filtroTipo = tipo;
    });
    _carregarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarUsuarios,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Filtrar por tipo:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<UserType?>(
                    value: _filtroTipo,
                    isExpanded: true,
                    hint: const Text('Todos'),
                    onChanged: _filtrarPorTipo,
                    items: [
                      const DropdownMenuItem<UserType?>(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ...UserType.values.map(
                        (tipo) => DropdownMenuItem<UserType?>(
                          value: tipo,
                          child: Text(tipo.displayName),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Conteúdo principal
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar usuários',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarUsuarios,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_usuarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum usuário encontrado',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Não há usuários cadastrados ou que correspondam ao filtro selecionado.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final usuario = _usuarios[index];
        return _buildUsuarioCard(usuario);
      },
    );
  }

  Widget _buildUsuarioCard(Usuario usuario) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAvatarColor(usuario.tipo),
          child: Text(
            usuario.nome.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          usuario.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (usuario.email != null)
              Text(usuario.email!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(usuario.tipo),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                usuario.tipo.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              usuario.ativo ? Icons.check_circle : Icons.cancel,
              color: usuario.ativo ? Colors.green : Colors.red,
            ),
            Text(
              usuario.ativo ? 'Ativo' : 'Inativo',
              style: TextStyle(
                fontSize: 12,
                color: usuario.ativo ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        onTap: () {
          _showUsuarioDetails(usuario);
        },
      ),
    );
  }

  Color _getAvatarColor(UserType tipo) {
    switch (tipo) {
      case UserType.admin:
        return Colors.red;
      case UserType.moderador:
        return Colors.orange;
      case UserType.responsavel:
        return Colors.blue;
      case UserType.aluno:
        return Colors.green;
    }
  }

  Color _getTypeColor(UserType tipo) {
    switch (tipo) {
      case UserType.admin:
        return Colors.red[600]!;
      case UserType.moderador:
        return Colors.orange[600]!;
      case UserType.responsavel:
        return Colors.blue[600]!;
      case UserType.aluno:
        return Colors.green[600]!;
    }
  }

  void _showUsuarioDetails(Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(usuario.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Email', usuario.email ?? 'Não informado'),
            _buildDetailItem('Tipo', usuario.tipo.displayName),
            _buildDetailItem('CPF', usuario.cpf ?? 'Não informado'),
            _buildDetailItem('Celular', usuario.celular ?? 'Não informado'),
            _buildDetailItem('Cidade', usuario.cidade ?? 'Não informado'),
            _buildDetailItem('Status', usuario.ativo ? 'Ativo' : 'Inativo'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
