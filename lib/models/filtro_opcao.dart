class FiltroOpcao {
  final String id;
  final String nome;
  final String tipo; // 'escola', 'segmento', 'turno', 'serie', 'turma'
  final String? escolaId;
  final String? escolaNome;
  final String? segmentoId;
  final String? segmentoNome;
  final String? turnoId;
  final String? turnoNome;
  final String? serieId;
  final String? serieNome;

  FiltroOpcao({
    required this.id,
    required this.nome,
    required this.tipo,
    this.escolaId,
    this.escolaNome,
    this.segmentoId,
    this.segmentoNome,
    this.turnoId,
    this.turnoNome,
    this.serieId,
    this.serieNome,
  });

  factory FiltroOpcao.fromJson(Map<String, dynamic> json) {
    return FiltroOpcao(
      id: json['id'] as String,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      escolaId: json['escola_id'] as String?,
      escolaNome: json['escola_nome'] as String?,
      segmentoId: json['segmento_id'] as String?,
      segmentoNome: json['segmento_nome'] as String?,
      turnoId: json['turno_id'] as String?,
      turnoNome: json['turno_nome'] as String?,
      serieId: json['serie_id'] as String?,
      serieNome: json['serie_nome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'escola_id': escolaId,
      'escola_nome': escolaNome,
      'segmento_id': segmentoId,
      'segmento_nome': segmentoNome,
      'turno_id': turnoId,
      'turno_nome': turnoNome,
      'serie_id': serieId,
      'serie_nome': serieNome,
    };
  }

  /// Retorna uma descrição detalhada da opção baseada no tipo
  String get descricaoCompleta {
    switch (tipo) {
      case 'escola':
        return nome;
      case 'segmento':
        return nome;
      case 'turno':
        return nome;
      case 'serie':
        return '$nome (${segmentoNome ?? ''} - ${turnoNome ?? ''})';
      case 'turma':
        return '$nome - ${serieNome ?? ''} (${segmentoNome ?? ''})';
      default:
        return nome;
    }
  }

  /// Verifica se esta opção é compatível com outros filtros selecionados
  bool isCompativel({
    String? escolaSelecionada,
    String? segmentoSelecionado,
    String? turnoSelecionado,
    String? serieSelecionada,
  }) {
    switch (tipo) {
      case 'escola':
        return true; // Escolas são sempre compatíveis
      case 'segmento':
        return true; // Segmentos são sempre compatíveis
      case 'turno':
        return true; // Turnos são sempre compatíveis
      case 'serie':
        return (escolaSelecionada == null || escolaId == escolaSelecionada) &&
            (segmentoSelecionado == null ||
                segmentoId == segmentoSelecionado) &&
            (turnoSelecionado == null || turnoId == turnoSelecionado);
      case 'turma':
        return (escolaSelecionada == null || escolaId == escolaSelecionada) &&
            (segmentoSelecionado == null ||
                segmentoId == segmentoSelecionado) &&
            (turnoSelecionado == null || turnoId == turnoSelecionado) &&
            (serieSelecionada == null || serieId == serieSelecionada);
      default:
        return true;
    }
  }
}

class FiltrosAluno {
  final String? turmaId;
  final String? serieId;
  final String? turnoId;
  final String? segmentoId;
  final String? escolaId;
  final String? matricula;
  final String? nome;
  final int? anoLetivo;

  FiltrosAluno({
    this.turmaId,
    this.serieId,
    this.turnoId,
    this.segmentoId,
    this.escolaId,
    this.matricula,
    this.nome,
    this.anoLetivo,
  });

  Map<String, dynamic> toJson() {
    return {
      'p_turma_id': turmaId,
      'p_serie_id': serieId,
      'p_turno_id': turnoId,
      'p_segmento_id': segmentoId,
      'p_escola_id': escolaId,
      'p_matricula': matricula,
      'p_nome': nome,
      'p_ano_letivo': anoLetivo,
    };
  }

  FiltrosAluno copyWith({
    String? turmaId,
    String? serieId,
    String? turnoId,
    String? segmentoId,
    String? escolaId,
    String? matricula,
    String? nome,
    int? anoLetivo,
    bool clearTurmaId = false,
    bool clearSerieId = false,
    bool clearTurnoId = false,
    bool clearSegmentoId = false,
    bool clearEscolaId = false,
    bool clearMatricula = false,
    bool clearNome = false,
    bool clearAnoLetivo = false,
  }) {
    return FiltrosAluno(
      turmaId: clearTurmaId ? null : turmaId ?? this.turmaId,
      serieId: clearSerieId ? null : serieId ?? this.serieId,
      turnoId: clearTurnoId ? null : turnoId ?? this.turnoId,
      segmentoId: clearSegmentoId ? null : segmentoId ?? this.segmentoId,
      escolaId: clearEscolaId ? null : escolaId ?? this.escolaId,
      matricula: clearMatricula ? null : matricula ?? this.matricula,
      nome: clearNome ? null : nome ?? this.nome,
      anoLetivo: clearAnoLetivo ? null : anoLetivo ?? this.anoLetivo,
    );
  }

  bool get hasFilters {
    return turmaId != null ||
        serieId != null ||
        turnoId != null ||
        segmentoId != null ||
        escolaId != null ||
        (matricula != null && matricula!.isNotEmpty) ||
        (nome != null && nome!.isNotEmpty) ||
        anoLetivo != null;
  }
}
