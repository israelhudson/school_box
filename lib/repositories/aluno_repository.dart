import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/aluno_detalhado.dart';
import '../models/filtro_opcao.dart';

class AlunoRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Buscar alunos usando a function do Supabase com filtros
  Future<List<AlunoDetalhado>> buscarAlunosPorFiltros(
    FiltrosAluno filtros,
  ) async {
    try {
      final response = await _client.rpc(
        'buscar_alunos_por_filtros',
        params: {
          if (filtros.turmaId != null) 'p_turma_id': filtros.turmaId,
          if (filtros.serieId != null) 'p_serie_id': filtros.serieId,
          if (filtros.turnoId != null) 'p_turno_id': filtros.turnoId,
          if (filtros.segmentoId != null) 'p_segmento_id': filtros.segmentoId,
          if (filtros.escolaId != null) 'p_escola_id': filtros.escolaId,
          if (filtros.matricula != null && filtros.matricula!.isNotEmpty)
            'p_matricula': filtros.matricula,
          if (filtros.nome != null && filtros.nome!.isNotEmpty)
            'p_nome': filtros.nome,
          if (filtros.anoLetivo != null) 'p_ano_letivo': filtros.anoLetivo,
        },
      );

      return (response as List<dynamic>)
          .map((item) => AlunoDetalhado.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar alunos: $e');
    }
  }

  /// Buscar todos os alunos (sem filtros)
  Future<List<AlunoDetalhado>> buscarTodosAlunos() async {
    return buscarAlunosPorFiltros(FiltrosAluno());
  }

  /// Buscar alunos por turma específica
  Future<List<AlunoDetalhado>> buscarAlunosPorTurma(String turmaId) async {
    return buscarAlunosPorFiltros(FiltrosAluno(turmaId: turmaId));
  }

  /// Buscar alunos por série específica
  Future<List<AlunoDetalhado>> buscarAlunosPorSerie(String serieId) async {
    return buscarAlunosPorFiltros(FiltrosAluno(serieId: serieId));
  }

  /// Buscar alunos por segmento específico
  Future<List<AlunoDetalhado>> buscarAlunosPorSegmento(
    String segmentoId,
  ) async {
    return buscarAlunosPorFiltros(FiltrosAluno(segmentoId: segmentoId));
  }

  /// Buscar alunos por matrícula
  Future<List<AlunoDetalhado>> buscarAlunosPorMatricula(
    String matricula,
  ) async {
    return buscarAlunosPorFiltros(FiltrosAluno(matricula: matricula));
  }

  /// Buscar alunos por nome
  Future<List<AlunoDetalhado>> buscarAlunosPorNome(String nome) async {
    return buscarAlunosPorFiltros(FiltrosAluno(nome: nome));
  }

  /// Buscar opções de filtros disponíveis
  Future<List<FiltroOpcao>> buscarFiltrosDisponiveis() async {
    try {
      final response = await _client.rpc('buscar_filtros_alunos');

      return (response as List<dynamic>)
          .map((item) => FiltroOpcao.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar filtros disponíveis: $e');
    }
  }

  /// Buscar escolas disponíveis
  Future<List<FiltroOpcao>> buscarEscolas() async {
    final filtros = await buscarFiltrosDisponiveis();
    return filtros.where((f) => f.tipo == 'escola').toList();
  }

  /// Buscar segmentos disponíveis
  Future<List<FiltroOpcao>> buscarSegmentos() async {
    final filtros = await buscarFiltrosDisponiveis();
    return filtros.where((f) => f.tipo == 'segmento').toList();
  }

  /// Buscar turnos disponíveis
  Future<List<FiltroOpcao>> buscarTurnos() async {
    final filtros = await buscarFiltrosDisponiveis();
    return filtros.where((f) => f.tipo == 'turno').toList();
  }

  /// Buscar séries disponíveis (opcionalmente filtradas por escola/segmento/turno)
  Future<List<FiltroOpcao>> buscarSeries({
    String? escolaId,
    String? segmentoId,
    String? turnoId,
  }) async {
    final filtros = await buscarFiltrosDisponiveis();
    return filtros.where((f) {
      if (f.tipo != 'serie') return false;

      final compativel = f.isCompativel(
        escolaSelecionada: escolaId,
        segmentoSelecionado: segmentoId,
        turnoSelecionado: turnoId,
      );

      return compativel;
    }).toList();
  }

  /// Buscar turmas disponíveis (opcionalmente filtradas)
  Future<List<FiltroOpcao>> buscarTurmas({
    String? escolaId,
    String? segmentoId,
    String? turnoId,
    String? serieId,
  }) async {
    final filtros = await buscarFiltrosDisponiveis();
    return filtros.where((f) {
      if (f.tipo != 'turma') return false;

      final compativel = f.isCompativel(
        escolaSelecionada: escolaId,
        segmentoSelecionado: segmentoId,
        turnoSelecionado: turnoId,
        serieSelecionada: serieId,
      );

      return compativel;
    }).toList();
  }

  /// Contar alunos com filtros
  Future<int> contarAlunos(FiltrosAluno filtros) async {
    final alunos = await buscarAlunosPorFiltros(filtros);
    return alunos.length;
  }

  /// Buscar aluno por ID do usuário
  Future<AlunoDetalhado?> buscarAlunoPorId(String usuarioId) async {
    try {
      final alunos = await buscarAlunosPorFiltros(FiltrosAluno());
      return alunos.where((a) => a.usuarioId == usuarioId).firstOrNull;
    } catch (e) {
      throw Exception('Erro ao buscar aluno por ID: $e');
    }
  }
}
