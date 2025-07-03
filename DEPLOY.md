# 🚀 Deploy do School Box no GitHub Pages

## Configuração Automática

O deploy do **School Box** no GitHub Pages é feito automaticamente através do GitHub Actions sempre que há um push na branch `main`.

### 📋 Pré-requisitos

1. ✅ Repositório no GitHub
2. ✅ GitHub Actions configurado
3. ✅ GitHub Pages habilitado

### 🔧 Configuração Manual (se necessário)

Se você precisar configurar manualmente:

1. **Habilitar GitHub Pages:**
   - Vá nas configurações do repositório
   - Seção "Pages"
   - Source: "Deploy from a branch"
   - Branch: `gh-pages`
   - Folder: `/ (root)`

2. **Configurar Base URL (se necessário):**
   ```bash
   flutter build web --base-href="/school_box/"
   ```

### 🌐 URL de Acesso

Após o deploy, a aplicação estará disponível em:
```
https://israelhudson.github.io/school_box/
```

### 📊 Status do Deploy

- ✅ **Supabase:** Conectado ao projeto remoto
- ✅ **GitHub Actions:** Configurado
- ✅ **Build Web:** Otimizado para produção
- ✅ **PWA:** Suporte a Progressive Web App

### 🔄 Processo de Deploy

1. **Push na main** → Trigger do GitHub Actions
2. **Setup Flutter** → Instala ambiente
3. **Get Dependencies** → Baixa dependências
4. **Analyze Code** → Verifica código
5. **Build Web** → Gera build otimizado
6. **Deploy** → Publica no GitHub Pages

### 🛠️ Comandos Úteis

```bash
# Build local para teste
flutter build web --release

# Build com base-href customizado
flutter build web --base-href="/school_box/"

# Servir localmente
flutter build web && python -m http.server 8000 --directory build/web
```

### 📝 Notas

- O deploy é feito automaticamente a cada push na branch `main`
- A aplicação usa HTML renderer para melhor compatibilidade
- Os dados são carregados do Supabase remoto
- PWA configurado para instalação offline 