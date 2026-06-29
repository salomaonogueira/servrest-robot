*** Settings ***
Resource    base.resource

*** Keywords ***
Realizar Login
    [Arguments]    ${email}    ${password}
    ${headers}=    Obter Headers Sem Token
    ${body}=       Create Dictionary    email=${email}    password=${password}
    ${response}=   POST On Session    serverest    /login    json=${body}    headers=${headers}    expected_status=any
    RETURN    ${response}

Realizar Login Com Sucesso
    [Arguments]    ${email}    ${password}
    ${response}=    Realizar Login    ${email}    ${password}
    Validar Status Code    ${response}    200
    ${token}=    Set Variable    ${response.json()}[authorization]
    RETURN    ${token}

Realizar Login Com Credenciais Invalidas
    [Arguments]    ${email}    ${password}
    ${response}=    Realizar Login    ${email}    ${password}
    Validar Status Code    ${response}    401
    RETURN    ${response}
