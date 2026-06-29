*** Settings ***
Resource    base.resource

*** Keywords ***
Gerar Dados Produto
    ${nome}=        FakerLibrary.Word
    ${sufixo}=      FakerLibrary.Numerify    text=####
    ${preco}=       FakerLibrary.Random Int    min=10    max=9999
    ${descricao}=   FakerLibrary.Sentence    nb_words=5
    ${dados}=       Create Dictionary
    ...    nome=${nome} ${sufixo}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${50}
    RETURN    ${dados}

Cadastrar Produto
    [Arguments]    ${dados}    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   POST On Session    serverest    /produtos    json=${dados}    headers=${headers}    expected_status=any
    RETURN    ${response}

Cadastrar Produto Com Sucesso
    [Arguments]    ${token}
    ${dados}=       Gerar Dados Produto
    ${response}=    Cadastrar Produto    ${dados}    ${token}
    Validar Status Code    ${response}    201
    ${id}=    Set Variable    ${response.json()}[_id]
    RETURN    ${id}    ${dados}

Listar Produtos
    [Arguments]    ${params}=${None}
    ${headers}=    Obter Headers Sem Token
    ${response}=   GET On Session    serverest    /produtos    params=${params}    headers=${headers}    expected_status=any
    RETURN    ${response}

Buscar Produto Por Id
    [Arguments]    ${id}
    ${headers}=    Obter Headers Sem Token
    ${response}=   GET On Session    serverest    /produtos/${id}    headers=${headers}    expected_status=any
    RETURN    ${response}

Editar Produto
    [Arguments]    ${id}    ${dados}    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   PUT On Session    serverest    /produtos/${id}    json=${dados}    headers=${headers}    expected_status=any
    RETURN    ${response}

Excluir Produto
    [Arguments]    ${id}    ${token}
    ${headers}=    Obter Headers Com Token    ${token}
    ${response}=   DELETE On Session    serverest    /produtos/${id}    headers=${headers}    expected_status=any
    RETURN    ${response}
