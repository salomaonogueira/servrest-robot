*** Settings ***
Resource          ../../resources/ui/cadastro_page.resource
Resource          ../../resources/ui/login_page.resource
Test Setup        Abrir Navegador ServeRest
Test Teardown     Fechar Navegador

*** Test Cases ***
Cadastrar Usuario Com Sucesso Via UI
    [Tags]    ui    cadastro    smoke
    ${nome}=     FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${senha}=    FakerLibrary.Password    length=8    special_chars=False
    Acessar Pagina De Cadastro
    Cadastrar Novo Usuario Via UI    ${nome}    ${email}    ${senha}
    Validar Cadastro Com Sucesso

Cadastrar Usuario Administrador Via UI
    [Tags]    ui    cadastro    smoke
    ${nome}=     FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${senha}=    FakerLibrary.Password    length=8    special_chars=False
    Acessar Pagina De Cadastro
    Cadastrar Novo Usuario Via UI    ${nome}    ${email}    ${senha}    admin=True
    Validar Cadastro Com Sucesso

Cadastrar Usuario Com Email Duplicado Via UI
    [Tags]    ui    cadastro    negativo
    ${nome}=     FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${senha}=    FakerLibrary.Password    length=8    special_chars=False
    Acessar Pagina De Cadastro
    Cadastrar Novo Usuario Via UI    ${nome}    ${email}    ${senha}
    Acessar Pagina De Cadastro
    Cadastrar Novo Usuario Via UI    ${nome}    ${email}    ${senha}
    Wait Until Page Contains    Este email já está sendo usado

Cadastrar Usuario Sem Nome Via UI
    [Tags]    ui    cadastro    negativo
    ${email}=    FakerLibrary.Email
    ${senha}=    FakerLibrary.Password    length=8    special_chars=False
    Acessar Pagina De Cadastro
    Preencher Dados Cadastro    ${EMPTY}    ${email}    ${senha}
    Submeter Cadastro
    Page Should Not Contain    Cadastro realizado com sucesso
