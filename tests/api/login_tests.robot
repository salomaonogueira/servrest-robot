*** Settings ***
Resource          ../../resources/api/login_keywords.resource
Resource          ../../resources/api/usuarios_keywords.resource
Suite Setup       Criar Sessão ServeRest

*** Test Cases ***
Login Com Sucesso
    [Tags]    login    smoke
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${token}=    Realizar Login Com Sucesso    ${dados}[email]    ${dados}[password]
    Should Not Be Empty    ${token}

Login Com Email Invalido
    [Tags]    login    negativo
    ${response}=    Realizar Login Com Credenciais Invalidas    email_invalido@teste.com    senha123
    Validar Mensagem    ${response}    Email e/ou senha inválidos

Login Com Senha Invalida
    [Tags]    login    negativo
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${response}=    Realizar Login Com Credenciais Invalidas    ${dados}[email]    senha_errada
    Validar Mensagem    ${response}    Email e/ou senha inválidos

Login Com Campos Vazios
    [Tags]    login    negativo
    ${response}=    Realizar Login    ${EMPTY}    ${EMPTY}
    Should Be Equal As Integers    ${response.status_code}    400
