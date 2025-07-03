class AlunoDetalhado {
  // Dados do usuário/aluno
  final String usuarioId;
  final String nome;
  final String? email;
  final String? cpf;
  final String? celular;
  final String? cidade;
  final bool ativo;

  // Dados da matrícula
  final String? matricula;
  final int? anoLetivo;
  final bool matriculaAtiva;

  // Dados da turma
  final String turmaId;
  final String turmaNome;

  // Dados da série
  final String serieId;
  final String serieNome;

  // Dados do turno
  final String turnoId;
  final String turnoNome;

  // Dados do segmento
  final String segmentoId;
  final String segmentoNome;

  // Dados da escola
  final String escolaId;
  final String escolaNome;
  final String? escolaCidade;
  final String? escolaEstado;

  AlunoDetalhado({
    required this.usuarioId,
    required this.nome,
    this.email,
    this.cpf,
    this.celular,
    this.cidade,
    required this.ativo,
    this.matricula,
    this.anoLetivo,
    required this.matriculaAtiva,
    required this.turmaId,
    required this.turmaNome,
    required this.serieId,
    required this.serieNome,
    required this.turnoId,
    required this.turnoNome,
    required this.segmentoId,
    required this.segmentoNome,
    required this.escolaId,
    required this.escolaNome,
    this.escolaCidade,
    this.escolaEstado,
  });

  factory AlunoDetalhado.fromJson(Map<String, dynamic> json) {
    return AlunoDetalhado(
      usuarioId: json['usuario_id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String?,
      cpf: json['cpf'] as String?,
      celular: json['celular'] as String?,
      cidade: json['cidade'] as String?,
      ativo: json['ativo'] as bool,
      matricula: json['matricula'] as String?,
      anoLetivo: json['ano_letivo'] as int?,
      matriculaAtiva: json['matricula_ativa'] as bool,
      turmaId: json['turma_id'] as String,
      turmaNome: json['turma_nome'] as String,
      serieId: json['serie_id'] as String,
      serieNome: json['serie_nome'] as String,
      turnoId: json['turno_id'] as String,
      turnoNome: json['turno_nome'] as String,
      segmentoId: json['segmento_id'] as String,
      segmentoNome: json['segmento_nome'] as String,
      escolaId: json['escola_id'] as String,
      escolaNome: json['escola_nome'] as String,
      escolaCidade: json['escola_cidade'] as String?,
      escolaEstado: json['escola_estado'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'celular': celular,
      'cidade': cidade,
      'ativo': ativo,
      'matricula': matricula,
      'ano_letivo': anoLetivo,
      'matricula_ativa': matriculaAtiva,
      'turma_id': turmaId,
      'turma_nome': turmaNome,
      'serie_id': serieId,
      'serie_nome': serieNome,
      'turno_id': turnoId,
      'turno_nome': turnoNome,
      'segmento_id': segmentoId,
      'segmento_nome': segmentoNome,
      'escola_id': escolaId,
      'escola_nome': escolaNome,
      'escola_cidade': escolaCidade,
      'escola_estado': escolaEstado,
    };
  }

  /// Retorna o nome completo da localização escolar
  String get localizacaoCompleta {
    final partes = <String>[];
    partes.add(escolaNome);
    partes.add(segmentoNome);
    partes.add(serieNome);
    partes.add(turmaNome);
    partes.add('(${turnoNome})');
    return partes.join(' - ');
  }

  /// Retorna informações de identificação do aluno
  String get identificacao {
    final partes = <String>[];
    if (matricula != null) partes.add('Mat: $matricula');
    if (anoLetivo != null) partes.add('Ano: $anoLetivo');
    return partes.isNotEmpty ? partes.join(' | ') : 'Sem matrícula';
  }
}
