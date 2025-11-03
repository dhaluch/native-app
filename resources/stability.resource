*** Settings ***
Documentation    Keywords para gerenciar estabilidade do sistema e evitar ANRs

Library    AppiumLibrary
Library    Collections
Library    Process

*** Keywords ***
Wait For System UI Stability
    [Documentation]    Aguarda o System UI se estabilizar e resolve problemas comuns
    [Arguments]    ${timeout}=15s    ${retry_count}=2
    
    Log    🔍 Verificando estabilidade do System UI...
    
    FOR    ${i}    IN RANGE    ${retry_count}
        TRY
            Log    Tentativa ${i+1} de ${retry_count} para verificar System UI
            
            # Verificação básica - apenas aguardar sem forçar elemento específico
            Sleep    5s
            
            # Tentar uma verificação simples
            ${result}    Run Keyword And Return Status    
            ...    Get Source
            
            IF    ${result}
                Log    ✅ System UI respondendo na tentativa ${i+1}
                RETURN
            END
            
            Log    ⚠️ System UI não respondeu, tentando resolver...
            Handle System UI Issues
            
        EXCEPT    AS    ${error}
            Log    ⚠️ Tentativa ${i+1} com erro: ${error}
            Sleep    3s
        END
    END
    
    Log    ⚠️ System UI pode não estar completamente estável, mas continuando...

Handle System UI Issues
    [Documentation]    Tenta resolver problemas comuns do System UI
    
    Log    🔧 Tentando resolver problemas do System UI...
    
    # Tentar fechar dialogs de ANR
    TRY
        ${anr_elements}    Get WebElements    xpath=//*[contains(@text, 'isn't responding') or contains(@text, 'not responding')]
        FOR    ${element}    IN    @{anr_elements}
            Log    🚫 Dialog ANR detectado, tentando fechar...
            # Tentar clicar em "Wait" se disponível
            ${wait_btn}    Run Keyword And Return Status    
            ...    Click Element    xpath=//*[contains(@text, 'Wait') or contains(@text, 'Aguardar')]
            IF    not ${wait_btn}
                # Se não houver "Wait", tentar "OK" ou "Close"
                Click Element    xpath=//*[contains(@text, 'OK') or contains(@text, 'Close') or contains(@text, 'Fechar')]
            END
        END
    EXCEPT
        Log    ℹ️ Nenhum dialog ANR encontrado ou erro ao processar
    END
    
    # Tentar voltar ao Home
    TRY
        Press Keycode    3    # HOME key
        Sleep    2s
    EXCEPT
        Log    ⚠️ Não foi possível pressionar HOME
    END
    
    # Tentar limpar tasks recentes
    TRY
        Press Keycode    187    # RECENT_APPS key  
        Sleep    1s
        Press Keycode    3      # HOME key
        Sleep    2s
    EXCEPT
        Log    ℹ️ Não foi possível limpar tasks recentes
    END

Wait For App Stability
    [Documentation]    Aguarda o aplicativo se estabilizar após o launch
    [Arguments]    ${package_name}=com.wdiodemoapp    ${timeout}=15s
    
    Log    ⏳ Aguardando estabilização do app ${package_name}...
    
    # Aguardar elementos básicos da UI Android carregarem
    TRY
        Wait Until Keyword Succeeds    ${timeout}    3s
        ...    Page Should Contain Element    id=android:id/content
        Log    ✅ Elemento android:id/content encontrado
    EXCEPT
        Log    ⚠️ Elemento android:id/content não encontrado, tentando continuar...
    END
    
    # Aguardar um pouco mais para estabilização completa
    Sleep    3s
    
    Log    ✅ App ${package_name} considerado estabilizado

Restart App If Frozen
    [Documentation]    Reinicia o app se estiver congelado ou com problemas
    [Arguments]    ${package_name}=com.wdiodemoapp
    
    Log    🔄 Reiniciando app devido a problemas de estabilidade...
    
    # Forçar fechamento do app
    TRY
        Close Application
        Sleep    2s
    EXCEPT
        Log    ⚠️ Não foi possível terminar o app normalmente
    END
    
    # Limpar cache se possível
    TRY
        Execute ADB Command    shell pm clear ${package_name}
        Sleep    2s
    EXCEPT
        Log    ℹ️ Não foi possível limpar cache do app
    END
    
    # Reiniciar o app
    Execute ADB Command    shell am start -n ${package_name}/.MainActivity
    Wait For App Stability    ${package_name}
    
    Log    ✅ App reiniciado com sucesso

Check System Performance
    [Documentation]    Verifica a performance do sistema e reporta métricas
    
    Log    📊 Verificando performance do sistema...
    
    TRY
        # Verificar memória disponível
        ${meminfo}    Execute ADB Command    shell cat /proc/meminfo | grep MemAvailable
        Log    💾 Memória: ${meminfo}
        
        # Verificar CPU
        ${cpu_info}    Execute ADB Command    shell top -n 1 | head -5
        Log    🖥️ CPU Info: ${cpu_info}
        
        # Verificar processos do sistema
        ${system_ui}    Execute ADB Command    shell ps | grep systemui
        Log    🖼️ System UI: ${system_ui}
        
    EXCEPT    AS    ${error}
        Log    ⚠️ Erro ao verificar performance: ${error}
    END

Execute ADB Command
    [Documentation]    Executa comando ADB e retorna resultado
    [Arguments]    ${command}
    
    ${result}    Run Process    adb    ${command}    shell=True
    RETURN    ${result.stdout}

Setup Anti ANR Environment
    [Documentation]    Configura o ambiente para evitar ANRs (apenas para uso manual/debug)
    
    Log    🛡️ Configurando ambiente anti-ANR...
    
    # Aplicar configurações via ADB (apenas se necessário para debug)
    TRY
        Execute ADB Command    shell settings put global anr_show_background false
        Execute ADB Command    shell settings put global animator_duration_scale 0.5  
        Execute ADB Command    shell settings put system screen_off_timeout 1800000
        Log    ✅ Configurações anti-ANR aplicadas
    EXCEPT    AS    ${error}
        Log    ⚠️ Algumas configurações anti-ANR não puderam ser aplicadas: ${error}
    END
    
    Log    ✅ Ambiente anti-ANR configurado (modo básico)