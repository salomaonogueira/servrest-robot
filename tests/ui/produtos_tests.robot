*** Settings ***
Resource          ../../resources/ui/produtos_page.resource
Resource          ../../resources/ui/login_page.resource
Resource          ../../resources/api/base.resource
Resource          ../../resources/api/usuarios_keywords.resource
Resource          ../../resources/api/login_keywords.resource
Suite Setup       Preparar Dados UI Produtos
Test Setup        Abrir Navegador E Logar
Test Teardown     Fechar Navegador

*** Variables ***
${EMAIL_ADMIN}    ${EMPTY}
${SENHA_ADMIN}    ${EMPTY}

*** Keywords ***
Preparar Dados UI Produtos
    Criar Sessão ServeRest
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    Set Suite Variable    ${EMAIL_ADMIN}    ${dados}[email]
    Set Suite Variable    ${SENHA_ADMIN}    ${dados}[password]

Abrir Navegador E Logar
    Abrir Navegador ServeRest
    Acessar Pagina De Login
    Realizar Login Via UI    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    Validar Redirecionamento Para Home

*** Test Cases ***
Cadastrar Produto Via UI Com Sucesso
    [Tags]    ui    produtos    smoke
    ${nome}=       FakerLibrary.Word
    ${sufixo}=     FakerLibrary.Numerify    text=####
    ${nome_prod}=  Set Variable    ${nome} ${sufixo}
    Acessar Pagina De Produtos
    Cadastrar Produto Via UI    ${nome_prod}    100    Produto de teste    50
    Validar Produto Na Lista    ${nome_prod}

Listar Produtos Via UI
    [Tags]    ui    produtos    smoke
    Acessar Pagina De Produtos
    Wait Until Element Is Visible    ${BTN_CADASTRAR_PRODUTO}
    Page Should Contain Element    css=table, [data-testid="produto"], .card

Acessar Pagina De Cadastro De Produto
    [Tags]    ui    produtos    navegacao
    Acessar Pagina De Produtos
    Clicar Em Cadastrar Produto
    Wait Until Location Contains    cadastrarprodutos

Fazer Logout Da Pagina De Produtos
    [Tags]    ui    logout    smoke
    Acessar Pagina De Produtos
    Fazer Logout
    Wait Until Location Contains    login
