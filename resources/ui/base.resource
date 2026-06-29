*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary    locale=pt_BR
Library    Collections
Library    String

*** Variables ***
${BROWSER}         chrome
${FRONT_URL}       https://front.serverest.dev
${TIMEOUT}         15s
${IMPLICIT_WAIT}   5s

*** Keywords ***
Abrir Navegador ServeRest
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium
    Evaluate    $options.add_argument('--no-sandbox')
    Evaluate    $options.add_argument('--disable-dev-shm-usage')
    Evaluate    $options.add_argument('--disable-gpu')
    IF    '${HEADLESS}' == 'true'
        Evaluate    $options.add_argument('--headless=new')
    END
    Open Browser    ${FRONT_URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    ${TIMEOUT}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Maximize Browser Window

Fechar Navegador
    Close Browser

Aguardar E Clicar
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}

Aguardar E Digitar
    [Arguments]    ${locator}    ${texto}
    Wait Until Element Is Visible    ${locator}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${texto}

Aguardar Mensagem De Sucesso
    [Arguments]    ${mensagem}
    Wait Until Page Contains    ${mensagem}

Aguardar Mensagem De Erro
    [Arguments]    ${mensagem}
    Wait Until Page Contains    ${mensagem}

*** Variables ***
${HEADLESS}    false
