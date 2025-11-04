*** Settings ***
Documentation    ações referentes a tela HOME(inicial)

Library    AppiumLibrary


*** Variables ***
${LOGIN}                   xpath=//android.widget.TextView[@text="󰍂"]
${TEXTO_TELA_LOGIN}        Login / Sign up Form
${home}                    xpath=//android.widget.TextView[@text="Home"]

*** Keywords ***
Click Login
    [Documentation]    Abre a tela de Login a partir da Home e valida o carregamento do formulário.
    Click Element                    ${LOGIN}   
    Wait Until Page Contains         ${TEXTO_TELA_LOGIN}    timeout=120s

Click Home
    [Documentation]    Navega para a aba Home a partir de qualquer outra tela.
    Click Element                    ${home}
