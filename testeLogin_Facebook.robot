*** Settings ***
Library         SeleniumLibrary
Test Setup      Abrir navegador facebook
Test Teardown   Fechar navegador

*** Variables ***
${URL_FACEBOOK}        https://www.facebook.com/
${CAMPO_EMAIL}         id=email
${CAMPO_SENHA}         id=pass
${BOTAO_LOGIN}         name=login
${HOME_INDICADOR}      xpath=//a[contains(@href, "home.php") or contains(@href, "facebook.com/?") or @aria-label="Feed"]
${MENSAGEM_ERRO}       css=div._9ay7

*** Test Cases ***
Login com sucesso
    Preencher login    EmailPessoal    Senha
    Clicar login
    Validar login com sucesso

*** Keywords ***
Abrir navegador facebook
    Open Browser    ${URL_FACEBOOK}    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    ${CAMPO_EMAIL}    timeout=15s
    Set Selenium Speed    0.5s
    Sleep    1s

Fechar navegador
    Close Browser

Preencher login
    [Arguments]    ${email}    ${senha}
    Log    🔍 Preenchendo campos de login...
    Wait Until Element Is Visible    ${CAMPO_EMAIL}    timeout=10s
    Input Text    ${CAMPO_EMAIL}    ${email}
    Wait Until Element Is Visible    ${CAMPO_SENHA}    timeout=10s
    Input Text    ${CAMPO_SENHA}    ${senha}

Clicar login
    Click Button    ${BOTAO_LOGIN}
    Log    🚀 Clicou em Entrar — aguardando resposta...
    Sleep    5s

Validar login com sucesso
    ${login_sucesso}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${HOME_INDICADOR}    timeout=15s
    ${erro_login}=       Run Keyword And Return Status    Wait Until Element Is Visible    ${MENSAGEM_ERRO}    timeout=5s

    IF    ${login_sucesso}
        Log    ✅ Login efetuado com sucesso! Teste finalizado com êxito.
        Capture Page Screenshot
        Close Browser
        Pass Execution    ✅ Login aceito — teste aprovado.
    ELSE IF    ${erro_login}
        Log    ❌ Erro de login detectado.
        Capture Page Screenshot
        Fail    ❌ Login ou senha incorretos — teste reprovado.
    ELSE
        Log    ⚠️ Não foi possível determinar o resultado do login.
        Capture Page Screenshot
        Fail    ⚠️ Resultado indefinido — verifique manualmente.
    END
