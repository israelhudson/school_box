

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE TYPE "public"."tipo_acesso" AS ENUM (
    'por_serie',
    'por_turma',
    'por_aluno',
    'personalizado'
);


ALTER TYPE "public"."tipo_acesso" OWNER TO "postgres";


CREATE TYPE "public"."user_type" AS ENUM (
    'admin',
    'moderador',
    'responsavel',
    'aluno'
);


ALTER TYPE "public"."user_type" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."buscar_alunos_por_filtros"("p_turma_id" "uuid" DEFAULT NULL::"uuid", "p_serie_id" "uuid" DEFAULT NULL::"uuid", "p_turno_id" "uuid" DEFAULT NULL::"uuid", "p_segmento_id" "uuid" DEFAULT NULL::"uuid", "p_escola_id" "uuid" DEFAULT NULL::"uuid", "p_matricula" character varying DEFAULT NULL::character varying, "p_nome" character varying DEFAULT NULL::character varying, "p_ano_letivo" integer DEFAULT NULL::integer) RETURNS TABLE("usuario_id" "uuid", "nome" character varying, "email" character varying, "cpf" character varying, "celular" character varying, "cidade" character varying, "ativo" boolean, "matricula" character varying, "ano_letivo" integer, "matricula_ativa" boolean, "turma_id" "uuid", "turma_nome" character varying, "serie_id" "uuid", "serie_nome" character varying, "turno_id" "uuid", "turno_nome" character varying, "segmento_id" "uuid", "segmento_nome" character varying, "escola_id" "uuid", "escola_nome" character varying, "escola_cidade" character varying, "escola_estado" character)
    LANGUAGE "sql"
    AS $$
SELECT 
    -- Dados do usuário/aluno
    u.id as usuario_id,
    u.nome,
    u.email,
    u.cpf,
    u.celular,
    u.cidade,
    u.ativo,
    
    -- Dados da matrícula
    at.matricula,
    at.ano_letivo,
    at.ativo as matricula_ativa,
    
    -- Dados da turma
    t.id as turma_id,
    t.nome as turma_nome,
    
    -- Dados da série
    s.id as serie_id,
    s.nome as serie_nome,
    
    -- Dados do turno
    tn.id as turno_id,
    tn.nome as turno_nome,
    
    -- Dados do segmento
    sg.id as segmento_id,
    sg.nome as segmento_nome,
    
    -- Dados da escola
    e.id as escola_id,
    e.nome as escola_nome,
    e.cidade as escola_cidade,
    e.estado as escola_estado
    
FROM usuarios u
    INNER JOIN alunos_turmas at ON u.id = at.usuario_id
    INNER JOIN turmas t ON at.turma_id = t.id
    INNER JOIN series s ON t.serie_id = s.id
    INNER JOIN turnos tn ON s.turno_id = tn.id
    INNER JOIN segmentos sg ON s.segmento_id = sg.id
    INNER JOIN escolas e ON s.escola_id = e.id
    
WHERE u.tipo = 'aluno'
    AND u.ativo = true
    AND at.ativo = true
    AND t.ativo = true
    AND s.ativo = true
    AND tn.ativo = true
    AND sg.ativo = true
    AND e.ativo = true
    AND (p_turma_id IS NULL OR t.id = p_turma_id)
    AND (p_serie_id IS NULL OR s.id = p_serie_id)
    AND (p_turno_id IS NULL OR tn.id = p_turno_id)
    AND (p_segmento_id IS NULL OR sg.id = p_segmento_id)
    AND (p_escola_id IS NULL OR e.id = p_escola_id)
    AND (p_matricula IS NULL OR at.matricula ILIKE '%' || p_matricula || '%')
    AND (p_nome IS NULL OR u.nome ILIKE '%' || p_nome || '%')
    AND (p_ano_letivo IS NULL OR at.ano_letivo = p_ano_letivo)
    
ORDER BY u.nome, at.matricula;
$$;


ALTER FUNCTION "public"."buscar_alunos_por_filtros"("p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid", "p_segmento_id" "uuid", "p_escola_id" "uuid", "p_matricula" character varying, "p_nome" character varying, "p_ano_letivo" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."buscar_filtros_alunos"() RETURNS TABLE("tipo" character varying, "id" "uuid", "nome" character varying, "escola_id" "uuid", "escola_nome" character varying, "segmento_id" "uuid", "segmento_nome" character varying, "turno_id" "uuid", "turno_nome" character varying, "serie_id" "uuid", "serie_nome" character varying)
    LANGUAGE "sql"
    AS $$
SELECT 
    'escola'::varchar as tipo,
    e.id,
    e.nome,
    e.id as escola_id,
    e.nome as escola_nome,
    NULL::uuid as segmento_id,
    NULL::varchar as segmento_nome,
    NULL::uuid as turno_id,
    NULL::varchar as turno_nome,
    NULL::uuid as serie_id,
    NULL::varchar as serie_nome
FROM escolas e
WHERE e.ativo = true

UNION ALL

SELECT 
    'segmento'::varchar as tipo,
    sg.id,
    sg.nome,
    NULL::uuid as escola_id,
    NULL::varchar as escola_nome,
    sg.id as segmento_id,
    sg.nome as segmento_nome,
    NULL::uuid as turno_id,
    NULL::varchar as turno_nome,
    NULL::uuid as serie_id,
    NULL::varchar as serie_nome
FROM segmentos sg
WHERE sg.ativo = true

UNION ALL

SELECT 
    'turno'::varchar as tipo,
    tn.id,
    tn.nome,
    NULL::uuid as escola_id,
    NULL::varchar as escola_nome,
    NULL::uuid as segmento_id,
    NULL::varchar as segmento_nome,
    tn.id as turno_id,
    tn.nome as turno_nome,
    NULL::uuid as serie_id,
    NULL::varchar as serie_nome
FROM turnos tn
WHERE tn.ativo = true

UNION ALL

SELECT 
    'serie'::varchar as tipo,
    s.id,
    s.nome,
    s.escola_id,
    e.nome as escola_nome,
    s.segmento_id,
    sg.nome as segmento_nome,
    s.turno_id,
    tn.nome as turno_nome,
    s.id as serie_id,
    s.nome as serie_nome
FROM series s
    INNER JOIN escolas e ON s.escola_id = e.id
    INNER JOIN segmentos sg ON s.segmento_id = sg.id
    INNER JOIN turnos tn ON s.turno_id = tn.id
WHERE s.ativo = true AND e.ativo = true AND sg.ativo = true AND tn.ativo = true

UNION ALL

SELECT 
    'turma'::varchar as tipo,
    t.id,
    t.nome,
    t.escola_id,
    e.nome as escola_nome,
    s.segmento_id,
    sg.nome as segmento_nome,
    s.turno_id,
    tn.nome as turno_nome,
    s.id as serie_id,
    s.nome as serie_nome
FROM turmas t
    INNER JOIN series s ON t.serie_id = s.id
    INNER JOIN escolas e ON t.escola_id = e.id
    INNER JOIN segmentos sg ON s.segmento_id = sg.id
    INNER JOIN turnos tn ON s.turno_id = tn.id
WHERE t.ativo = true AND s.ativo = true AND e.ativo = true AND sg.ativo = true AND tn.ativo = true

ORDER BY tipo, nome;
$$;


ALTER FUNCTION "public"."buscar_filtros_alunos"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_buscar_alunos"("p_nome" character varying DEFAULT NULL::character varying, "p_matricula" character varying DEFAULT NULL::character varying, "p_escola_id" "uuid" DEFAULT NULL::"uuid", "p_turma_id" "uuid" DEFAULT NULL::"uuid", "p_serie_id" "uuid" DEFAULT NULL::"uuid", "p_turno_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("usuario_id" "uuid", "nome" character varying, "matricula" character varying, "turma" character varying, "serie" character varying, "turno" character varying, "escola" character varying, "ano_letivo" integer)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
    SELECT 
      u.id,
      u.nome,
      at.matricula,
      t.nome AS turma,
      s.nome AS serie,
      tu.nome AS turno,
      e.nome AS escola,
      at.ano_letivo
    FROM usuarios u
    JOIN alunos_turmas at ON at.usuario_id = u.id
    JOIN turmas t ON t.id = at.turma_id
    JOIN series s ON s.id = t.serie_id
    JOIN turnos tu ON tu.id = s.turno_id
    JOIN escolas e ON e.id = t.escola_id
    WHERE u.tipo = 'aluno'
      AND (p_nome IS NULL OR u.nome ILIKE '%' || p_nome || '%')
      AND (p_matricula IS NULL OR at.matricula = p_matricula)
      AND (p_escola_id IS NULL OR e.id = p_escola_id)
      AND (p_turma_id IS NULL OR t.id = p_turma_id)
      AND (p_serie_id IS NULL OR s.id = p_serie_id)
      AND (p_turno_id IS NULL OR tu.id = p_turno_id)
    ORDER BY at.ano_letivo DESC, u.nome;
END;
$$;


ALTER FUNCTION "public"."fn_buscar_alunos"("p_nome" character varying, "p_matricula" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_matricula" character varying, "p_turma_id" "uuid", "p_ano_letivo" integer, "p_responsaveis" "uuid"[]) RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_aluno_id uuid;
    v_now timestamp := now();
    v_usuario_id uuid;
BEGIN
    -- 1. Insere o usuário
    INSERT INTO usuarios (
        nome, email, senha, tipo, cpf, rg, celular,
        logradouro, complemento, bairro, cidade, uf, cep,
        created_at, updated_at, user_type
    ) VALUES (
        p_nome, p_email, p_senha, NULL, p_cpf, p_rg, p_celular,
        p_logradouro, p_complemento, p_bairro, p_cidade, p_uf, p_cep,
        v_now, v_now, 'aluno'
    )
    RETURNING id INTO v_aluno_id;

    -- 2. Insere na tabela alunos_turmas
    INSERT INTO alunos_turmas (aluno_id, turma_id, ano_letivo)
    VALUES (v_aluno_id, p_turma_id, p_ano_letivo);

    -- 3. Associa os responsáveis ao aluno
    IF p_responsaveis IS NOT NULL THEN
        FOREACH v_usuario_id IN ARRAY p_responsaveis
        LOOP
            INSERT INTO responsaveis_alunos (aluno_id, responsavel_id)
            VALUES (v_aluno_id, v_usuario_id);
        END LOOP;
    END IF;

    RETURN v_aluno_id;
END;
$$;


ALTER FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_matricula" character varying, "p_turma_id" "uuid", "p_ano_letivo" integer, "p_responsaveis" "uuid"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_ano_letivo" integer, "p_matricula" character varying, "p_created_by" "uuid") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_usuario_id uuid;
BEGIN
  INSERT INTO usuarios (
    nome, email, senha, tipo, cpf, rg, celular, logradouro, complemento, bairro, cidade, uf, cep, created_by
  ) VALUES (
    p_nome, p_email, p_senha, 'aluno', p_cpf, p_rg, p_celular, p_logradouro, p_complemento, p_bairro, p_cidade, p_uf, p_cep, p_created_by
  ) RETURNING id INTO v_usuario_id;

  -- associa à escola (opcional)
  INSERT INTO usuarios_escolas (usuario_id, escola_id, created_by)
    VALUES (v_usuario_id, p_escola_id, p_created_by);

  -- vincula na turma do ano letivo
  INSERT INTO alunos_turmas (usuario_id, turma_id, ano_letivo, matricula, created_by)
    VALUES (v_usuario_id, p_turma_id, p_ano_letivo, p_matricula, p_created_by);

  RETURN v_usuario_id;
END;
$$;


ALTER FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_ano_letivo" integer, "p_matricula" character varying, "p_created_by" "uuid") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."albuns" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "titulo" character varying NOT NULL,
    "descricao" "text",
    "data_evento" "date",
    "tipo_acesso" "public"."tipo_acesso" NOT NULL,
    "criado_por_id" "uuid",
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."albuns" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."albuns_alunos" (
    "album_id" "uuid" NOT NULL,
    "aluno_usuario_id" "uuid" NOT NULL,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."albuns_alunos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."albuns_escolas" (
    "album_id" "uuid" NOT NULL,
    "escola_id" "uuid" NOT NULL,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."albuns_escolas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."albuns_series" (
    "album_id" "uuid" NOT NULL,
    "serie_id" "uuid" NOT NULL,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."albuns_series" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."albuns_turmas" (
    "album_id" "uuid" NOT NULL,
    "turma_id" "uuid" NOT NULL,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."albuns_turmas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."alunos_turmas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "usuario_id" "uuid" NOT NULL,
    "turma_id" "uuid" NOT NULL,
    "ano_letivo" integer NOT NULL,
    "matricula" character varying,
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."alunos_turmas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."escolas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" character varying NOT NULL,
    "cidade" character varying,
    "estado" character varying,
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."escolas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fotos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "album_id" "uuid",
    "caminho_arquivo" character varying,
    "qualidade" integer,
    "criado_por_id" "uuid",
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."fotos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."logs_auditoria" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tabela" character varying,
    "registro_id" "uuid",
    "acao" character varying,
    "usuario_id" "uuid",
    "data_hora" timestamp without time zone DEFAULT "now"(),
    "origem" character varying DEFAULT 'trigger'::character varying,
    "detalhes" "text"
);


ALTER TABLE "public"."logs_auditoria" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."responsaveis_alunos" (
    "usuario_id" "uuid" NOT NULL,
    "aluno_usuario_id" "uuid" NOT NULL,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."responsaveis_alunos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."segmentos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" character varying NOT NULL,
    "is_extra_curricular" boolean DEFAULT false,
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."segmentos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."series" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" character varying NOT NULL,
    "segmento_id" "uuid" NOT NULL,
    "turno_id" "uuid" NOT NULL,
    "escola_id" "uuid" NOT NULL,
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."series" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."turmas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" character varying NOT NULL,
    "serie_id" "uuid" NOT NULL,
    "escola_id" "uuid" NOT NULL,
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."turmas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."turnos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" character varying NOT NULL,
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."turnos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."usuarios" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" character varying NOT NULL,
    "email" character varying,
    "senha" character varying,
    "tipo" "public"."user_type" NOT NULL,
    "cpf" character varying,
    "rg" character varying,
    "celular" character varying,
    "logradouro" character varying,
    "complemento" character varying,
    "bairro" character varying,
    "cidade" character varying,
    "uf" character varying,
    "cep" character varying,
    "ativo" boolean DEFAULT true,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"(),
    "telefone" character varying(20),
    "tel_outro" character varying(20)
);


ALTER TABLE "public"."usuarios" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."usuarios_escolas" (
    "usuario_id" "uuid" NOT NULL,
    "escola_id" "uuid" NOT NULL,
    "created_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "updated_by" "uuid" DEFAULT '00000000-0000-0000-0000-000000000000'::"uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."usuarios_escolas" OWNER TO "postgres";


ALTER TABLE ONLY "public"."albuns_alunos"
    ADD CONSTRAINT "albuns_alunos_pkey" PRIMARY KEY ("album_id", "aluno_usuario_id");



ALTER TABLE ONLY "public"."albuns_escolas"
    ADD CONSTRAINT "albuns_escolas_pkey" PRIMARY KEY ("album_id", "escola_id");



ALTER TABLE ONLY "public"."albuns"
    ADD CONSTRAINT "albuns_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."albuns_series"
    ADD CONSTRAINT "albuns_series_pkey" PRIMARY KEY ("album_id", "serie_id");



ALTER TABLE ONLY "public"."albuns_turmas"
    ADD CONSTRAINT "albuns_turmas_pkey" PRIMARY KEY ("album_id", "turma_id");



ALTER TABLE ONLY "public"."alunos_turmas"
    ADD CONSTRAINT "alunos_turmas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."escolas"
    ADD CONSTRAINT "escolas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fotos"
    ADD CONSTRAINT "fotos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."logs_auditoria"
    ADD CONSTRAINT "logs_auditoria_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."responsaveis_alunos"
    ADD CONSTRAINT "responsaveis_alunos_pkey" PRIMARY KEY ("usuario_id", "aluno_usuario_id");



ALTER TABLE ONLY "public"."segmentos"
    ADD CONSTRAINT "segmentos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."series"
    ADD CONSTRAINT "series_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."turmas"
    ADD CONSTRAINT "turmas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."turnos"
    ADD CONSTRAINT "turnos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."usuarios_escolas"
    ADD CONSTRAINT "usuarios_escolas_pkey" PRIMARY KEY ("usuario_id", "escola_id");



ALTER TABLE ONLY "public"."usuarios"
    ADD CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."albuns_alunos"
    ADD CONSTRAINT "albuns_alunos_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albuns"("id");



ALTER TABLE ONLY "public"."albuns_alunos"
    ADD CONSTRAINT "albuns_alunos_aluno_usuario_id_fkey" FOREIGN KEY ("aluno_usuario_id") REFERENCES "public"."usuarios"("id");



ALTER TABLE ONLY "public"."albuns"
    ADD CONSTRAINT "albuns_criado_por_id_fkey" FOREIGN KEY ("criado_por_id") REFERENCES "public"."usuarios"("id");



ALTER TABLE ONLY "public"."albuns_escolas"
    ADD CONSTRAINT "albuns_escolas_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albuns"("id");



ALTER TABLE ONLY "public"."albuns_escolas"
    ADD CONSTRAINT "albuns_escolas_escola_id_fkey" FOREIGN KEY ("escola_id") REFERENCES "public"."escolas"("id");



ALTER TABLE ONLY "public"."albuns_series"
    ADD CONSTRAINT "albuns_series_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albuns"("id");



ALTER TABLE ONLY "public"."albuns_series"
    ADD CONSTRAINT "albuns_series_serie_id_fkey" FOREIGN KEY ("serie_id") REFERENCES "public"."series"("id");



ALTER TABLE ONLY "public"."albuns_turmas"
    ADD CONSTRAINT "albuns_turmas_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albuns"("id");



ALTER TABLE ONLY "public"."albuns_turmas"
    ADD CONSTRAINT "albuns_turmas_turma_id_fkey" FOREIGN KEY ("turma_id") REFERENCES "public"."turmas"("id");



ALTER TABLE ONLY "public"."alunos_turmas"
    ADD CONSTRAINT "alunos_turmas_turma_id_fkey" FOREIGN KEY ("turma_id") REFERENCES "public"."turmas"("id");



ALTER TABLE ONLY "public"."alunos_turmas"
    ADD CONSTRAINT "alunos_turmas_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."usuarios"("id");



ALTER TABLE ONLY "public"."fotos"
    ADD CONSTRAINT "fotos_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albuns"("id");



ALTER TABLE ONLY "public"."fotos"
    ADD CONSTRAINT "fotos_criado_por_id_fkey" FOREIGN KEY ("criado_por_id") REFERENCES "public"."usuarios"("id");



ALTER TABLE ONLY "public"."responsaveis_alunos"
    ADD CONSTRAINT "responsaveis_alunos_aluno_usuario_id_fkey" FOREIGN KEY ("aluno_usuario_id") REFERENCES "public"."usuarios"("id");



ALTER TABLE ONLY "public"."responsaveis_alunos"
    ADD CONSTRAINT "responsaveis_alunos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."usuarios"("id");



ALTER TABLE ONLY "public"."series"
    ADD CONSTRAINT "series_escola_id_fkey" FOREIGN KEY ("escola_id") REFERENCES "public"."escolas"("id");



ALTER TABLE ONLY "public"."series"
    ADD CONSTRAINT "series_segmento_id_fkey" FOREIGN KEY ("segmento_id") REFERENCES "public"."segmentos"("id");



ALTER TABLE ONLY "public"."series"
    ADD CONSTRAINT "series_turno_id_fkey" FOREIGN KEY ("turno_id") REFERENCES "public"."turnos"("id");



ALTER TABLE ONLY "public"."turmas"
    ADD CONSTRAINT "turmas_escola_id_fkey" FOREIGN KEY ("escola_id") REFERENCES "public"."escolas"("id");



ALTER TABLE ONLY "public"."turmas"
    ADD CONSTRAINT "turmas_serie_id_fkey" FOREIGN KEY ("serie_id") REFERENCES "public"."series"("id");



ALTER TABLE ONLY "public"."usuarios_escolas"
    ADD CONSTRAINT "usuarios_escolas_escola_id_fkey" FOREIGN KEY ("escola_id") REFERENCES "public"."escolas"("id");



ALTER TABLE ONLY "public"."usuarios_escolas"
    ADD CONSTRAINT "usuarios_escolas_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."usuarios"("id");



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."buscar_alunos_por_filtros"("p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid", "p_segmento_id" "uuid", "p_escola_id" "uuid", "p_matricula" character varying, "p_nome" character varying, "p_ano_letivo" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."buscar_alunos_por_filtros"("p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid", "p_segmento_id" "uuid", "p_escola_id" "uuid", "p_matricula" character varying, "p_nome" character varying, "p_ano_letivo" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."buscar_alunos_por_filtros"("p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid", "p_segmento_id" "uuid", "p_escola_id" "uuid", "p_matricula" character varying, "p_nome" character varying, "p_ano_letivo" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."buscar_filtros_alunos"() TO "anon";
GRANT ALL ON FUNCTION "public"."buscar_filtros_alunos"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."buscar_filtros_alunos"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_buscar_alunos"("p_nome" character varying, "p_matricula" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_buscar_alunos"("p_nome" character varying, "p_matricula" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_buscar_alunos"("p_nome" character varying, "p_matricula" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_serie_id" "uuid", "p_turno_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_matricula" character varying, "p_turma_id" "uuid", "p_ano_letivo" integer, "p_responsaveis" "uuid"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_matricula" character varying, "p_turma_id" "uuid", "p_ano_letivo" integer, "p_responsaveis" "uuid"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_matricula" character varying, "p_turma_id" "uuid", "p_ano_letivo" integer, "p_responsaveis" "uuid"[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_ano_letivo" integer, "p_matricula" character varying, "p_created_by" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_ano_letivo" integer, "p_matricula" character varying, "p_created_by" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_cadastrar_aluno"("p_nome" character varying, "p_email" character varying, "p_senha" character varying, "p_cpf" character varying, "p_rg" character varying, "p_celular" character varying, "p_logradouro" character varying, "p_complemento" character varying, "p_bairro" character varying, "p_cidade" character varying, "p_uf" character varying, "p_cep" character varying, "p_escola_id" "uuid", "p_turma_id" "uuid", "p_ano_letivo" integer, "p_matricula" character varying, "p_created_by" "uuid") TO "service_role";



GRANT ALL ON TABLE "public"."albuns" TO "anon";
GRANT ALL ON TABLE "public"."albuns" TO "authenticated";
GRANT ALL ON TABLE "public"."albuns" TO "service_role";



GRANT ALL ON TABLE "public"."albuns_alunos" TO "anon";
GRANT ALL ON TABLE "public"."albuns_alunos" TO "authenticated";
GRANT ALL ON TABLE "public"."albuns_alunos" TO "service_role";



GRANT ALL ON TABLE "public"."albuns_escolas" TO "anon";
GRANT ALL ON TABLE "public"."albuns_escolas" TO "authenticated";
GRANT ALL ON TABLE "public"."albuns_escolas" TO "service_role";



GRANT ALL ON TABLE "public"."albuns_series" TO "anon";
GRANT ALL ON TABLE "public"."albuns_series" TO "authenticated";
GRANT ALL ON TABLE "public"."albuns_series" TO "service_role";



GRANT ALL ON TABLE "public"."albuns_turmas" TO "anon";
GRANT ALL ON TABLE "public"."albuns_turmas" TO "authenticated";
GRANT ALL ON TABLE "public"."albuns_turmas" TO "service_role";



GRANT ALL ON TABLE "public"."alunos_turmas" TO "anon";
GRANT ALL ON TABLE "public"."alunos_turmas" TO "authenticated";
GRANT ALL ON TABLE "public"."alunos_turmas" TO "service_role";



GRANT ALL ON TABLE "public"."escolas" TO "anon";
GRANT ALL ON TABLE "public"."escolas" TO "authenticated";
GRANT ALL ON TABLE "public"."escolas" TO "service_role";



GRANT ALL ON TABLE "public"."fotos" TO "anon";
GRANT ALL ON TABLE "public"."fotos" TO "authenticated";
GRANT ALL ON TABLE "public"."fotos" TO "service_role";



GRANT ALL ON TABLE "public"."logs_auditoria" TO "anon";
GRANT ALL ON TABLE "public"."logs_auditoria" TO "authenticated";
GRANT ALL ON TABLE "public"."logs_auditoria" TO "service_role";



GRANT ALL ON TABLE "public"."responsaveis_alunos" TO "anon";
GRANT ALL ON TABLE "public"."responsaveis_alunos" TO "authenticated";
GRANT ALL ON TABLE "public"."responsaveis_alunos" TO "service_role";



GRANT ALL ON TABLE "public"."segmentos" TO "anon";
GRANT ALL ON TABLE "public"."segmentos" TO "authenticated";
GRANT ALL ON TABLE "public"."segmentos" TO "service_role";



GRANT ALL ON TABLE "public"."series" TO "anon";
GRANT ALL ON TABLE "public"."series" TO "authenticated";
GRANT ALL ON TABLE "public"."series" TO "service_role";



GRANT ALL ON TABLE "public"."turmas" TO "anon";
GRANT ALL ON TABLE "public"."turmas" TO "authenticated";
GRANT ALL ON TABLE "public"."turmas" TO "service_role";



GRANT ALL ON TABLE "public"."turnos" TO "anon";
GRANT ALL ON TABLE "public"."turnos" TO "authenticated";
GRANT ALL ON TABLE "public"."turnos" TO "service_role";



GRANT ALL ON TABLE "public"."usuarios" TO "anon";
GRANT ALL ON TABLE "public"."usuarios" TO "authenticated";
GRANT ALL ON TABLE "public"."usuarios" TO "service_role";



GRANT ALL ON TABLE "public"."usuarios_escolas" TO "anon";
GRANT ALL ON TABLE "public"."usuarios_escolas" TO "authenticated";
GRANT ALL ON TABLE "public"."usuarios_escolas" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";






RESET ALL;
