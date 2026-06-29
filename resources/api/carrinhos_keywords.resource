*** Settings ***
Resource    base.resource

*** Keywords ***
Montar Carrinho
    [Arguments]    ${produto_id}    ${quantidade}=1
    ${produto}=    Create Dictionary    idProduto=${produto_id}    quantidade=${quantidade}
    ${lista}=      Create List    ${produto}
    ${dados}=      Create Dictionary    produtos=${lista}
    RETURN    ${dados}

Cadastrar Carrinho
    [Arguments]    ${dados}    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   POST On Session    serverest    /carrinhos    json=${dados}    headers=${headers}    expected_status=any
    RETURN    ${response}

Listar Carrinhos
    ${headers}=    Obter Headers Sem Token
    ${response}=   GET On Session    serverest    /carrinhos    headers=${headers}    expected_status=any
    RETURN    ${response}

Buscar Carrinho Por Id
    [Arguments]    ${id}
    ${headers}=    Obter Headers Sem Token
    ${response}=   GET On Session    serverest    /carrinhos/${id}    headers=${headers}    expected_status=any
    RETURN    ${response}

Concluir Compra
    [Arguments]    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   DELETE On Session    serverest    /carrinhos/concluir-compra    headers=${headers}    expected_status=any
    RETURN    ${response}

Cancelar Compra
    [Arguments]    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   DELETE On Session    serverest    /carrinhos/cancelar-compra    headers=${headers}    expected_status=any
    RETURN    ${response}
