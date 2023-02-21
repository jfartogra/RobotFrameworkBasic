*** Settings ***
Documentation  Testing demoblaze
Library  SeleniumLibrary
Library  Collections

*** Variables ***

${URL}        https://www.demoblaze.com/
${BROWSER}    Firefox
${MYTIMEOUT}  5
${CONST_REMAINING_TIME}  7:40

*** Test Cases ***

website up and running
    [documentation]  Website up and running
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Wait Until Element Is Visible  id:cat  timeout=${MYTIMEOUT}
    Close Browser

Verify home page structure
    [documentation]  Checks main page structure
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Wait Until Element Is Visible  id:nava  timeout=${MYTIMEOUT}
    ${menu_home} =  Get WebElement  class:active
    Element Should Be Visible  ${menu_home}  timeout=${MYTIMEOUT}
    Element Should Contain  ${menu_home}     Home
    Element Should Be Visible  link:Contact   timeout=${MYTIMEOUT}
    Element Should Be Visible  link:About us   timeout=${MYTIMEOUT}
    Element Should Be Visible  link:Cart   timeout=${MYTIMEOUT}
    Element Should Be Visible  link:Log in   timeout=${MYTIMEOUT}
    Element Should Be Visible  link:Sign up   timeout=${MYTIMEOUT}
    Element Should Be Visible  id:cat   timeout=${MYTIMEOUT}
    Element Should Be Visible  link:Phones   timeout=${MYTIMEOUT}
    Element Should Be Visible  link:Laptops   timeout=${MYTIMEOUT}
    Element Should Be Visible  link:Monitors   timeout=${MYTIMEOUT}
    Element Should Be Visible  id:tbodyid   timeout = ${MYTIMEOUT}
    ${menu_home_class}= 	Get Element Attribute 	${menu_home}  class
    Log    ${menu_home_class}
    Close Browser


Checking contact page and closes form
    [documentation]  Checks contact page and closes the form
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Wait Until Element Is Visible  id:nava  timeout=${MYTIMEOUT}
    Click Link   link:Contact
    Page Should Contain  New message
    Click Button  class:btn-secondary
    Close Browser


Checking contact page and sends a form
    [documentation]  Checks contact page and sends a form
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Wait Until Element Is Visible  id:nava  timeout=${MYTIMEOUT}
    Click Link   link:Contact
    Page Should Contain  New message
    Input Text   id:recipient-email    thomas@gmail.com
    Input Text   id:recipient-name     thomas
    Input Text   id:message-text       Hi. I am Thomas!
    Click Button  class:btn-primary
    Handle Alert  action=ACCEPT
    Close Browser

Checking about us and close video
    [documentation]  Checks about us and closes the video
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Click Link   link:About us
    Wait Until Element Is Visible  id:example-video  timeout=${MYTIMEOUT}
    Click Button  css:#videoModal > div:nth-child(1) > div:nth-child(1) > div:nth-child(3) > button:nth-child(1)
    Close Browser

Checking about us and playing video
    [documentation]  Checks about us and playing the video
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Click Link   link:About us
    Wait Until Element Is Visible  id:example-video  timeout=${MYTIMEOUT}
    Click Button  class:vjs-big-play-button
    Click Element At Coordinates   class:vjs-progress-holder  20  0
    ${remaining_time} =  Get Text  class:vjs-remaining-time-display
    Log    Remaining time is ${remaining_time}
    Log To Console   Remaining time is ${remaining_time}
  #  ${remaining_time} =   Convert To String   ${remaining_time}
    Should Be Equal    ${remaining_time}   ${CONST_REMAINING_TIME}
    Close Browser

Checking log in
    [documentation]  Checks log in
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Click Link   link:Log in
    Input Text   id:loginusername    Damaso
    Input Password  id:loginpassword    Alonso
    Click Button    css:#logInModal > div:nth-child(1) > div:nth-child(1) > div:nth-child(3) > button:nth-child(2)
    Element Should Be Visible  link:Contact   timeout=${MYTIMEOUT}
   # Element Should Be Visible  link:logout2   timeout=${MYTIMEOUT}
  #  Element Should Be Visible  link:Welcome Damaso   timeout=${MYTIMEOUT}
  #  Element Should Be Visible   id:nameofuser   timeout=${MYTIMEOUT}
    Wait Until Element Is Visible   id:nameofuser   timeout=${MYTIMEOUT}
    Element Should Be Visible   link:Log out   timeout=${MYTIMEOUT}
    Close Browser

Checking log out
    [documentation]  Checks log out
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Click Link   link:Log in
    Input Text   id:loginusername    Damaso
    Input Password  id:loginpassword    Alonso
    Click Button    css:#logInModal > div:nth-child(1) > div:nth-child(1) > div:nth-child(3) > button:nth-child(2)
    Wait Until Element Is Visible   id:nameofuser   timeout=${MYTIMEOUT}
    Click Link   link:Log out
    Wait Until Element Is Visible   link:Log in   timeout=${MYTIMEOUT}
    Close Browser


Check categories
    [documentation]  Check categories
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Wait Until Element Is Visible  class:hrefch  timeout=${MYTIMEOUT}
    @{products_list} =    Get Web Elements   class:hrefch
    ${list_size} =      Get length       ${products_list}
    Should Be Equal As Numbers   ${list_size}    9
    IF    ${list_size} == 9
        Log To Console      list_size is 9
    ELSE
        Log To Console      list_size is not 9
    END
    Log To Console   List size ${list_size}
    FOR    ${product}   IN  @{products_list}
            Log To Console   Product text: ${product.text},
    END
    Click Button    id:next2
    Wait Until Element Is Not Visible  id:next2  timeout=${MYTIMEOUT}
    @{products_list_2} =    Get Web Elements   class:hrefch
    ${list_size_2} =      Get length       ${products_list_2}
    Log To Console   List size_2 ${list_size_2}
     FOR    ${product_2}   IN  @{products_list_2}
            Log To Console   Product text: ${product_2.text},
    END
    ${list_size_2} =      Get length       ${products_list_2}
    Should Be Equal As Numbers   ${list_size_2}    6
    Close Browser


Buy a product
    [documentation]  Buy a product
    [tags]  Smoke
    Open Browser  ${URL}  ${BROWSER}
    Wait Until Element Is Visible  class:hrefch  timeout=${MYTIMEOUT}
    @{products_list} =    Get Web Elements   class:hrefch
    ${product_to_be_bought} =  Get From List    ${products_list}   0
    Log To Console   product ${product_to_be_bought.text}
    Click Element       ${product_to_be_bought}
    Wait Until Element Is Visible   class:name   timeout=${MYTIMEOUT}
    ${product} =  Get Web Element  class:name
    Should Be Equal As Strings      ${product.text}       Samsung galaxy s6
    Click Element        class:btn-success
    Handle Alert  action=ACCEPT
    Click Link   link:Cart
    Wait Until Element Is Visible  class:success  timeout=${MYTIMEOUT}
    ${product_in_table} =   Get Web Element   xpath:/html/body/div[6]/div/div[1]/div/table/tbody/tr/td[2]
    Should Be Equal As Strings      ${product_in_table.text}        Samsung galaxy s6





*** Keywords ***



