Enum user_type {
  admin
  moderador
  responsavel
  aluno
}

Enum tipo_acesso {
  por_serie
  por_turma
  por_aluno
  personalizado
}

Table usuarios {
  id uuid [pk]
  nome varchar
  email varchar
  senha varchar
  tipo user_type      
  cpf varchar
  rg varchar
  celular varchar
  logradouro varchar
  complemento varchar
  bairro varchar
  cidade varchar
  uf char(2)
  cep varchar
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table escolas {
  id uuid [pk]
  nome varchar
  cidade varchar
  estado char(2)
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table segmentos {
  id uuid [pk]
  nome varchar
  is_extra_curricular boolean
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table turnos {
  id uuid [pk]
  nome varchar
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table series {
  id uuid [pk]
  nome varchar
  turno_id uuid [ref: > turnos.id]
  escola_id uuid [ref: > escolas.id]
  segmento_id uuid [ref: > segmentos.id]
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table turmas {
  id uuid [pk]
  nome varchar
  serie_id uuid [ref: > series.id]
  escola_id uuid [ref: > escolas.id]
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table alunos_turmas {
  usuario_id uuid [ref: > usuarios.id]
  turma_id uuid [ref: > turmas.id]
  matricula varchar
  ano_letivo int
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
  Note: "Composite PK (usuario_id, turma_id)"
}

Table responsaveis_alunos {
  usuario_id uuid [ref: > usuarios.id]
  aluno_usuario_id uuid [ref: > usuarios.id]
  parentesco varchar
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
  Note: "Composite PK (usuario_id, aluno_usuario_id)"
}

Table usuarios_escolas {
  usuario_id uuid [ref: > usuarios.id]
  escola_id uuid [ref: > escolas.id]
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
  Note: "Composite PK (usuario_id, escola_id)"
}

Table albuns {
  id uuid [pk]
  titulo varchar
  descricao text
  data_evento date
  tipo_acesso tipo_acesso
  criado_por_id uuid [ref: > usuarios.id]
  ativo boolean
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table albuns_escolas {
  album_id uuid [ref: > albuns.id]
  escola_id uuid [ref: > escolas.id]
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
  Note: "Composite PK (album_id, escola_id)"
}

Table albuns_series {
  album_id uuid [ref: > albuns.id]
  serie_id uuid [ref: > series.id]
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
  Note: "Composite PK (album_id, serie_id)"
}

Table albuns_turmas {
  album_id uuid [ref: > albuns.id]
  turma_id uuid [ref: > turmas.id]
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
  Note: "Composite PK (album_id, turma_id)"
}

Table albuns_alunos {
  album_id uuid [ref: > albuns.id]
  aluno_id uuid [ref: > usuarios.id]
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
  Note: "Composite PK (album_id, aluno_id)"
}

Table fotos {
  id uuid [pk]
  album_id uuid [ref: > albuns.id]
  caminho_arquivo varchar
  qualidade int
  criado_por_id uuid [ref: > usuarios.id]
  created_by uuid
  updated_by uuid
  created_at timestamp
  updated_at timestamp
}

Table logs_auditoria {
  id uuid [pk]
  tabela varchar
  registro_id uuid
  acao varchar
  usuario_id uuid
  data_hora timestamp
  origem varchar
  detalhes text
}