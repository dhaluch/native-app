*** Settings ***
Documentation

Library              AppiumLibrary
Resource             ../resources/base.resource

Test Setup           Start session
Test Teardown        Finish session


*** Test Cases ***
Deve abrir a tela pricipal e acessar tela de login
    Click Login
    