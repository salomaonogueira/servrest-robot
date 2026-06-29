*** Settings ***
Resource          ../../resources/api/carrinhos_keywords.resource
Resource          ../../resources/api/produtos_keywords.resource
Resource          ../../resources/api/usuarios_keywords.resource
Resource          ../../resources/api/login_keywords.resource
Suite Setup       Suite Setup Carrinhos

*** Variables ***
${TOKEN_USER}     ${EMPTY}
${PRODUTO_ID}     ${EMPTY}

*** Keywords ***
Suite Setup Carrinhos
    Criar Sessão ServeRest
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${token}=    Realizar Login Com Sucesso    ${dados}[email]    ${dados}[password]
    Set Suite Variable    ${TOKEN_USER}    ${token}
    ${pid}    ${pdados}=    Cadastrar Produto Com Sucesso    ${token}
    Set Suite Variable    ${PRODUTO_ID}    ${pid}

*** Test Cases ***
Listar Carrinhos Com Sucesso
    [Tags]    carrinhos    smoke
    ${response}=    Listar Carrinhos
    Validar Status Code    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    carrinhos

Cadastrar Carrinho Com Sucesso
    [Tags]    carrinhos    smoke
    ${dados}=    Montar Carrinho    ${PRODUTO_ID}
    ${response}=    Cadastrar Carrinho    ${dados}    ${TOKEN_USER}
    Validar Status Code    ${response}    201
    Validar Mensagem    ${response}    Cadastro realizado com sucesso
    [Teardown]    Concluir Compra    ${TOKEN_USER}

Cadastrar Carrinho Sem Token
    [Tags]    carrinhos    negativo
    ${dados}=    Montar Carrinho    ${PRODUTO_ID}
    ${response}=    Cadastrar Carrinho    ${dados}    token_invalido
    Validar Status Code    ${response}    401

Nao Cadastrar Dois Carrinhos Para Mesmo Usuario
    [Tags]    carrinhos    negativo
    ${dados}=    Montar Carrinho    ${PRODUTO_ID}
    Cadastrar Carrinho    ${dados}    ${TOKEN_USER}
    ${response}=    Cadastrar Carrinho    ${dados}    ${TOKEN_USER}
    Validar Status Code    ${response}    400
    Validar Mensagem    ${response}    Não é permitido ter mais de 1 carrinho
    [Teardown]    Concluir Compra    ${TOKEN_USER}

Concluir Compra Com Sucesso
    [Tags]    carrinhos    smoke
    ${dados}=    Montar Carrinho    ${PRODUTO_ID}
    Cadastrar Carrinho    ${dados}    ${TOKEN_USER}
    ${response}=    Concluir Compra    ${TOKEN_USER}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Registro excluído com sucesso

Cancelar Compra Com Sucesso
    [Tags]    carrinhos    smoke
    ${dados}=    Montar Carrinho    ${PRODUTO_ID}
    Cadastrar Carrinho    ${dados}    ${TOKEN_USER}
    ${response}=    Cancelar Compra    ${TOKEN_USER}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Registro excluído com sucesso. Estoque dos produtos reabastecido

Buscar Carrinho Por Id Com Sucesso
    [Tags]    carrinhos    smoke
    ${dados}=    Montar Carrinho    ${PRODUTO_ID}
    ${resp_cad}=    Cadastrar Carrinho    ${dados}    ${TOKEN_USER}
    ${id}=    Set Variable    ${resp_cad.json()}[_id]
    ${response}=    Buscar Carrinho Por Id    ${id}
    Validar Status Code    ${response}    200
    Should Be Equal As Strings    ${response.json()}[_id]    ${id}
    [Teardown]    Concluir Compra    ${TOKEN_USER}
