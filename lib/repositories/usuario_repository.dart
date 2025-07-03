import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';

class UsuarioRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Buscar todos os usuários ativos
  Future<List<Usuario>> buscarUsuarios() async {
    try {
      final response = await _client
          .from('usuarios')
          .select()
          .eq('ativo', true)
          .order('nome');

      return response.map((item) => Usuario.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  /// Buscar usuário por ID
  Future<Usuario?> buscarUsuarioPorId(String id) async {
    try {
      final response = await _client
          .from('usuarios')
          .select()
          .eq('id', id)
          .eq('ativo', true)
          .single();

      return Usuario.fromJson(response);
    } catch (e) {
      if (e.toString().contains('No rows found')) {
        return null;
      }
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  /// Buscar usuário por email
  Future<Usuario?> buscarUsuarioPorEmail(String email) async {
    try {
      final response = await _client
          .from('usuarios')
          .select()
          .eq('email', email)
          .eq('ativo', true)
          .maybeSingle();

      return response != null ? Usuario.fromJson(response) : null;
    } catch (e) {
      throw Exception('Erro ao buscar usuário por email: $e');
    }
  }

  /// Buscar usuários por tipo
  Future<List<Usuario>> buscarUsuariosPorTipo(UserType tipo) async {
    try {
      final response = await _client
          .from('usuarios')
          .select()
          .eq('tipo', tipo.value)
          .eq('ativo', true)
          .order('nome');

      return response.map((item) => Usuario.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar usuários por tipo: $e');
    }
  }

  /// Criar novo usuário
  Future<Usuario> criarUsuario(Usuario usuario) async {
    try {
      final response = await _client
          .from('usuarios')
          .insert(usuario.toJson())
          .select()
          .single();

      return Usuario.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  /// Atualizar usuário
  Future<Usuario> atualizarUsuario(String id, Usuario usuario) async {
    try {
      final response = await _client
          .from('usuarios')
          .update(usuario.toJson())
          .eq('id', id)
          .select()
          .single();

      return Usuario.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  /// Desativar usuário (soft delete)
  Future<void> desativarUsuario(String id) async {
    try {
      await _client.from('usuarios').update({'ativo': false}).eq('id', id);
    } catch (e) {
      throw Exception('Erro ao desativar usuário: $e');
    }
  }

  /// Buscar usuários com paginação
  Future<List<Usuario>> buscarUsuariosPaginado({
    int? offset,
    int? limit,
    String? filtroNome,
    UserType? filtroTipo,
  }) async {
    try {
      // Construir query básica
      dynamic queryBuilder = _client
          .from('usuarios')
          .select()
          .eq('ativo', true);

      // Aplicar filtros
      if (filtroNome != null && filtroNome.isNotEmpty) {
        queryBuilder = queryBuilder.ilike('nome', '%$filtroNome%');
      }

      if (filtroTipo != null) {
        queryBuilder = queryBuilder.eq('tipo', filtroTipo.value);
      }

      // Aplicar ordenação
      queryBuilder = queryBuilder.order('nome');

      // Aplicar paginação
      if (offset != null) {
        queryBuilder = queryBuilder.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await queryBuilder;

      return response.map((item) => Usuario.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar usuários paginados: $e');
    }
  }

  /// Contar total de usuários (simplificado)
  Future<int> contarUsuarios({String? filtroNome, UserType? filtroTipo}) async {
    try {
      // Buscar todos os usuários com filtros e contar no client
      final usuarios = await buscarUsuariosPaginado(
        filtroNome: filtroNome,
        filtroTipo: filtroTipo,
      );

      return usuarios.length;
    } catch (e) {
      throw Exception('Erro ao contar usuários: $e');
    }
  }
}
