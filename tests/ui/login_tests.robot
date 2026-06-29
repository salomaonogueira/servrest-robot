*** Settings ***
Resource          ../../resources/ui/login_page.resource
Resource          ../../resources/ui/cadastro_page.resource
Resource          ../../resources/api/base.resource
Resource          ../../resources/api/usuarios_keywords.resource
Suite Setup       Criar Sessão ServeRest
Test Setup        Abrir Navegador ServeRest
Test Teardown     Fechar Navegador

*** Test Cases ***
Login Com Sucesso Via UI
    [Tags]    ui    login    smoke
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    Acessar Pagina De Login
    Realizar Login Via UI    ${dados}[email]    ${dados}[password]
    Validar Redirecionamento Para Home

Login Com Email Invalido Via UI
    [Tags]    ui    login    negativo
    Acessar Pagina De Login
    Realizar Login Via UI    email_invalido@email.com    senha123
    Validar Erro De Login

Login Com Senha Invalida Via UI
    [Tags]    ui    login    negativo
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    Acessar Pagina De Login
    Realizar Login Via UI    ${dados}[email]    senha_errada
    Validar Erro De Login

Login Com Campos Vazios Via UI
    [Tags]    ui    login    negativo
    Acessar Pagina De Login
    Clicar Em Entrar
    Wait Until Page Contains Element    css=[data-testid="email"]:invalid, .alert-danger, [class*="error"]

Navegar Para Cadastro Pela Tela De Login
    [Tags]    ui    login    navegacao
    Acessar Pagina De Login
    Clicar Em Cadastrar
    Wait Until Location Contains    cadastrarusuarios
