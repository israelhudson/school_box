# 📊 Como Aplicar os Dados no Projeto Remoto

## 🎯 Status da Migração

✅ **ESTRUTURA MIGRADA:** Todas as 16 tabelas criadas  
✅ **CONFIGURAÇÃO ATUALIZADA:** App usando projeto remoto  
✅ **APLICAÇÃO RODANDO:** Conectando ao Supabase remoto  
⏳ **DADOS PENDENTES:** 1913 linhas para aplicar  

## 🚀 Formas de Aplicar os Dados

### **Método 1: Supabase Studio (Recomendado)**

1. **Acesse o Supabase Studio:**
   ```
   https://supabase.com/dashboard/project/oguadbjnpxhedcsvfvtd
   ```

2. **Vá no SQL Editor:**
   - Clique em "SQL Editor" no menu lateral
   - Clique em "New query"

3. **Copie e cole o conteúdo de `backup_dados.sql`:**
   ```bash
   # Abrir o arquivo
   open backup_dados.sql
   ```
   - Copie todo o conteúdo
   - Cole no SQL Editor
   - Clique em "Run"

### **Método 2: Via Terminal (Avançado)**

```bash
# Conectar diretamente ao PostgreSQL remoto
psql "postgresql://postgres:[SUA_SENHA]@db.oguadbjnpxhedcsvfvtd.supabase.co:5432/postgres" -f backup_dados.sql
```

## 📋 Dados Disponíveis para Migração

O arquivo `backup_dados.sql` contém dados para:
- usuarios
- escolas  
- segmentos
- turnos
- series
- turmas
- albuns
- fotos
- E relacionamentos entre elas

## ✅ Verificação Pós-Migração

Após aplicar os dados, teste:

1. **No Supabase Studio:**
   ```sql
   SELECT COUNT(*) FROM usuarios;
   SELECT COUNT(*) FROM escolas;
   SELECT COUNT(*) FROM fotos;
   ```

2. **Na sua aplicação:**
   - Teste login/logout
   - Navegue pelas páginas
   - Verifique se os dados aparecem

## 🔧 Resolução de Problemas

### ❌ Erro: "Duplicate key value"
- Indica que alguns dados já existem
- Use `ON CONFLICT DO NOTHING` nas queries

### ❌ Erro: "Foreign key constraint"
- Aplique os dados em ordem:
  1. Tabelas principais (usuarios, escolas)
  2. Tabelas de relacionamento

### ❌ Erro: "Permission denied"
- Verifique se está usando a service_role_key
- Confirme permissões RLS

## 🚨 Importante

- **Faça backup** antes de aplicar dados em produção
- **Teste em ambiente de desenvolvimento** primeiro
- **Monitore logs** durante a aplicação
- **Verifique integridade** dos dados após migração

---

**🎉 Após aplicar os dados, sua migração estará 100% completa!** 