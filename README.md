# native-app

Descrição breve
---------------
Projeto de testes automatizados mobile usando Robot Framework + Appium para uma aplicação Android (APK em `app/wdio.native.app.apk`). O objetivo é executar testes de UI no emulador (local ou CI) e gerar relatórios em HTML para análise.

Arquitetura / Estrutura de pastas
--------------------------------
- `app/`
	- `wdio.native.app.apk`  (APK usado nos testes)
- `resources/`
	- `base.resource`       (capabilities e keywords de setup / teardown)
	- `screens/`
		- `home.resource`     (keywords/identificadores da tela Home)
		- `login.resource`    (keywords/identificadores da tela Login)
- `tests/`                (test suites Robot Framework, ex: `Login.robot`)
- `.github/workflows/`    (workflow GitHub Actions: `robot-tests.yml`)
- `README.md`             (este arquivo)

Versões utilizadas (recomendações)
----------------------------------
- Python: 3.10
- Node.js: 18.x
# 🤖 Robot Mobile - Android (Outsera)

Automação de testes Mobile (Android) com Robot Framework + Appium, com execução local e no GitHub Actions, e publicação dos relatórios (report/log) no GitHub Pages.

[![Robot Tests](https://github.com/dhaluch/native-app/actions/workflows/robot-tests.yml/badge.svg)](https://github.com/dhaluch/native-app/actions/workflows/robot-tests.yml)

---

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias](#tecnologias)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Executando os Testes](#executando-os-testes)
- [Relatórios (Robot HTML)](#relatórios-robot-html)
- [CI/CD Pipeline](#cicd-pipeline)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Troubleshooting](#troubleshooting)
- [Contribuindo](#contribuindo)
- [Scripts úteis](#scripts-úteis)

---

## 🎯 Sobre o Projeto

Este projeto automatiza cenários de UI no app de demonstração (APK em `app/wdio.native.app.apk`) usando Robot Framework + Appium/UIAutomator2.

Cenários principais:
- ✅ Login com sucesso
- ✅ Cadastro (Sign up) com sucesso
- ✅ Navegação Home/Login

Geração de relatórios padrão do Robot:
- 📄 `report.html` e `log.html`
- 🧾 `output.xml`

---

## 🛠️ Tecnologias

- Robot Framework (tests)
- AppiumLibrary (integração Appium)
- Appium 2.x + UIAutomator2 driver
- Android SDK/Emulador (API 29 no CI)
- GitHub Actions (CI/CD)
- GitHub Pages (publicação de relatórios)

---

## 📋 Pré-requisitos

- Python 3.10+ (CI usa 3.10)
- Node.js 18+
- Android SDK + Platform Tools (adb)
- Emulador Android criado (ou dispositivo físico)

---

## 🚀 Instalação

Windows PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install robotframework robotframework-appiumlibrary

npm install -g appium
appium driver install uiautomator2
```

Linux/macOS:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install robotframework robotframework-appiumlibrary

npm install -g appium
appium driver install uiautomator2
```

---

## ⚙️ Configuração

- APK alvo em `app/wdio.native.app.apk`
- Capabilities configuradas em `resources/base.resource` (keyword `Start session`)
- Endereço do Appium: `http://localhost:4723`
- UDID padrão do emulador: `emulator-5554` (ajuste se necessário)

> Nota: para evitar o erro de tipo em `waitForIdleTimeout`, não definimos essa capability como string. Se quiser ajustar após abrir a sessão, use um setting numérico com `Set Appium Setting`.

---

## 🧪 Executando os Testes

Inicie o emulador e o Appium, depois rode o Robot.

Windows PowerShell:

```powershell
# Emulador (exemplo)
Start-Process -NoNewWindow -FilePath "$Env:ANDROID_HOME\emulator\emulator.exe" -ArgumentList '-avd','test','-no-window','-no-audio'
& "$Env:ANDROID_HOME\platform-tools\adb.exe" wait-for-device

# Appium server
Start-Process -NoNewWindow -FilePath "appium"

# Tests
mkdir logs
robot --outputdir logs tests
Start-Process .\logs\report.html
```

Linux/macOS:

```bash
$ANDROID_HOME/emulator/emulator -avd test -no-window -no-audio &
adb wait-for-device

appium &

mkdir -p logs
robot --outputdir logs tests
xdg-open logs/report.html || open logs/report.html
```

---

## 📊 Relatórios (Robot HTML)

Após a execução, consulte em `logs/`:
- `report.html`
- `log.html`
- `output.xml`

No CI, os relatórios são publicados no GitHub Pages:

```
https://dhaluch.github.io/native-app/
```

> O publish usa `peaceiris/actions-gh-pages@v3` e requer um secret `GH_PAGES_PAT` (token classic com scope `repo`). A estrutura mantém histórico por branch/data.

---

## 🔄 CI/CD Pipeline

Workflow principal: `.github/workflows/robot-tests.yml`

Disparos:
- ✅ Push para `feature/**`
- ✅ Pull Requests para `main`
- ✅ Execução manual (`workflow_dispatch`)

Etapas principais:
1. Checkout do código
2. Setup Python 3.10 e dependências Robot
3. Setup Android SDK + criação do AVD (API 29)
4. Start do emulador em modo headless, aguardo de boot e estabilização
5. Instalação do APK e start do Appium server
6. Execução do Robot: `robot --outputdir logs tests`
7. Upload do artifact `logs/`
8. Deploy dos relatórios no Pages (job `publish-gh-pages`)

Secrets necessários (para Pages via PAT):
- `GH_PAGES_PAT` – token (classic) com escopo `repo`

---

## 📁 Estrutura do Projeto

```
native-app/
├── app/
│   └── wdio.native.app.apk
├── resources/
│   ├── base.resource                # sessão Appium (setup/teardown)
│   └── screens/
│       ├── home.resource            # keywords da Home
│       └── login.resource           # keywords de Login
├── tests/
│   ├── Login.robot
│   └── primeiroteste.robot
├── logs/                            # (gerado) relatórios Robot
├── .github/
│   └── workflows/
│       └── robot-tests.yml          # pipeline Android + publish Pages
└── README.md
```

---

## 🔍 Troubleshooting

Para problemas comuns (emulador, Appium, Pages, timeouts), consulte o **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)**.

Tópicos cobertos:
- ❌ "System UI isn't responding" / ANR — como mitigamos no CI
- ❌ SessionNotCreatedException: `waitForIdleTimeout` (tipo inválido)
- ❌ Emulador não pronto (boot/property checks com `adb`)
- ❌ Publicação no Pages (PAT, action `peaceiris`)

Docs relacionados:
- `CORRECAO_SYSTEM_UI.md`, `CORRECAO_GHPAGES.md`, `CORRECAO_SETUP_FAILED.md`, `GITHUB_PAGES_SETUP.md`

---

## 🤝 Contribuindo

1. Faça um fork
2. Crie uma branch: `git checkout -b feature/minha-feature`
3. Commit: `git commit -m "Add: minha nova feature"`
4. Push: `git push origin feature/minha-feature`
5. Abra um Pull Request

Padrões sugeridos:
- `Add:` nova funcionalidade
- `Fix:` correção de bug
- `Update:` atualização de código existente
- `Refactor:` refatoração
- `Docs:` documentação
- `Test:` testes

---

## 📝 Scripts úteis

```powershell
# Windows: criar venv e instalar deps
python -m venv .venv; .\.venv\Scripts\Activate.ps1; python -m pip install --upgrade pip; pip install robotframework robotframework-appiumlibrary

# Appium 2 + driver
npm install -g appium; appium driver install uiautomator2

# Rodar testes
robot --outputdir logs tests
```

```bash
# Linux/macOS
python -m venv .venv && source .venv/bin/activate && python -m pip install --upgrade pip && pip install robotframework robotframework-appiumlibrary
npm install -g appium && appium driver install uiautomator2
robot --outputdir logs tests
```

---

## 📄 Licença

Projeto com finalidade educacional/demonstrativa.

---

**Última atualização:** 2025-11-03
