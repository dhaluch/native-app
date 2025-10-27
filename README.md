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
- Robot Framework: latest compatível com Python 3.10 (instalado via pip)
- Robot Framework AppiumLibrary
- Appium: 2.x (instalado via npm no workflow)
- Appium driver: uiautomator2 (v4.x, instalado no workflow)
- Android SDK: API 29 (emulador configurado no workflow)

Dependências (como instalar)
----------------------------
Local (Linux/macOS) - ambiente de desenvolvimento:

1. Instale Python 3.10 e Node 18.
2. Instale pip packages:

```bash
python -m pip install --upgrade pip
pip install robotframework
pip install robotframework-appiumlibrary
# Se usar Robot Browser/Playwright (não obrigatório para mobile):
# pip install robotframework-browser
# rfbrowser init
```

3. Instale Appium (se for executar localmente):

```bash
npm install -g appium
appium driver install uiautomator2@4.0.1
```

4. Configure Android SDK / emulator (ex.: via Android Studio SDK Manager).

Como executar os testes (local)
------------------------------
1. Verifique que o emulador Android esteja criado e rodando (ou dispositivo conectado). Exemplo com AVD "test":

```bash
# iniciar emulador (exemplo)
$ANDROID_SDK_ROOT/emulator/emulator -avd test &
adb wait-for-device
```

2. Instale o APK no emulador (opcional — o workflow instala automaticamente):

```bash
adb install -r app/wdio.native.app.apk
```

3. Inicie o Appium server (se estiver rodando os testes localmente):

```bash
appium &
```

4. Execute os testes Robot Framework:

```bash
robot --outputdir logs tests/
```

Após a execução, os relatórios estarão em `logs/` (`report.html`, `log.html`, `output.xml`).

Windows (PowerShell)
--------------------
Se estiver em um ambiente Windows com PowerShell, use os comandos abaixo (assumindo que `ANDROID_SDK_ROOT`, `python` e `npm` estejam no PATH):

1. Iniciar o emulador (exemplo):

```powershell
# Inicia o AVD chamado 'test' em background
Start-Process -NoNewWindow -FilePath "$Env:ANDROID_SDK_ROOT\emulator\emulator.exe" -ArgumentList '-avd','test','-no-window','-no-audio'
& "$Env:ANDROID_SDK_ROOT\platform-tools\adb.exe" wait-for-device
```

2. Instalar o APK no emulador:

```powershell
& "$Env:ANDROID_SDK_ROOT\platform-tools\adb.exe" install -r "app\wdio.native.app.apk"
```

3. Iniciar o Appium server (se instalado globalmente via npm):

```powershell
# Se Appium estiver no PATH
Start-Process -NoNewWindow -FilePath "appium" -ArgumentList ''
# Ou, se preferir usar npx
npx appium &
```

4. Executar os testes Robot Framework:

```powershell
robot --outputdir logs tests/
```

Notas:
- Em PowerShell, `Start-Process` inicia um processo em background. Use `Get-Process` e `Stop-Process` para gerenciar.
- Execute o PowerShell com permissões adequadas se necessário.

Como executar no GitHub Actions (CI)
-----------------------------------
O workflow principal está em `.github/workflows/robot-tests.yml`. Ele:
- Configura o Android SDK e cria um emulador (API 29 por padrão).
- Instala o APK (`app/wdio.native.app.apk`) no emulador.
- Instala e inicia o Appium com o driver `uiautomator2`.
- Executa os testes com Robot Framework e salva os logs em `logs/`.
- Faz upload dos artefatos (artifact `logs/`) para download via UI do Actions.

Para rodar o workflow manualmente: vá na aba "Actions" do repositório e dispare o workflow (ou faça push para branch configurada).

Observações sobre relatórios
---------------------------
- O workflow faz `robot --outputdir logs tests/` e depois faz upload dos arquivos de `logs/` como artefato. Baixe o ZIP do artifact pela interface do GitHub Actions para ver `report.html` e `log.html`.

Configurações importantes / Capabilities
---------------------------------------
O arquivo `resources/base.resource` contém a keyword `Start session` onde as capabilities Appium são definidas. Campos chave:

- `platformName=Android`
- `automationName=UIAutomator2`
- `deviceName=Android Emulator`
- `udid=emulator-5554` (remova/ajuste se seu emulador tiver outro id)
- `app=${EXECDIR}/app/wdio.native.app.apk`
- `appPackage` e `appActivity` do APK (`com.wdiodemoapp` / `.MainActivity` no projeto)
- `newCommandTimeout` aumentado para 600s (tolerância a inicialização lenta)

Dicas e solução de problemas
---------------------------
- Erro "Could not find a connected Android device": verifique se o emulador está rodando e `adb devices` lista uma instância.
- Erro de driver Appium para UIAutomator2: instale o driver com `appium driver install uiautomator2`.

Próximos passos recomendados
---------------------------
- Validar localmente a instalação do APK e se o id da activity/package batem com as capabilities.
