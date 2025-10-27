*** Settings ***
Documentation    ações referentes a tela HOME(inicial)

Library    AppiumLibrary


*** Variables ***
${LOGIN}                   xpath=//android.widget.TextView[@text="󰍂"]
${TEXTO_TELA_LOGIN}        Login / Sign up Form
${home}                    xpath=//android.widget.TextView[@text="Home"]

*** Keywords ***
Click Login
    Click Element                    ${LOGIN}   
    Wait Until Page Contains         ${TEXTO_TELA_LOGIN}    timeout=120s

Click Home
    Click Element                    ${home}
