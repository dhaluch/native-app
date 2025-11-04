# Troubleshooting Guide — Robot Framework Mobile (Appium + Android)

Guia prático para diagnosticar e resolver problemas comuns nos testes Mobile (Android) com Robot Framework + Appium, localmente e no GitHub Actions.

---

## 📋 Índice

1. [Problemas na Pipeline (CI/CD)](#problemas-na-pipeline-cicd)
2. [Problemas com Appium/Emulador Android](#problemas-com-appiumemulador-android)
3. [Problemas com Robot Framework](#problemas-com-robot-framework)
4. [Publicação no GitHub Pages (Reports)](#publicação-no-github-pages-reports)
5. [Dependências e Ambiente](#dependências-e-ambiente)
6. [Diferenças Local vs CI](#diferenças-local-vs-ci)
7. [Diagnóstico Rápido (Comandos úteis)](#diagnóstico-rápido-comandos-úteis)
8. [Checklist de Verificação Rápida](#checklist-de-verificação-rápida)
9. [Links Úteis e Documentos do Projeto](#links-úteis-e-documentos-do-projeto)

---

## 🔧 Problemas na Pipeline (CI/CD)

### 1) Erro: "System UI isn't responding" / ANR no emulador

**Sintoma:**
- Durante o boot/execução do emulador no CI, testes falham com dialogs de ANR.

**Causas comuns:**
- Recursos insuficientes do emulador no runner
- Inicialização do sistema não estabilizada antes dos testes

**Soluções aplicadas neste repo:**
- Emulador com mais recursos (-memory 4096, -cores 2, -partition-size 6144)
- Flags e propriedades anti-ANR no workflow
- Passos de estabilização com ADB (aguarda boot completo e serviços)

Veja: `CORRECAO_SYSTEM_UI.md` e o job do emulador em `.github/workflows/robot-tests.yml`.

### 2) Erro ao publicar no gh-pages (403, branch ambígua, etc.)

**Sintomas:**
- `Permission denied to github-actions[bot]`
- `fatal: 'gh-pages' could be both a local file and a tracking branch`

**Causas:**
- Uso do token padrão sem permissão para Pages
- Conflito com pasta/arquivo local chamado `gh-pages`

**Soluções aplicadas:**
- Uso da action `peaceiris/actions-gh-pages@v3` com `GH_PAGES_PAT`
- Remoção de manipulação manual conflituosa de branch

Docs: `GITHUB_PAGES_SETUP.md`, `CORRECAO_GHPAGES.md`, `ALTERNATIVA_GHPAGES.md`.

### 3) Workflow não dispara em `feature/**`

No workflow, verifique os triggers. Exemplo:

```yaml
on:
  push:
    branches: [ main, 'feature/**' ]
  pull_request:
    branches: [ main ]
```

---

## 🤖 Problemas com Appium/Emulador Android

### 1) SessionNotCreatedException: tipo inválido em `waitForIdleTimeout`

**Sintoma:**
```
Invalid 'waitForIdleTimeout' setting value type. Got: java.lang.String. Expected: java.lang.Long.
```

**Causa:**
- Algumas configurações do UIAutomator2 são "settings" e, quando enviadas como capabilities via Robot, podem virar strings.

**Correção recomendada:**
- Remova `appium:waitForIdleTimeout` das capabilities em `resources/base.resource`
- Após abrir a sessão, aplique via setting numérica:

```robot
# Após Open Application
Set Appium Setting    waitForIdleTimeout    10000
```

> Dica: Use apenas números (sem aspas). Outros ajustes relacionados: `waitForQuiescence`, `idleTimeout` etc.

### 2) "No application is open" durante setup/teardown

**Causa:**
- A sessão Appium não foi criada (falha anterior) e keywords tentam usar a app mesmo assim.

**Aplique:**
- Garanta a ordem correta em `Start session` (veja `resources/base.resource`).
- Use `TRY/EXCEPT` e logs para continuar o fluxo quando apropriado. Veja `CORRECAO_SETUP_FAILED.md`.

### 3) Appium server não inicializa ou porta ocupada

- Confirme no CI o step "Start Appium server" e aguarde + verificação.
- Localmente:

```powershell
appium --versions
appium
```

Se a porta (4723) estiver ocupada, encerre processos ou inicie em outra porta.

### 4) UIAutomator2 driver não instalado/versão

No CI já instalamos com:
```bash
appium driver install uiautomator2@4.0.1
```
Localmente, verifique:
```powershell
appium driver list
appium driver install uiautomator2
```

### 5) APK não encontrado

**Sintoma:** `❌ APK não encontrado`.

- Verifique o caminho em `resources/base.resource` e no workflow:
  - `${EXECDIR}/app/wdio.native.app.apk`
  - `app/wdio.native.app.apk`
- Confirme o arquivo dentro do repo.

### 6) ADB/Emulador: dispositivo não pronto

Use comandos de diagnóstico (CI faz isso automaticamente):
```powershell
adb devices
adb shell getprop sys.boot_completed
adb shell pm list packages
adb shell service check package
```
Se `sys.boot_completed` != 1, aguarde mais tempo.

### 7) UDID e `systemPort`

- UDID padrão: `emulator-5554`. Ajuste se necessário.
- Em execuções paralelas use `appium:systemPort` diferentes.

---

## 🧪 Problemas com Robot Framework

### 1) Warnings "Capture Page Screenshot" não executado

**Causa:** Não há sessão aberta (erro anterior). Solucione a criação da sessão antes.

### 2) Timeouts de keywords

- CI pode ser mais lento. Aumente `Sleep` e `Wait Until ...` onde necessário.
- Em `base.resource`, mantemos timeouts do Appium elevados (adbExecTimeout, uiautomator2Server...)

### 3) Estabilização do App

Use as keywords do `resources/stability.resource`:
- `Wait For App Stability`
- `Wait For System UI Stability`
- `Handle System UI Issues`

Exemplo no início do teste:
```robot
Start session
Wait For App Stability    com.wdiodemoapp    15s
```

---

## 🌐 Publicação no GitHub Pages (Reports)

### Problemas comuns

- 403/Permissão: use PAT `GH_PAGES_PAT` com escopo `repo` (veja `GITHUB_PAGES_SETUP.md`)
- Branch/pasta conflitando: resolvido usando `peaceiris/actions-gh-pages@v3`
- Relatórios não aparecem: verifique se `logs/report.html` e `logs/log.html` foram gerados e baixados pelo job de publish.

### Onde ajustar

Workflow: `.github/workflows/robot-tests.yml` (job `publish-gh-pages`).

---

## 📦 Dependências e Ambiente

### Local (Windows PowerShell)

```powershell
# (opcional) Ambiente virtual
python -m venv .venv
.\.venv\Scripts\Activate.ps1

pip install --upgrade pip
pip install robotframework robotframework-appiumlibrary

# Node + Appium
npm install -g appium
appium driver install uiautomator2

# Android SDK e variáveis (ajuste os caminhos)
$env:ANDROID_HOME = "C:\\Android\\sdk"
$env:PATH = "$env:PATH;$env:ANDROID_HOME\\platform-tools;$env:ANDROID_HOME\\emulator"

# Verificações
adb version
appium -v
robot --version
```

### CI (GitHub Actions)
- Python 3.10
- Node 18 + Appium 2
- Android SDK configurado via `android-actions/setup-android@v3`
- Emulador API 29 (x86_64) com recursos ampliados

---

## 🔄 Diferenças Local vs CI

1) Performance: CI é mais lento → adicione `Sleep` e aumente timeouts.
2) Emulador headless no CI: sem UI, use waits confiáveis.
3) Caminhos: use `${EXECDIR}` nos recursos Robot para portabilidade.
4) Portas: garanta que 4723 (Appium) está livre.

Para logar ambiente nos testes:
```robot
Log To Console    EXECDIR: ${EXECDIR}
Log To Console    CURDIR: ${CURDIR}
```

---

## 🩺 Diagnóstico Rápido (Comandos úteis)

```powershell
# ADB & Boot
adb devices
adb shell getprop sys.boot_completed
adb shell getprop dev.bootcomplete
adb shell service check package
adb shell pm list packages

# UI/ANR
adb logcat -d | select-string -pattern "ANR|SystemUI|uiautomator"

# Reiniciar app
adb shell am force-stop com.wdiodemoapp
adb shell pm clear com.wdiodemoapp
adb shell am start -n com.wdiodemoapp/.MainActivity

# Appium
appium --versions
appium driver list

# Robot
robot -d ./logs/ tests
```

---

## ✅ Checklist de Verificação Rápida

- [ ] Python 3.8+ e Robot Framework instalados
- [ ] Appium 2.x e driver UIAutomator2 instalados
- [ ] ANDROID_HOME e PATH configurados
- [ ] Emulador inicia e `sys.boot_completed=1`
- [ ] APK existe em `app/wdio.native.app.apk`
- [ ] Appium server em execução (porta 4723)
- [ ] Capabilities sem `waitForIdleTimeout` string (aplicar via setting após a sessão)
- [ ] Relatórios gerados em `logs/` (report.html, log.html)
- [ ] Secret `GH_PAGES_PAT` configurado (se publicar no Pages)

---

## 🔗 Links Úteis e Documentos do Projeto

- Arquivos do projeto:
  - `.github/workflows/robot-tests.yml` (pipeline de testes e publish)
  - `resources/base.resource` (sessão Appium, capabilities)
  - `resources/stability.resource` (keywords de estabilidade)
  - `GITHUB_PAGES_SETUP.md` (configurar PAT e Pages)
  - `ALTERNATIVA_GHPAGES.md` (deploy alternativo para Pages)
  - `CORRECAO_GHPAGES.md` (correções para publicação)
  - `CORRECAO_SYSTEM_UI.md` (correção System UI isn’t responding)
  - `CORRECAO_SETUP_FAILED.md` (ordem de setup e estabilização)

- Documentações:
  - [Robot Framework](https://robotframework.org/robotframework/)
  - [Appium 2.x Docs](https://appium.io/docs/en/2.0/)
  - [UIAutomator2 Driver](https://appium.github.io/appium-xcuitest-driver/)
  - [Android ADB](https://developer.android.com/studio/command-line/adb)
  - [GitHub Actions](https://docs.github.com/actions)
  - [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages)

---

> Última atualização: 2025-11-03
