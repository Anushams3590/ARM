*** Settings ***
Library    OperatingSystem
Library    Process
Suite Setup  Create Directory  output


*** Variables ***
${SCRIPT_DIR}   ${CURDIR}/../../
${INPUT_DIR}    ${CURDIR}/../input_files/
${SCRIPT}       ${SCRIPT_DIR}ip_print.py

*** Test Cases ***

Test Input1.json
    [Documentation]  Test ip_print.py with input1.json file
    ${result}=    Run Process   python3  ${SCRIPT}    ${INPUT_DIR}input1.json   shell=True  stdout=${CURDIR}/output/input1_output.txt
    ${output}=    Get File    ${CURDIR}/output/input1_output.txt
    Should Be Equal As Strings    ${output.strip()}    192.168.101.101\n192.168.101.70\n192.168.101.153
    Should Be Equal As Integers   ${result.rc}    0

Test Input2.json
    [Documentation]  Test ip_print.py with input2.json file
    ${result}=    Run Process    python3  ${SCRIPT}    ${INPUT_DIR}input2.json    shell=True    stdout=output/input2_output.txt
    ${output}=    Get File    output/input2_output.txt
    Should Be Equal As Strings    ${output.strip()}    192.168.102.33 10.0.0.87\n192.168.103.74 10.0.0.77\n192.168.102.155 10.0.0.99
    Should Be Equal As Integers   ${result.rc}    0

Test for File not found Error
    [Documentation]  Test ip_print.py for file not found error
    ${result}=    Run Process    python3  ${SCRIPT}    ${INPUT_DIR}input3.json    shell=True    stdout=output/file_not_found_output.txt
    ${output}=    Get File    output/file_not_found_output.txt
    Should Contain    ${output.strip()}    Error: File '${INPUT_DIR}input3.json' not found
    Should Be Equal As Integers   ${result.rc}    2

Test Invalid JSON
    [Documentation]  Test ip_print.py with an invalid JSON file
    ${result}=    Run Process    python3  ${SCRIPT}    ${INPUT_DIR}input1_invalid.json    shell=True    stdout=output/invalid_output.txt
    ${output}=    Get File    output/invalid_output.txt
    Should Contain    ${output.strip()}    Error: File '${INPUT_DIR}input1_invalid.json' is not a valid JSON
    Should Be Equal As Integers   ${result.rc}    3
    

Test Invalid Value Object
    [Documentation]  Test ip_print.py with a file missing "value" object in "vm_private_ips"
    ${result}=    Run Process    python3  ${SCRIPT}    ${INPUT_DIR}input1_no_value_object.json    shell=True    stdout=output/novalue_output.txt
    ${output}=    Get File    output/novalue_output.txt
    Should Contain    ${output.strip()}    Error: 'vm_pivate_ips' or 'value' object not found
    Should Be Equal As Integers   ${result.rc}    1


Test Invalid IPv4 format
    [Documentation]  Test ip_print.py with a file missing "value" object in "vm_private_ips"
    ${result}=    Run Process   python3  ${SCRIPT}    ${INPUT_DIR}input_invalid_ipv4.json    shell=True    stdout=output/invalid_ipv4.txt
    ${output}=    Get File    output/invalid_ipv4.txt
    Should Contain    ${output.strip()}    Error: Invalid IP address format

  