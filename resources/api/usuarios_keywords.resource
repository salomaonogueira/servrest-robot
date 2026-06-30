*** Settings ***
Library    String
Resource    base.resource
Resource    login_keywords.resource

*** Keywords ***
Gerar Dados Usuario
    ${faker}=     Evaluate    __import__('faker').Faker('pt_BR')
    ${nome}=      Evaluate    $faker.name()
    ${email}=     Evaluate    $faker.unique.email()
    ${senha}=     Evaluate    $faker.password(length=8, special_chars=False)
    ${dados}=     Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${senha}
    ...    administrador=true
    RETURN    ${dados}

Cadastrar Usuario
    [Arguments]    ${dados}
    ${headers}=    Obter Headers Sem Token
    ${response}=   POST On Session    serverest    /usuarios    json=${dados}    headers=${headers}    expected_status=any
    RETURN    ${response}

Cadastrar Usuario Com Sucesso
    ${dados}=       Gerar Dados Usuario
    ${response}=    Cadastrar Usuario    ${dados}
    Validar Status Code    ${response}    201
    ${id}=    Set Variable    ${response.json()}[_id]
    RETURN    ${id}    ${dados}

Listar Usuarios
    [Arguments]    ${params}=${None}
    ${headers}=    Obter Headers Sem Token
    ${response}=   GET On Session    serverest    /usuarios    params=${params}    headers=${headers}    expected_status=any
    RETURN    ${response}

Buscar Usuario Por Id
    [Arguments]    ${id}
    ${headers}=    Obter Headers Sem Token
    ${response}=   GET On Session    serverest    /usuarios/${id}    headers=${headers}    expected_status=any
    RETURN    ${response}

Editar Usuario
    [Arguments]    ${id}    ${dados}    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   PUT On Session    serverest    /usuarios/${id}    json=${dados}    headers=${headers}    expected_status=any
    RETURN    ${response}

Excluir Usuario
    [Arguments]    ${id}    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   DELETE On Session    serverest    /usuarios/${id}    headers=${headers}    expected_status=any
    RETURN    ${response}
