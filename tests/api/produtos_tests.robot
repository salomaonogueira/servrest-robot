*** Settings ***
Resource          ../../resources/api/produtos_keywords.resource
Resource          ../../resources/api/usuarios_keywords.resource
Resource          ../../resources/api/login_keywords.resource
Suite Setup       Suite Setup Produtos

*** Variables ***
${TOKEN_ADMIN}    ${EMPTY}
${ID_USUARIO}     ${EMPTY}

*** Keywords ***
Suite Setup Produtos
    Criar Sessão ServeRest
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${token}=    Realizar Login Com Sucesso    ${dados}[email]    ${dados}[password]
    Set Suite Variable    ${TOKEN_ADMIN}    ${token}
    Set Suite Variable    ${ID_USUARIO}    ${id}

*** Test Cases ***
Listar Produtos Com Sucesso
    [Tags]    produtos    smoke
    ${response}=    Listar Produtos
    Validar Status Code    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    produtos

Cadastrar Produto Com Sucesso
    [Tags]    produtos    smoke
    ${id}    ${dados}=    Cadastrar Produto Com Sucesso    ${TOKEN_ADMIN}
    Should Not Be Empty    ${id}

Cadastrar Produto Com Nome Duplicado
    [Tags]    produtos    negativo
    ${dados}=    Gerar Dados Produto
    Cadastrar Produto    ${dados}    ${TOKEN_ADMIN}
    ${response}=    Cadastrar Produto    ${dados}    ${TOKEN_ADMIN}
    Validar Status Code    ${response}    400
    Validar Mensagem    ${response}    Já existe produto com esse nome

Cadastrar Produto Sem Token
    [Tags]    produtos    negativo
    ${dados}=    Gerar Dados Produto
    ${response}=    Cadastrar Produto    ${dados}    token_invalido
    Validar Status Code    ${response}    401

Buscar Produto Por Id Com Sucesso
    [Tags]    produtos    smoke
    ${id}    ${dados}=    Cadastrar Produto Com Sucesso    ${TOKEN_ADMIN}
    ${response}=    Buscar Produto Por Id    ${id}
    Validar Status Code    ${response}    200
    Should Be Equal As Strings    ${response.json()}[_id]    ${id}

Editar Produto Com Sucesso
    [Tags]    produtos    smoke
    ${id}    ${dados}=    Cadastrar Produto Com Sucesso    ${TOKEN_ADMIN}
    ${novos_dados}=    Gerar Dados Produto
    ${response}=    Editar Produto    ${id}    ${novos_dados}    ${TOKEN_ADMIN}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Registro alterado com sucesso

Excluir Produto Com Sucesso
    [Tags]    produtos    smoke
    ${id}    ${dados}=    Cadastrar Produto Com Sucesso    ${TOKEN_ADMIN}
    ${response}=    Excluir Produto    ${id}    ${TOKEN_ADMIN}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Registro excluído com sucesso

Excluir Produto Inexistente
    [Tags]    produtos    negativo
    ${id}    ${dados}=    Cadastrar Produto Com Sucesso    ${TOKEN_ADMIN}
    Excluir Produto    ${id}    ${TOKEN_ADMIN}
    ${response}=    Excluir Produto    ${id}    ${TOKEN_ADMIN}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Nenhum registro excluído

Filtrar Produtos Por Nome
    [Tags]    produtos    filtro
    ${id}    ${dados}=    Cadastrar Produto Com Sucesso    ${TOKEN_ADMIN}
    ${params}=    Create Dictionary    nome=${dados}[nome]
    ${response}=    Listar Produtos    ${params}
    Validar Status Code    ${response}    200
    ${quantidade}=    Set Variable    ${response.json()}[quantidade]
    Should Be Equal As Integers    ${quantidade}    1
