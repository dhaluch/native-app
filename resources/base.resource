*** Settings ***
Documentation    

Library    AppiumLibrary
Resource    screens/home.resource
Resource    screens/login.resource
Resource    stability.resource

*** Keywords ***
Start session
    [Documentation]    Abre uma sessão Appium no emulador Android (udid=emulator-5554) e inicia o app Demo (MainActivity).
    ...    Pré‑requisitos: Appium server ativo em http://localhost:4723 e dispositivo pronto.
    ...    Efeitos: App aberto e estável para interação; permissões concedidas automaticamente.
    Log    🚀 Iniciando sessão Appium...
    
    Open Application    http://localhost:4723
    ...    platformName=Android
    ...    automationName=UIAutomator2
    ...    deviceName=Android Emulator
    ...    app=${EXECDIR}/app/wdio.native.app.apk
    ...    udid=emulator-5554
    ...    autoGrantPermissions=true
    ...    appPackage=com.wdiodemoapp
    ...    appActivity=.MainActivity
    ...    newCommandTimeout=${600}
    ...    adbExecTimeout=${200000}
    ...    uiautomator2ServerInstallTimeout=${180000}
    ...    uiautomator2ServerLaunchTimeout=${180000}
    ...    noReset=true
    ...    appium:disableHiddenApiPolicy=${false}
    ...    appium:ignoreHiddenApiPolicyError=${true}
    ...    appium:skipDeviceInitialization=${true}
    ...    appium:skipServerInstallation=${false}
    ...    appium:systemPort=${8200}
    ...    appium:clearSystemFiles=${true}
    ...    appium:ensureWebviewsHavePages=${false}
    ...    appium:nativeWebScreenshot=${true}
    
    Log    ✅ Sessão Appium conectada, aguardando estabilização...
    
    # Aguardar um pouco para o app carregar
    Sleep    5s
    
    # Tentar aguardar estabilização (com tratamento de erro)
    TRY
        Wait For App Stability    com.wdiodemoapp    15s
        Log    ✅ App estabilizado com sucesso
    EXCEPT    AS    ${error}
        Log    ⚠️ Aviso: App pode não estar completamente estável: ${error}
        Log    ℹ️ Continuando execução mesmo assim...
    END
    
    Log    ✅ Sessão pronta para uso

Finish session
    [Documentation]    Encerra a sessão Appium caso esteja aberta e finaliza a execução do app.
    Log    🔚 Finalizando sessão...
    Close Application