# 🛠️ Configurar GitHub Pages - Passo a Passo

## 📋 Passos para Habilitar GitHub Pages

### 1. **Acessar Configurações do Repositório**
- Vá para: `https://github.com/israelhudson/school_box`
- Clique em **Settings** (Configurações)

### 2. **Configurar GitHub Pages**
- No menu lateral, clique em **Pages**
- Em **Source**, selecione: **Deploy from a branch**
- Em **Branch**, selecione: **gh-pages**
- Em **Folder**, selecione: **/ (root)**
- Clique em **Save**

### 3. **Aguardar o Deploy**
- O GitHub Actions irá executar automaticamente
- Você pode acompanhar em: **Actions** → **Deploy Flutter Web to GitHub Pages**

### 4. **Verificar o Status**
- ✅ **Build**: Deve completar sem erros
- ✅ **Deploy**: Deve publicar na branch `gh-pages`
- ✅ **Pages**: Deve estar ativo

### 5. **Acessar a Aplicação**
Sua aplicação estará disponível em:
```
https://israelhudson.github.io/school_box/
```

## 🔍 **Verificar se Funcionou**

1. **GitHub Actions**: Deve mostrar ✅ verde
2. **Branch gh-pages**: Deve ser criada automaticamente
3. **URL do site**: Deve estar acessível

## 📊 **Status Atual**

- ✅ **Código**: Commitado e enviado
- ✅ **GitHub Actions**: Configurado
- ✅ **Build Web**: Funcionando
- ✅ **Supabase**: Conectado ao remoto
- ⏳ **GitHub Pages**: Aguardando configuração manual

## 🚨 **Solução de Problemas**

### Problema: GitHub Actions falha
**Solução**: Verificar se as permissões do GITHUB_TOKEN estão corretas:
- Settings → Actions → General → Workflow permissions
- Selecionar "Read and write permissions"

### Problema: 404 na URL
**Solução**: Aguardar alguns minutos para propagação do DNS

### Problema: Página em branco
**Solução**: Verificar se a base-href está correta no build

## 📞 **Próximos Passos**

1. **Configurar GitHub Pages** seguindo os passos acima
2. **Aguardar o deploy** (5-10 minutos)
3. **Testar a aplicação** na URL fornecida
4. **Configurar domínio customizado** (opcional)

## 🎯 **Resultado Final**

Após a configuração, você terá:
- **App Flutter Web** rodando no GitHub Pages
- **Deploy automático** a cada push na main
- **Supabase remoto** funcionando
- **PWA instalável** no navegador
- **URL pública** para compartilhar 