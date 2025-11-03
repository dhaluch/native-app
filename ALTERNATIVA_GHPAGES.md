# 🔧 Versão Alternativa - GitHub Pages Deploy Action

Se você continuar tendo problemas com o workflow customizado, aqui está uma versão alternativa mais simples usando a action oficial `peaceiris/actions-gh-pages`:

## 📝 Substitua o job `publish-gh-pages` por esta versão:

```yaml
  publish-gh-pages:
    runs-on: ubuntu-latest
    needs: test
    if: always() && (github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/heads/feature/'))
    permissions:
      contents: write
      pages: write
      id-token: write

    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 📥 Download test artifacts
        uses: actions/download-artifact@v4
        with:
          name: ${{ needs.test.outputs.artifact_name }}
          path: ./robot-reports

      - name: 📁 Prepare reports structure
        env:
          BRANCH: ${{ needs.test.outputs.branch }}
          DATE: ${{ needs.test.outputs.date }}
          DATETIME: ${{ needs.test.outputs.datetime }}
        run: |
          # Criar estrutura para publicação
          mkdir -p public
          
          # Criar diretório para esta execução
          SAFE_BRANCH=$(echo "$BRANCH" | sed 's#[/\\:*?"<>|]#-#g')
          REPORT_DIR="public/${SAFE_BRANCH}/${DATE}"
          mkdir -p "${REPORT_DIR}"
          
          # Copiar relatórios
          cp -r ./robot-reports/* "${REPORT_DIR}/"
          
          # Criar index.html principal
          cat > public/index.html << 'HTML'
          <!DOCTYPE html>
          <html lang="pt-BR">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Robot Framework Test Reports</title>
              <style>
                  body { font-family: Arial, sans-serif; margin: 40px; background: #f8f9fa; }
                  .container { max-width: 1200px; margin: 0 auto; }
                  .header { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 30px; }
                  .report-item { background: white; border: 1px solid #e1e5e9; padding: 20px; margin: 15px 0; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
                  .branch-name { color: #0969da; font-weight: bold; font-size: 1.1em; }
                  .date { color: #656d76; font-size: 0.9em; margin: 5px 0; }
                  .links { margin-top: 10px; }
                  .links a { 
                      display: inline-block; margin-right: 15px; padding: 8px 16px; 
                      background: #0969da; color: white; text-decoration: none; 
                      border-radius: 6px; font-size: 0.9em;
                  }
                  .links a:hover { background: #0550ae; }
                  .latest { border-left: 4px solid #28a745; }
                  .emoji { font-size: 1.2em; margin-right: 8px; }
              </style>
          </head>
          <body>
              <div class="container">
                  <div class="header">
                      <h1><span class="emoji">🤖</span>Robot Framework Test Reports</h1>
                      <p>Relatórios de testes automatizados gerados pelo GitHub Actions</p>
                  </div>
          HTML
          
          # Adicionar execução atual
          cat >> public/index.html << HTML
                  <div class="report-item latest">
                      <h3><span class="emoji">📊</span>Execução Mais Recente</h3>
                      <div class="branch-name">Branch: ${BRANCH}</div>
                      <div class="date">Data: ${DATETIME}</div>
                      <div class="links">
                          <a href="${SAFE_BRANCH}/${DATE}/report.html" target="_blank">📋 Report</a>
                          <a href="${SAFE_BRANCH}/${DATE}/log.html" target="_blank">📄 Log</a>
                      </div>
                  </div>
          HTML
          
          # Finalizar HTML
          cat >> public/index.html << 'HTML'
                  
                  <div style="margin-top: 40px; padding: 20px; border-top: 1px solid #e1e5e9; color: #656d76; font-size: 0.9em; text-align: center;">
                      <p>🔄 Atualizado automaticamente pelo GitHub Actions</p>
                  </div>
              </div>
          </body>
          </html>
          HTML

      - name: 🚀 Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GH_PAGES_PAT }}
          publish_dir: ./public
          keep_files: true
          user_name: 'github-actions[bot]'
          user_email: '41898282+github-actions[bot]@users.noreply.github.com'
          commit_message: '📊 Deploy Robot Framework reports (${{ needs.test.outputs.branch }} - ${{ needs.test.outputs.datetime }})'

      - name: 📢 Comment on PR with report links (if PR)
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        env:
          BRANCH: ${{ needs.test.outputs.branch }}
          DATE: ${{ needs.test.outputs.date }}
        with:
          github-token: ${{ secrets.GH_PAGES_PAT }}
          script: |
            const branch = process.env.BRANCH;
            const date = process.env.DATE;
            const safeBranch = branch.replace(/[/\\:*?"<>|]/g, '-');
            const owner = context.repo.owner;
            const repo = context.repo.repo;
            const pagesUrl = `https://${owner}.github.io/${repo}/`;
            
            const reportUrl = `${pagesUrl}${safeBranch}/${date}/report.html`;
            const logUrl = `${pagesUrl}${safeBranch}/${date}/log.html`;
            
            const commentBody = `## 🤖 Robot Framework Test Reports
            
            Os relatórios de teste foram gerados e publicados no GitHub Pages:
            
            - 📋 **[Report HTML](${reportUrl})**
            - 📄 **[Log HTML](${logUrl})**  
            - 📂 **[Todos os Reports](${pagesUrl})**
            
            > Branch: \`${branch}\` | Data: \`${date}\``;
            
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: commentBody
            });
```

## 🔄 Como aplicar esta versão:

1. **Substitua o job completo** no arquivo `.github/workflows/robot-tests.yml`
2. **Mantenha o secret** `GH_PAGES_PAT` configurado
3. **Execute um teste** para validar

## ✅ Vantagens desta versão:

- **Mais simples** e menos propensa a erros
- **Action oficial** testada e mantida
- **Evita conflitos** com git branches
- **Mantém arquivos existentes** com `keep_files: true`
- **Interface mais bonita** com CSS aprimorado

## 🚨 Se ainda der erro:

Execute este comando no seu repositório para limpar qualquer conflito:

```bash
# Remover qualquer pasta ou arquivo gh-pages local
rm -rf gh-pages
git rm -rf gh-pages 2>/dev/null || true
git commit -m "Clean gh-pages conflicts" 2>/dev/null || true
```