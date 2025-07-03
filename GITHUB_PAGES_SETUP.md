# 🚀 Setup do GitHub Pages - School Box

## O que é a branch gh-pages?

A branch `gh-pages` é uma branch **especial** criada automaticamente pelo GitHub Actions que contém apenas os arquivos necessários para servir o site. Ela é diferente da branch `main`:

- **Branch main**: Contém todo o código fonte do Flutter
- **Branch gh-pages**: Contém apenas os arquivos compilados (HTML, CSS, JS) prontos para servir

## Como funciona o processo

1. **Você faz push na branch main** → Dispara o GitHub Actions
2. **GitHub Actions faz o build** → `flutter build web --release` 
3. **GitHub Actions cria/atualiza a branch gh-pages** → Com conteúdo de `build/web/`
4. **GitHub Pages serve o site** → A partir da branch gh-pages

## Verificando se está funcionando

### 1. Verificar se o GitHub Actions executou
- Vá para: `https://github.com/SEU_USUARIO/school_box/actions`
- Deve mostrar workflows executando ou concluídos

### 2. Verificar se a branch gh-pages foi criada
```bash
# Listar todas as branches
git branch -a

# Atualizar branches remotas
git fetch origin

# Verificar novamente
git branch -a
```

### 3. Verificar configurações do GitHub Pages
1. No GitHub, vá para: **Settings** → **Pages**
2. Em "Source", deve estar: **Deploy from a branch**
3. Branch: **gh-pages**
4. Folder: **/ (root)**

## URLs corretas

- ✅ **URL correta**: `https://SEU_USUARIO.github.io/school_box/`
- ❌ **URL incorreta**: `https://SEU_USUARIO.github.io/school_box/web/`

## Troubleshooting

### Problema: "404 - flutter.js not found"
**Possíveis causas:**
1. GitHub Actions não executou
2. Branch gh-pages não foi criada
3. Configuração do GitHub Pages incorreta
4. Problemas no index.html

**Solução:**
- Verificar se o workflow executou sem erros
- Verificar se a branch gh-pages existe
- Aguardar alguns minutos após o deploy

### Problema: "Página mostra apenas README"
**Causa:** GitHub Pages está servindo da branch main, não da gh-pages
**Solução:** Ir em Settings → Pages e configurar para branch gh-pages

### Problema: "_flutter is not defined"
**Causa:** Problemas na inicialização do Flutter
**Solução:** Já corrigido no index.html (API nova do Flutter)

## Verificações importantes

1. **Workflow executou?** 
   - https://github.com/SEU_USUARIO/school_box/actions
   
2. **Branch gh-pages existe?**
   ```bash
   git fetch origin
   git branch -a | grep gh-pages
   ```

3. **Configuração está correta?**
   - Settings → Pages → Source: "Deploy from a branch"
   - Branch: gh-pages, Folder: / (root)

## Últimas correções aplicadas

✅ **Removido CNAME** que pode causar conflitos
✅ **Adicionadas permissões** ao workflow (contents: read, pages: write)
✅ **Corrigido index.html** para usar nova API do Flutter
✅ **Corrigidos warnings** de meta tags deprecated

## Próximos passos

1. Aguardar o GitHub Actions terminar (~2-5 minutos)
2. Verificar se a branch gh-pages foi criada
3. Testar a URL: `https://SEU_USUARIO.github.io/school_box/`
4. Se ainda não funcionar, verificar a configuração do GitHub Pages

---

**Importante:** O GitHub Pages pode levar alguns minutos para propagar as mudanças. Seja paciente! 🕐

## 🛠️ Configurar GitHub Pages - Passo a Passo

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