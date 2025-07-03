# Supabase Local - School Box

## 🚀 Configuração Atual

O Supabase está configurado e rodando localmente com as seguintes informações:

### URLs de Acesso
- **Studio (Interface gráfica)**: http://127.0.0.1:54323
- **API URL**: http://127.0.0.1:54321
- **GraphQL URL**: http://127.0.0.1:54321/graphql/v1
- **Database URL**: postgresql://postgres:postgres@127.0.0.1:54322/postgres
- **Storage URL**: http://127.0.0.1:54321/storage/v1/s3

### Chaves de Acesso
- **anon key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0`
- **service_role key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU`

## 📋 Comandos Úteis

### Iniciar o Supabase
```bash
supabase start
```

### Parar o Supabase
```bash
supabase stop
```

### Ver Status
```bash
supabase status
```

### Resetar o Banco (cuidado!)
```bash
supabase db reset
```

### Aplicar Migrações
```bash
supabase db push
```

## 🗄️ Estrutura do Banco

O banco foi importado com o dump localizado em `assets/estrutura-banco-sql-supabase/dump-21h01m31s-02-07-2025.sql` e contém toda a estrutura do projeto School Box.

## 🔧 Configuração no Flutter

A configuração do Supabase no Flutter está localizada em `lib/config/supabase_config.dart`.

## 🌐 Acesso ao Studio

Para acessar a interface gráfica do Supabase:
1. Certifique-se de que o Supabase está rodando (`supabase start`)
2. Abra o navegador em: http://127.0.0.1:54323
3. Use a interface para gerenciar tabelas, dados, autenticação, etc.

## 📚 Próximos Passos

1. Adicionar as dependências do Supabase ao `pubspec.yaml`
2. Configurar a inicialização do Supabase no `main.dart`
3. Criar serviços para autenticação e operações do banco
4. Implementar as telas do projeto conectando com o Supabase 