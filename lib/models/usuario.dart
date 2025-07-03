class Usuario {
  final String id;
  final String nome;
  final String? email;
  final String? senha;
  final UserType tipo;
  final String? cpf;
  final String? rg;
  final String? celular;
  final String? telefone;
  final String? telOutro;
  final String? logradouro;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? uf;
  final String? cep;
  final bool ativo;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Usuario({
    required this.id,
    required this.nome,
    this.email,
    this.senha,
    required this.tipo,
    this.cpf,
    this.rg,
    this.celular,
    this.telefone,
    this.telOutro,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.cidade,
    this.uf,
    this.cep,
    this.ativo = true,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String?,
      senha: json['senha'] as String?,
      tipo: UserType.fromString(json['tipo'] as String),
      cpf: json['cpf'] as String?,
      rg: json['rg'] as String?,
      celular: json['celular'] as String?,
      telefone: json['telefone'] as String?,
      telOutro: json['tel_outro'] as String?,
      logradouro: json['logradouro'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      cidade: json['cidade'] as String?,
      uf: json['uf'] as String?,
      cep: json['cep'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo.value,
      'cpf': cpf,
      'rg': rg,
      'celular': celular,
      'telefone': telefone,
      'tel_outro': telOutro,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'cep': cep,
      'ativo': ativo,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

enum UserType {
  admin('admin'),
  moderador('moderador'),
  responsavel('responsavel'),
  aluno('aluno');

  const UserType(this.value);

  final String value;

  static UserType fromString(String value) {
    switch (value) {
      case 'admin':
        return UserType.admin;
      case 'moderador':
        return UserType.moderador;
      case 'responsavel':
        return UserType.responsavel;
      case 'aluno':
        return UserType.aluno;
      default:
        throw ArgumentError('Tipo de usuário inválido: $value');
    }
  }

  String get displayName {
    switch (this) {
      case UserType.admin:
        return 'Administrador';
      case UserType.moderador:
        return 'Moderador';
      case UserType.responsavel:
        return 'Responsável';
      case UserType.aluno:
        return 'Aluno';
    }
  }
}
