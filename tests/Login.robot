*** Settings ***
Documentation

Library              AppiumLibrary
Resource             ../resources/base.resource

Test Setup           Start session
Test Teardown        Finish session


*** Test Cases ***
Deve realizar o cadastro com sucesso
    [Documentation]    Verifica se o usuário consegue realizar o cadastro com sucesso na aplicação
    Click Login
    Preenche Sign Up Form
    
Deve realizar o login com sucesso
    [Documentation]    Verifica se o usuário consegue realizar o login com sucesso na aplicação
    Click Login
    Realizar Login com sucesso