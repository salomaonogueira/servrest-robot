*** Settings ***
Resource    base.resource

*** Variables ***
${INPUT_EMAIL}        css=[data-testid="email"]
${INPUT_PASSWORD}     css=[data-testid="senha"]
${BTN_LOGIN}          css=[data-testid="entrar"]
${LINK_CADASTRO}      css=[data-testid="cadastrar"]
${MSG_ERRO_LOGIN}     css=[data-testid="error-message"], .alert-danger

*** Keywords ***
Acessar Pagina De Login
    Go To    ${FRONT_URL}/login
    Wait Until Element Is Visible    ${INPUT_EMAIL}

Preencher Email
    [Arguments]    ${email}
    Aguardar E Digitar    ${INPUT_EMAIL}    ${email}

Preencher Senha
    [Arguments]    ${senha}
    Aguardar E Digitar    ${INPUT_PASSWORD}    ${senha}

Clicar Em Entrar
    Aguardar E Clicar    ${BTN_LOGIN}

Realizar Login Via UI
    [Arguments]    ${email}    ${senha}
    Preencher Email    ${email}
    Preencher Senha    ${senha}
    Clicar Em Entrar

Validar Redirecionamento Para Home
    Wait Until Location Contains    /home
    Wait Until Page Contains Element    css=[data-testid="logout"]

Validar Erro De Login
    Wait Until Element Is Visible    ${MSG_ERRO_LOGIN}

Clicar Em Cadastrar
    Aguardar E Clicar    ${LINK_CADASTRO}
