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
${ROBOT_ID}                accessibility_id=robot
${BTN_OK_SUCCESS}                android:id/button1
${BTN_LOGIN}                    //android.view.ViewGroup[@content-desc="button-LOGIN"]/android.view.ViewGroup

*** Keywords ***
Realizar Login com sucesso
    
    Input Text                   accessibility_id=${INPUT_EMAIL}                   teste@gmail.com
    Input Text                   accessibility_id=${INPUT_PASSWORD}                Senha@123456
    Click Element                xpath=${BTN_LOGIN}


Preenche Sign Up Form
    Wait Until Page Contains    Login / Sign up Form                                timeout=300s
    Click Element                xpath=${SIGN_UP}
    Input Text                   accessibility_id=${INPUT_EMAIL}                   teste@gmail.com
    Input Text                   accessibility_id=${INPUT_PASSWORD}                Senha@123456
    Input Text                   accessibility_id=${INPUT_CONFIRM_PASSWORD}        Senha@123456    
    Click Element                xpath=${BTN_SIGN_UP}
    Wait Until Page Contains     ${Mensagem_Sucesso_Cadastro}                       timeout=300s
    Click Element                ID=${BTN_OK_SUCCESS}
    
        



