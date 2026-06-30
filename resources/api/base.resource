*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${BASE_URL}        https://serverest.dev
${CONTENT_TYPE}    application/json

*** Keywords ***
Criar Sessão ServeRest
    Create Session    serverest    ${BASE_URL}    verify=True

Obter Headers Com Token
    [Arguments]    ${token}
    ${headers}=    Create Dictionary
    ...    Content-Type=${CONTENT_TYPE}
    ...    Authorization=${token}
    RETURN    ${headers}

Obter Headers Sem Token
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
    RETURN    ${headers}

Validar Status Code
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

Validar Mensagem
    [Arguments]    ${response}    ${mensagem}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${body}[message]    ${mensagem}
