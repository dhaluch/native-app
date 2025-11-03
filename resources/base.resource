*** Settings ***
Documentation    

Library    AppiumLibrary
Resource    screens/home.resource
Resource    screens/login.resource
Resource    stability.resource

*** Keywords ***
Start session
    # Configurar ambiente anti-ANR antes de iniciar
    Setup Anti ANR Environment
    
    # Aguardar estabilidade do sistema antes de conectar
    Sleep    5s
    
    Open Application    http://localhost:4723
    ...    platformName=Android
    ...    automationName=UIAutomator2
    ...    deviceName=Android Emulator
    ...    app=${EXECDIR}/app/wdio.native.app.apk
    ...    udid=emulator-5554
    ...    autoGrantPermissions=true
    ...    appium:disableHiddenApiPolicy=false
    ...    appium:ignoreHiddenApiPolicyError=true
    ...    appium:skipDeviceInitialization=true
    ...    appPackage=com.wdiodemoapp
    ...    appActivity=.MainActivity
    ...    newCommandTimeout=600
    ...    adbExecTimeout=200000
    ...    uiautomator2ServerInstallTimeout=180000
    ...    uiautomator2ServerLaunchTimeout=180000
    ...    noReset=true
    ...    appium:skipServerInstallation=false
    ...    appium:uiautomator2ServerReadTimeout=240000
    ...    appium:waitForIdleTimeout=10000
    ...    appium:waitForQuiescence=true
    ...    appium:waitActivity=.MainActivity
    ...    appium:waitDuration=30000
    ...    appium:androidInstallTimeout=180000
    ...    appium:systemPort=8200
    ...    appium:clearSystemFiles=true
    ...    appium:ensureWebviewsHavePages=false
    ...    appium:nativeWebScreenshot=true
    ...    appium:reconnectRetries=3
    ...    appium:maxTypingFrequency=60
    
    # Aguardar estabilização após conectar
    Wait For App Stability    com.wdiodemoapp    30s
    
    Log    ✅ Sessão Appium iniciada com sucesso e app estabilizado

Finish session
    Log    🔚 Finalizando sessão...
    Close Application