*** Settings ***
Documentation

Library              AppiumLibrary
Resource             ../resources/base.resource

Test Setup           Start session
Test Teardown        Finish session


*** Test Cases ***
Deve realizar o cadastro com sucesso
    [Documentation]    Verifica se o usuário consegue realizar o cadastro com sucesso na aplicação
    Wait Until Page Contains    WEBDRIVER    300s
    Click Login
    Preenche Sign Up Form
    
Deve realizar o login com sucesso
    [Documentation]    Verifica se o usuário consegue realizar o login com sucesso na aplicação
    Wait Until Page Contains    WEBDRIVER    300s
    Click Login
    Realizar Login com sucesso