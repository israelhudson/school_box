import '../models/aluno_detalhado.dart';
import '../models/filtro_opcao.dart';
import '../repositories/aluno_repository.dart';

class ListarAlunosUseCase {
  final AlunoRepository _repository;

  ListarAlunosUseCase(this._repository);

  /// Executar busca de alunos com filtros
  Future<List<AlunoDetalhado>> executar(FiltrosAluno filtros) async {
    try {
      return await _repository.buscarAlunosPorFiltros(filtros);
    } catch (e) {
      throw Exception('Erro ao listar alunos: $e');
    }
  }

  /// Buscar todos os alunos
  Future<List<AlunoDetalhado>> buscarTodos() async {
    try {
      return await _repository.buscarTodosAlunos();
    } catch (e) {
      throw Exception('Erro ao buscar todos os alunos: $e');
    }
  }

  /// Buscar alunos por turma
  Future<List<AlunoDetalhado>> buscarPorTurma(String turmaId) async {
    try {
      return await _repository.buscarAlunosPorTurma(turmaId);
    } catch (e) {
      throw Exception('Erro ao buscar alunos por turma: $e');
    }
  }

  /// Buscar alunos por série
  Future<List<AlunoDetalhado>> buscarPorSerie(String serieId) async {
    try {
      return await _repository.buscarAlunosPorSerie(serieId);
    } catch (e) {
      throw Exception('Erro ao buscar alunos por série: $e');
    }
  }

  /// Buscar alunos por segmento
  Future<List<AlunoDetalhado>> buscarPorSegmento(String segmentoId) async {
    try {
      return await _repository.buscarAlunosPorSegmento(segmentoId);
    } catch (e) {
      throw Exception('Erro ao buscar alunos por segmento: $e');
    }
  }

  /// Buscar alunos por matrícula
  Future<List<AlunoDetalhado>> buscarPorMatricula(String matricula) async {
    try {
      return await _repository.buscarAlunosPorMatricula(matricula);
    } catch (e) {
      throw Exception('Erro ao buscar alunos por matrícula: $e');
    }
  }

  /// Buscar alunos por nome
  Future<List<AlunoDetalhado>> buscarPorNome(String nome) async {
    try {
      return await _repository.buscarAlunosPorNome(nome);
    } catch (e) {
      throw Exception('Erro ao buscar alunos por nome: $e');
    }
  }

  /// Buscar aluno por ID
  Future<AlunoDetalhado?> buscarPorId(String usuarioId) async {
    try {
      return await _repository.buscarAlunoPorId(usuarioId);
    } catch (e) {
      throw Exception('Erro ao buscar aluno por ID: $e');
    }
  }

  /// Contar alunos com filtros
  Future<int> contarAlunos(FiltrosAluno filtros) async {
    try {
      return await _repository.contarAlunos(filtros);
    } catch (e) {
      throw Exception('Erro ao contar alunos: $e');
    }
  }

  /// Buscar opções de filtros disponíveis
  Future<List<FiltroOpcao>> buscarFiltrosDisponiveis() async {
    try {
      return await _repository.buscarFiltrosDisponiveis();
    } catch (e) {
      throw Exception('Erro ao buscar filtros disponíveis: $e');
    }
  }

  /// Buscar escolas disponíveis
  Future<List<FiltroOpcao>> buscarEscolas() async {
    try {
      return await _repository.buscarEscolas();
    } catch (e) {
      throw Exception('Erro ao buscar escolas: $e');
    }
  }

  /// Buscar segmentos disponíveis
  Future<List<FiltroOpcao>> buscarSegmentos() async {
    try {
      return await _repository.buscarSegmentos();
    } catch (e) {
      throw Exception('Erro ao buscar segmentos: $e');
    }
  }

  /// Buscar turnos disponíveis
  Future<List<FiltroOpcao>> buscarTurnos() async {
    try {
      return await _repository.buscarTurnos();
    } catch (e) {
      throw Exception('Erro ao buscar turnos: $e');
    }
  }

  /// Buscar séries disponíveis com filtros opcionais
  Future<List<FiltroOpcao>> buscarSeries({
    String? escolaId,
    String? segmentoId,
    String? turnoId,
  }) async {
    try {
      return await _repository.buscarSeries(
        escolaId: escolaId,
        segmentoId: segmentoId,
        turnoId: turnoId,
      );
    } catch (e) {
      throw Exception('Erro ao buscar séries: $e');
    }
  }

  /// Buscar turmas disponíveis com filtros opcionais
  Future<List<FiltroOpcao>> buscarTurmas({
    String? escolaId,
    String? segmentoId,
    String? turnoId,
    String? serieId,
  }) async {
    try {
      return await _repository.buscarTurmas(
        escolaId: escolaId,
        segmentoId: segmentoId,
        turnoId: turnoId,
        serieId: serieId,
      );
    } catch (e) {
      throw Exception('Erro ao buscar turmas: $e');
    }
  }
}
