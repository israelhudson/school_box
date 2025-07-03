# 🚀 Guia de Migração: Supabase Local → Remoto

## Visão Geral

Este guia te ajuda a migrar seus dados do Supabase local para o Supabase remoto de forma segura e eficiente.

## 📋 Pré-requisitos

- [x] Supabase CLI instalado
- [x] Conta no Supabase
- [x] Projeto remoto criado
- [x] Supabase local funcionando

## 🔧 Preparação

### 1. Instalar o Supabase CLI (se não tiver)
```bash
npm install -g supabase
```

### 2. Fazer login no Supabase
```bash
supabase login
```

### 3. Obter as credenciais do projeto remoto
1. Acesse [supabase.com/dashboard](https://supabase.com/dashboard)
2. Selecione seu projeto
3. Vá em **Settings** → **API**
4. Copie:
   - **Project URL**
   - **anon** key
   - **service_role** key

## 🚀 Métodos de Migração

### **Método 1: Migração Automática (Recomendado)**

1. **Executar o script de migração:**
```bash
chmod +x migrate_to_remote.sh
./migrate_to_remote.sh
```

2. **Linkar ao projeto remoto:**
```bash
supabase link --project-ref SEU_PROJECT_REF
```

### **Método 2: Migração Manual**

#### **Passo 1: Criar dumps**
```bash
# Dump do esquema
supabase db dump --local --schema public -f esquema.sql

# Dump dos dados
supabase db dump --local --schema public --data-only -f dados.sql
```

#### **Passo 2: Aplicar no remoto**
```bash
# Aplicar esquema
supabase db push

# Para os dados, use o Supabase Studio (SQL Editor)
```

### **Método 3: Usando Migrações (Profissional)**

#### **Passo 1: Criar migração**
```bash
supabase migration new initial_schema
supabase db diff --local -f initial_schema
```

#### **Passo 2: Aplicar migração**
```bash
supabase db push
```

## ⚙️ Configuração do Flutter

### 1. Atualizar credenciais
Edite `lib/config/supabase_config.dart`:

```dart
// Configuração Remota
static const String remoteUrl = 'https://SEU_PROJECT_REF.supabase.co';
static const String remoteAnonKey = 'SUA_ANON_KEY_AQUI';
static const String remoteServiceRoleKey = 'SUA_SERVICE_ROLE_KEY_AQUI';

// Mudar para usar remoto
static const bool useLocal = false; // ← Mude para false
```

### 2. Testar a conexão
```bash
flutter run -d chrome
```

## 📊 Estrutura do Banco Migrado

Suas tabelas que serão migradas:

- ✅ **usuarios** - Usuários do sistema
- ✅ **escolas** - Unidades escolares
- ✅ **segmentos** - Segmentos educacionais
- ✅ **turnos** - Turnos de funcionamento
- ✅ **series** - Séries por escola
- ✅ **turmas** - Turmas específicas
- ✅ **albuns** - Álbuns de fotos
- ✅ **fotos** - Fotos individuais
- ✅ **logs_auditoria** - Logs de auditoria

## 🔍 Verificação Pós-Migração

### 1. Verificar tabelas no Supabase Studio
- Acesse o painel do projeto remoto
- Vá em **Table Editor**
- Verifique se todas as tabelas estão lá

### 2. Testar queries básicas
```sql
-- Contar registros
SELECT COUNT(*) FROM usuarios;
SELECT COUNT(*) FROM escolas;
SELECT COUNT(*) FROM alunos;
```

### 3. Testar autenticação
- Teste login/logout
- Verifique RLS (Row Level Security)

## 🛠️ Solução de Problemas

### ❌ Erro: "Project not linked"
```bash
supabase link --project-ref SEU_PROJECT_REF
```

### ❌ Erro: "Permission denied"
- Verifique se tem permissão de admin no projeto
- Confirme se a service_role key está correta

### ❌ Erro: "Migration failed"
- Verifique se há conflitos de nomes
- Tente aplicar o schema manualmente

### ❌ Erro: "Authentication failed"
```bash
supabase logout
supabase login
```

## 📝 Checklist Final

- [ ] Supabase CLI configurado
- [ ] Projeto remoto criado
- [ ] Dados migrados com sucesso
- [ ] Configuração do Flutter atualizada
- [ ] Testes realizados
- [ ] Aplicação funcionando no remoto

## 🚨 Dicas Importantes

1. **Faça backup** dos dados locais antes de migrar
2. **Teste em ambiente de desenvolvimento** primeiro
3. **Verifique permissões** RLS após migração
4. **Monitore logs** para possíveis erros
5. **Mantenha credenciais seguras** (use .env)

## 🔐 Segurança

- Nunca commite credenciais no Git
- Use variáveis de ambiente para produção
- Configure RLS adequadamente
- Revise permissões de acesso

## 📞 Suporte

Se encontrar problemas:
1. Verifique logs do Supabase
2. Consulte a documentação oficial
3. Use o Discord da comunidade Supabase
4. Abra uma issue no GitHub (se aplicável)

---

**Sucesso! 🎉** Seu projeto agora está rodando no Supabase remoto! 