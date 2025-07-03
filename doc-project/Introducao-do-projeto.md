Documentação do Banco de Dados e Fluxo do Projeto

1. Visão Geral

Este projeto é uma aplicação web destinada a facilitar a gestão e a visualização da estrutura escolar de uma instituição de ensino, bem como o processamento e compartilhamento de álbuns de fotos escolares. A interface permite:
	•	Importar a estrutura escolar em JSON (escolas, segmentos, séries, turnos, turmas) e dados de alunos em CSV.
	•	Filtrar dinamicamente por segmento, série, turno e turma, usando selects interativos.
	•	Pesquisar alunos por matrícula ou nome.
	•	Gerenciar permissões de acesso e compartilhamento de álbuns de fotos por escola, série, turma ou aluno.

O objetivo principal é dar autonomia a gestores, coordenadores e equipes administrativas para validar e organizar grandes volumes de dados escolares, além de fornecer um repositório digital organizado de fotos.

⸻

2. Modelo de Dados

O banco está em Terceira Forma Normal (3FN), com tabelas de entidades e tabelas de junção para relações N:N.

2.1. Entidades Principais

Tabela	Descrição
usuarios	Armazena usuários do sistema (admin, moderador, responsável, aluno).
escolas	Informações cadastrais de cada unidade escolar.
segmentos	Segmentos educacionais (Educação Infantil, Fundamental, Médio).
turnos	Turnos de funcionamento (manhã, tarde, noite).
series	Séries vinculadas a um turno, segmento e escola.
turmas	Turmas específicas de uma série e escola.
albuns	Álbuns de fotos escolares, com data do evento e tipo de acesso.
fotos	Fotos individuais associadas a um álbum.
logs_auditoria	Registro de ações de auditoria (inserções, atualizações, exclusões).

2.2. Tabelas de Junção N:N

Junção	Propósito
usuarios_escolas	Relaciona usuários e escolas (permissões gerais de acesso).
alunos_turmas	Associa alunos (usuarios) às turmas para controle de matrícula e ano letivo.
responsaveis_alunos	Liga responsáveis a alunos, permitindo múltiplos responsáveis por aluno e vice-versa.
albuns_escolas	Define em quais escolas um álbum estará disponível (quando tipo_acesso = por_serie ou por_turma, etc.).
albuns_series	Define em quais séries um álbum está disponível.
albuns_turmas	Define em quais turmas um álbum está disponível.
albuns_alunos	Acesso individual a álbuns por aluno.

Cada tabela de junção possui chave primária composta, garantindo unicidade sem atributos redundantes.

⸻

3. Relacionamentos

3.1. Relações 1:N
	1.	escolas.id → series.escola_id
	2.	turnos.id → series.turno_id
	3.	segmentos.id → series.segmento_id
	4.	series.id → turmas.serie_id
	5.	escolas.id → turmas.escola_id
	6.	usuarios.id → albuns.criado_por_id
	7.	albuns.id → fotos.album_id

Em todos os casos, uma entidade “pai” pode ter vários “filhos”, mas cada filho pertence a um único pai.

3.2. Relações N:N

Para cada associação N:N, o sistema usa tabelas de junção sem campos adicionais além dos necessários para referência e auditoria:
	•	Fluxo para determinar quais álbuns um aluno vê:
	1.	Usuário (aluno) → alunos_turmas: obtém turmas.
	2.	albuns_turmas ou albuns_series ou albuns_escolas: filtra álbuns conforme regra de tipo_acesso.
	3.	fotos → retorna imagens do álbum.
	•	Fluxo para responsável:
	1.	Usuário (responsável) → responsaveis_alunos: obtém lista de alunos.
	2.	Repete o fluxo de aluno para cada filho.

⸻

4. Normalização
	1.	1FN: Atributos atômicos; sem listas embutidas.
	2.	2FN: Tabelas com chave composta (alunos_turmas, etc.) não têm dependências parciais.
	3.	3FN: Cada coluna não-chave depende apenas da chave primária, sem dependências transitivas.

⸻

5. Fluxo de Uso da Ferramenta
	1.	Upload de Estrutura: JSON contendo escolas, segmentos, turnos, series e turmas.
	2.	Upload de Dados de Alunos: CSV com campos como matricula, nome, usuario_id, etc.
	3.	Interação na Interface:
	•	Dropdowns (selects) para Segmento → Série → Turno → Turma.
	•	Filtro dinâmico: altera listas conforme seleção.
	•	Pesquisa livre por matrícula ou nome.
	4.	Gerenciamento de Álbuns:
	•	Criação de álbum com tipo_acesso (por série, turma, aluno ou personalizado).
	•	Associação a entidades via tabelas de junção.
	•	Upload e consulta de fotos.
	•	Compartilhamento seguro baseado em permissões geradas.

⸻

6. Padrões e Boas Práticas
	•	UUIDs para chaves primárias, garantindo unicidade distribuída.
	•	Enums (user_type, tipo_acesso) padronizam valores restritos.
	•	Defaults (created_at, updated_at) garantem auditoria automática.
	•	Tabelas de junção sem colunas desnecessárias, mantendo a modelagem enxuta e normalizada.

⸻

Esta documentação reflete a estrutura observada no dump enviado e nas práticas de modelagem adotadas pelo projeto.