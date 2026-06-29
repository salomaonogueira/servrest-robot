*** Settings ***
Resource          ../../resources/api/usuarios_keywords.resource
Resource          ../../resources/api/login_keywords.resource
Suite Setup       Criar Sessão ServeRest

*** Test Cases ***
Listar Usuarios Com Sucesso
    [Tags]    usuarios    smoke
    ${response}=    Listar Usuarios
    Validar Status Code    ${response}    200
    ${body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    usuarios

Cadastrar Usuario Com Sucesso
    [Tags]    usuarios    smoke
    ${dados}=    Gerar Dados Usuario
    ${response}=    Cadastrar Usuario    ${dados}
    Validar Status Code    ${response}    201
    Validar Mensagem    ${response}    Cadastro realizado com sucesso

Cadastrar Usuario Com Email Duplicado
    [Tags]    usuarios    negativo
    ${dados}=    Gerar Dados Usuario
    Cadastrar Usuario    ${dados}
    ${response}=    Cadastrar Usuario    ${dados}
    Validar Status Code    ${response}    400
    Validar Mensagem    ${response}    Este email já está sendo usado

Buscar Usuario Por Id Com Sucesso
    [Tags]    usuarios    smoke
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${response}=    Buscar Usuario Por Id    ${id}
    Validar Status Code    ${response}    200
    Should Be Equal As Strings    ${response.json()}[_id]    ${id}

Buscar Usuario Com Id Inexistente
    [Tags]    usuarios    negativo
    ${response}=    Buscar Usuario Por Id    id_invalido_123
    Validar Status Code    ${response}    400

Editar Usuario Com Sucesso
    [Tags]    usuarios    smoke
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${token}=    Realizar Login Com Sucesso    ${dados}[email]    ${dados}[password]
    ${novos_dados}=    Gerar Dados Usuario
    ${response}=    Editar Usuario    ${id}    ${novos_dados}    ${token}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Registro alterado com sucesso

Excluir Usuario Com Sucesso
    [Tags]    usuarios    smoke
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${token}=    Realizar Login Com Sucesso    ${dados}[email]    ${dados}[password]
    ${response}=    Excluir Usuario    ${id}    ${token}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Registro excluído com sucesso

Excluir Usuario Inexistente
    [Tags]    usuarios    negativo
    ${id}    ${dados}=    Cadastrar Usuario Com Sucesso
    ${token}=    Realizar Login Com Sucesso    ${dados}[email]    ${dados}[password]
    Excluir Usuario    ${id}    ${token}
    ${response}=    Excluir Usuario    ${id}    ${token}
    Validar Status Code    ${response}    200
    Validar Mensagem    ${response}    Nenhum registro excluído
