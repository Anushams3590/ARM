# ARM test assigment 

This repository contains test assigment from ARM.

# Usage
Pre-requisite tools: python3.10 , Robot Test Automation Tool

# Repo Directory Structure
Files are organised in my folder structure in the Repository

```
├── ARM
│   ├── jenkins
|   ├── tests
│   │   ├── input_files
│   │   |    ├── input1.json
│   │   |    ├── input2.json
│   │   |    ├── input1_invalid.json
│   │   |    ├── input1_no_value_object.json
│   │   |    ├── invalid_ipv4.json
│   │   └── test_suite
│   │       ├── ip_print_test.robot
│   └── ip_print.py
```
# Steps to Execute the Python Script

```shell
git clone https://github.com/Anushams3590/ARM.git
cd ARM
pip3 install -r requirement.txt
python3 ip_print.py tests/input_files/input1.json
python3 ip_print.py tests/input_files/input2.json

```
When Python script is directly executed, please check debug.log and error.log files for logs

# Steps to Execute the Robot Test Suite

```shell
git clone https://github.com/Anushams3590/ARM.git
cd ARM
pip install -r requirement.txt
cd tests/test_suite
robot ip_print_test.robot

```
For Robot test report please check report.html