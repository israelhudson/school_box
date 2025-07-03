import '../models/usuario.dart';
import '../repositories/usuario_repository.dart';

class ListarUsuariosUseCase {
  final UsuarioRepository _repository;

  ListarUsuariosUseCase(this._repository);

  /// Executar o caso de uso para listar usuários
  Future<List<Usuario>> executar({
    UserType? filtroTipo,
    String? filtroNome,
    int? offset,
    int? limit,
  }) async {
    try {
      if (filtroTipo != null ||
          filtroNome != null ||
          offset != null ||
          limit != null) {
        // Buscar com filtros/paginação
        return await _repository.buscarUsuariosPaginado(
          filtroTipo: filtroTipo,
          filtroNome: filtroNome,
          offset: offset,
          limit: limit,
        );
      } else {
        // Buscar todos os usuários
        return await _repository.buscarUsuarios();
      }
    } catch (e) {
      throw Exception('Erro ao listar usuários: $e');
    }
  }

  /// Buscar usuários por tipo específico
  Future<List<Usuario>> buscarPorTipo(UserType tipo) async {
    try {
      return await _repository.buscarUsuariosPorTipo(tipo);
    } catch (e) {
      throw Exception('Erro ao buscar usuários por tipo: $e');
    }
  }

  /// Buscar usuário por ID
  Future<Usuario?> buscarPorId(String id) async {
    try {
      return await _repository.buscarUsuarioPorId(id);
    } catch (e) {
      throw Exception('Erro ao buscar usuário por ID: $e');
    }
  }

  /// Buscar usuário por email
  Future<Usuario?> buscarPorEmail(String email) async {
    try {
      return await _repository.buscarUsuarioPorEmail(email);
    } catch (e) {
      throw Exception('Erro ao buscar usuário por email: $e');
    }
  }

  /// Contar total de usuários
  Future<int> contarUsuarios({String? filtroNome, UserType? filtroTipo}) async {
    try {
      return await _repository.contarUsuarios(
        filtroNome: filtroNome,
        filtroTipo: filtroTipo,
      );
    } catch (e) {
      throw Exception('Erro ao contar usuários: $e');
    }
  }
}
