#!/bin/bash

# Script para migrar dados do Supabase local para o remoto
# Autor: Assistente IA
# Data: Janeiro 2025

echo "🚀 Migração do Supabase Local para Remoto"
echo "========================================"
echo

# Verificar se o Supabase CLI está instalado
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI não encontrado. Instale com:"
    echo "npm install -g supabase"
    exit 1
fi

echo "✅ Supabase CLI encontrado"

# Verificar se está logado
echo "🔐 Verificando autenticação..."
if ! supabase status &> /dev/null; then
    echo "❌ Você precisa estar logado no Supabase."
    echo "Execute: supabase login"
    exit 1
fi

echo "✅ Autenticação OK"

# Verificar se o projeto está linkado
echo "🔗 Verificando se o projeto está linkado..."
if [ ! -f .env ]; then
    echo "❌ Projeto não está linkado. Execute:"
    echo "supabase link --project-ref SEU_PROJECT_REF"
    exit 1
fi

echo "✅ Projeto linkado"

# Opções de migração
echo
echo "Escolha o método de migração:"
echo "1) Migração completa (esquema + dados)"
echo "2) Apenas esquema"
echo "3) Apenas dados"
echo "4) Criar migrações"
echo

read -p "Digite sua opção (1-4): " opcao

case $opcao in
    1)
        echo "🔄 Iniciando migração completa..."
        
        # Criar dump do esquema
        echo "📋 Criando dump do esquema..."
        supabase db dump --local --schema public -f backup_esquema.sql
        
        # Criar dump dos dados
        echo "📦 Criando dump dos dados..."
        supabase db dump --local --schema public --data-only -f backup_dados.sql
        
        # Aplicar esquema no remoto
        echo "🔧 Aplicando esquema no remoto..."
        supabase db push
        
        echo "✅ Migração completa finalizada!"
        echo "📝 Agora você pode executar o backup_dados.sql manualmente no Supabase Studio"
        ;;
    2)
        echo "🔄 Migrando apenas esquema..."
        supabase db diff --local -f esquema_migrado
        supabase db push
        echo "✅ Esquema migrado com sucesso!"
        ;;
    3)
        echo "🔄 Criando dump de dados..."
        supabase db dump --local --schema public --data-only -f dados_migrados.sql
        echo "✅ Dados exportados para dados_migrados.sql"
        echo "📝 Execute este arquivo no Supabase Studio do seu projeto remoto"
        ;;
    4)
        echo "🔄 Criando migrações..."
        supabase migration new initial_schema
        supabase db diff --local -f initial_schema
        echo "✅ Migração criada! Execute 'supabase db push' para aplicar"
        ;;
    *)
        echo "❌ Opção inválida"
        exit 1
        ;;
esac

echo
echo "🎉 Processo concluído!"
echo "📚 Próximos passos:"
echo "1. Atualize lib/config/supabase_config.dart com suas credenciais remotas"
echo "2. Mude 'useLocal' para 'false' na configuração"
echo "3. Teste sua aplicação com o banco remoto"
echo 