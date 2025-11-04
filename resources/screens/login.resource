*** Settings ***
Documentation    ações referentes a tela HOME(inicial)


Library    AppiumLibrary



*** Variables ***
${INPUT_EMAIL}                   input-email
${SIGN_UP}                       //android.widget.TextView[@text="Sign up"]
${INPUT_PASSWORD}                input-password
${INPUT_CONFIRM_PASSWORD}        input-repeat-password
${BTN_SIGN_UP}                   //android.view.ViewGroup[@content-desc="button-SIGN UP"]/android.view.ViewGroup
${Mensagem_Sucesso_Cadastro}     Signed Up!
${ROBOT_ID}                      accessibility_id=robot
${BTN_OK_SUCCESS}                android:id/button1
${BTN_LOGIN}                    //android.view.ViewGroup[@content-desc="button-LOGIN"]/android.view.ViewGroup
${LOGIN_ACCES_FORM}              (//android.widget.TextView[@text="Login"])[1]
${Mensagem_Sucesso_Login}         Success
*** Keywords ***
Realizar Login com sucesso
    [Documentation]    Realiza login com credenciais válidas e valida o sucesso ("Success").
    ...    Passos: preenche e-mail e senha, clica em LOGIN, aguarda confirmação e fecha o diálogo.
    ...    Observação: usa valores estáticos de exemplo; ajuste se necessário.
    Input Text                   accessibility_id=${INPUT_EMAIL}                   teste@gmail.com
    Input Text                   accessibility_id=${INPUT_PASSWORD}                Senha@123456
    Click Element                xpath=${BTN_LOGIN}
    Wait Until Page Contains     ${Mensagem_Sucesso_Login}                          timeout=120s
    Click Element                ID=${BTN_OK_SUCCESS}


Preenche Sign Up Form
    [Documentation]    Cadastra um novo usuário preenchendo e-mail, senha e confirmação; valida mensagem "Signed Up!".
    ...    Passos: abre aba Sign up, preenche campos, envia, aguarda confirmação e fecha o diálogo.
    Wait Until Page Contains    Login / Sign up Form                                timeout=120s
    Click Element                xpath=${SIGN_UP}
    Input Text                   accessibility_id=${INPUT_EMAIL}                   teste@gmail.com
    Input Text                   accessibility_id=${INPUT_PASSWORD}                Senha@123456
    Input Text                   accessibility_id=${INPUT_CONFIRM_PASSWORD}        Senha@123456    
    Click Element                xpath=${BTN_SIGN_UP}
    Wait Until Page Contains     ${Mensagem_Sucesso_Cadastro}                       timeout=120s
    Click Element                ID=${BTN_OK_SUCCESS}
    
        
Click Login acima do formulario
    [Documentation]    Alterna para a aba "Login" acima do formulário de autenticação.
    Click Element                xpath=${LOGIN_ACCES_FORM}


Limpa os Campos de Login
    [Documentation]    Limpa os campos de e-mail e senha no formulário de login (reset do estado da tela).
    Clear Text    accessibility_id=${INPUT_EMAIL}
    Clear Text    accessibility_id=${INPUT_PASSWORD}         
