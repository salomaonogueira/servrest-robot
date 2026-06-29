*** Settings ***
Resource    base.resource

*** Variables ***
${BTN_CADASTRAR_PRODUTO}     css=[data-testid="cadastrar-produto"]
${INPUT_NOME_PRODUTO}        css=[data-testid="nome"]
${INPUT_PRECO_PRODUTO}       css=[data-testid="preco"]
${INPUT_DESCRICAO_PRODUTO}   css=[data-testid="descricao"]
${INPUT_QUANTIDADE_PRODUTO}  css=[data-testid="quantidade"]
${BTN_SALVAR_PRODUTO}        css=[data-testid="cadastarProdutos"]
${LISTA_PRODUTOS}            css=[data-testid="produto"]
${BTN_LOGOUT}                css=[data-testid="logout"]

*** Keywords ***
Acessar Pagina De Produtos
    Go To    ${FRONT_URL}/home
    Wait Until Element Is Visible    ${BTN_CADASTRAR_PRODUTO}

Clicar Em Cadastrar Produto
    Aguardar E Clicar    ${BTN_CADASTRAR_PRODUTO}
    Wait Until Element Is Visible    ${INPUT_NOME_PRODUTO}

Preencher Dados Produto
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}
    Aguardar E Digitar    ${INPUT_NOME_PRODUTO}       ${nome}
    Aguardar E Digitar    ${INPUT_PRECO_PRODUTO}      ${preco}
    Aguardar E Digitar    ${INPUT_DESCRICAO_PRODUTO}  ${descricao}
    Aguardar E Digitar    ${INPUT_QUANTIDADE_PRODUTO} ${quantidade}

Salvar Produto
    Aguardar E Clicar    ${BTN_SALVAR_PRODUTO}

Cadastrar Produto Via UI
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}
    Clicar Em Cadastrar Produto
    Preencher Dados Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}
    Salvar Produto

Validar Produto Na Lista
    [Arguments]    ${nome}
    Wait Until Page Contains    ${nome}

Fazer Logout
    Aguardar E Clicar    ${BTN_LOGOUT}
    Wait Until Location Contains    /login
