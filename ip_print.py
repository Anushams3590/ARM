import json
import sys
import logging
import ipaddress


formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')

def setup_logger(name, log_file, level=logging.INFO):
    """To setup as many loggers as you want"""

    handler = logging.FileHandler(log_file)        
    handler.setFormatter(formatter)

    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.addHandler(handler)

    return logger

def is_valid_ipv4(ip):
    """Check if the provided string is a valid IPv4 address."""
    try:
        ipaddress.IPv4Address(ip)
        return True
    except ipaddress.AddressValueError:
        return False
    

def ip_print(input_file):
    logger.info('Executing ip_print Function')
    try:
        #Reading JSON file
        with open(input_file, 'r') as file:
            data = json.load(file)

        #Checking objects "value" or "vm_private_ips" 
        if "vm_private_ips" not in data or "value" not in data["vm_private_ips"]:
            print("Error: 'vm_pivate_ips' or 'value' object not found")
            error_logger.error (" 'value' object not found")
            file.close()
            return 1  # Return 1 on Failure

        value_obj = data["vm_private_ips"]["value"]

        # Check if the "network" object exists and prepare a lookup map
        network_lookup = {}
        if "network" in data and "vms" in data["network"]:
            for vm in data["network"]["vms"]:
                name = vm["attributes"]["name"]
                ip = vm["attributes"]["access_ip_v4"]
                network_lookup[name] = ip

        # Check the IP address format and print the IP addresses
        for name, ip in value_obj.items():
            if name in network_lookup:
                if (is_valid_ipv4(ip) == True) and (is_valid_ipv4(network_lookup[name]) == True):
                    print(f"{ip} {network_lookup[name]}")
                    logger.info("Both vaule and network object present in the JSON file and IP details are: " + str(ip) + " " + str(network_lookup[name]))
                else:
                    print("Error: Invalid IP address format")
                    error_logger.error("Invalid IP address: " + str(ip) + " " + str(network_lookup[name]))
            else:
                if is_valid_ipv4(ip) == True:
                    print(ip)
                else:
                    print("Error: Invalid IP address format")
                    error_logger.error("Invalid IP address: " + str(ip))

        file.close()        
        return 0  # Success exit code

    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found")
        error_logger.error ("File " + str(input_file) + "not found")
        return 2

    except json.JSONDecodeError:
        print(f"Error: File '{input_file}' is not a valid JSON")
        error_logger.error ("File " + str(input_file) + " is not a valid JSON")
        return 3

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        error_logger.error ("An unexpected error occurred: " + str(e))
        return 4

if __name__ == "__main__":
    logger = setup_logger('first_logger', 'debug.log')
    error_logger = setup_logger('error_logger', 'error.log')
    if len(sys.argv) != 2:
        print("Command line argument expected: ip_print <input_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    exit_code = ip_print(input_file)
    sys.exit(exit_code)
