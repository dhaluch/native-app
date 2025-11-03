# 🚀 Configuração do GitHub Pages para Reports do Robot Framework

Este documento explica como configurar o Personal Access Token (PAT) para que os relatórios do Robot Framework sejam automaticamente publicados no GitHub Pages.

## 📋 Pré-requisitos

1. Repositório no GitHub
2. GitHub Actions habilitado
3. Permissões de administrador no repositório

## 🔑 Passo 1: Criar Personal Access Token (PAT)

1. Acesse [GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)](https://github.com/settings/tokens)

2. Clique em **"Generate new token"** → **"Generate new token (classic)"**

3. Configure o token:
   - **Note/Description**: `Robot Framework Reports - [NOME_DO_SEU_REPOSITORIO]`
   - **Expiration**: `90 days` ou `No expiration` (não recomendado para produção)
   - **Scopes/Permissions**:
     - ✅ `repo` (Full control of private repositories)
     - ✅ `workflow` (Update GitHub Action workflows)
     - ✅ `write:packages` (Write packages to GitHub Package Registry)

4. Clique em **"Generate token"**

5. **⚠️ IMPORTANTE**: Copie o token gerado e guarde em local seguro (ele só é mostrado uma vez)

## 🔐 Passo 2: Configurar Secret no Repositório

1. Vá para o seu repositório no GitHub

2. Clique em **Settings** (aba do repositório)

3. No menu lateral, clique em **Secrets and variables** → **Actions**

4. Clique em **"New repository secret"**

5. Configure o secret:
   - **Name**: `GH_PAGES_PAT`
   - **Secret**: Cole o token PAT gerado no Passo 1

6. Clique em **"Add secret"**

## 🌐 Passo 3: Habilitar GitHub Pages

1. No repositório, vá em **Settings** → **Pages**

2. Em **Source**, selecione:
   - **Deploy from a branch**
   - **Branch**: `gh-pages`
   - **Folder**: `/ (root)`

3. Clique em **Save**

4. Aguarde alguns minutos para o site ser publicado

## 📊 Como Funciona

### Execução Automática

O workflow será executado automaticamente quando:
- **Push** para branches `feature/*`
- **Pull Request** para `main`
- **Execução manual** via workflow_dispatch

### Estrutura dos Reports

Os relatórios são organizados da seguinte forma:
```
https://SEU_USUARIO.github.io/SEU_REPOSITORIO/
├── index.html (página principal com links)
├── feature-nome-da-branch/
│   └── 2024-01-15/
│       ├── report.html
│       ├── log.html
│       └── output.xml
└── main/
    └── 2024-01-15/
        ├── report.html
        ├── log.html
        └── output.xml
```

### Links nos Pull Requests

Quando executado em um Pull Request, o bot automaticamente adicionará um comentário com links diretos para os relatórios gerados.

## 🔧 Troubleshooting

### Erro: "Remote rejected"
- Verifique se o PAT tem as permissões corretas
- Confirme se o secret `GH_PAGES_PAT` está configurado corretamente

### GitHub Pages não carrega
- Aguarde alguns minutos após a primeira execução
- Verifique se a branch `gh-pages` foi criada
- Confirme se GitHub Pages está habilitado no repositório

### Reports não aparecem
- Verifique os logs do job `publish-gh-pages`
- Confirme se os testes geraram os arquivos `report.html` e `log.html`

## 🔍 URLs de Exemplo

Após configurado, você poderá acessar:

- **Página principal**: `https://SEU_USUARIO.github.io/SEU_REPOSITORIO/`
- **Report específico**: `https://SEU_USUARIO.github.io/SEU_REPOSITORIO/main/2024-01-15/report.html`
- **Log específico**: `https://SEU_USUARIO.github.io/SEU_REPOSITORIO/main/2024-01-15/log.html`

## 🚨 Segurança

- ⚠️ **Nunca** commit o PAT no código
- 🔄 Renove o PAT regularmente (recomendado: 90 dias)
- 🔐 Use apenas as permissões mínimas necessárias
- 👥 Para organizações, considere usar GitHub Apps ao invés de PAT pessoal

---

✅ **Configuração Completa!** Agora os relatórios do Robot Framework serão automaticamente publicados no GitHub Pages a cada execução dos testes.