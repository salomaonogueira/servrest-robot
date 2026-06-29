*** Settings ***
Resource    base.resource

*** Variables ***
${INPUT_NOME}           css=[data-testid="nome"]
${INPUT_EMAIL}          css=[data-testid="email"]
${INPUT_PASSWORD}       css=[data-testid="password"]
${CHECK_ADMIN}          css=[data-testid="checkbox"]
${BTN_CADASTRAR}        css=[data-testid="cadastrar"]
${MSG_SUCESSO}          Cadastro realizado com sucesso

*** Keywords ***
Acessar Pagina De Cadastro
    Go To    ${FRONT_URL}/cadastrarusuarios
    Wait Until Element Is Visible    ${INPUT_NOME}

Preencher Dados Cadastro
    [Arguments]    ${nome}    ${email}    ${senha}    ${admin}=False
    Aguardar E Digitar    ${INPUT_NOME}      ${nome}
    Aguardar E Digitar    ${INPUT_EMAIL}     ${email}
    Aguardar E Digitar    ${INPUT_PASSWORD}  ${senha}
    IF    ${admin}
        Select Checkbox    ${CHECK_ADMIN}
    END

Submeter Cadastro
    Aguardar E Clicar    ${BTN_CADASTRAR}

Cadastrar Novo Usuario Via UI
    [Arguments]    ${nome}    ${email}    ${senha}    ${admin}=False
    Preencher Dados Cadastro    ${nome}    ${email}    ${senha}    ${admin}
    Submeter Cadastro

Validar Cadastro Com Sucesso
    Wait Until Page Contains    ${MSG_SUCESSO}
