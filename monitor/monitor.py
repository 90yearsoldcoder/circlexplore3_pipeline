import subprocess
import time
import argparse

bash_command = "pquota -u ad-portal" 
user = 'minty'

# Create the parser
parser = argparse.ArgumentParser(description='')

# Add the '-m' argument
parser.add_argument('-m', type=int, help='Time/minutes')

# Parse the command line arguments
args = parser.parse_args()
minutes = args.m

def extract_quota(result):
    lines = result.split("\n")
    for line in lines:
        if user not in line:
            continue
        space_using = line.split()[1]
        return space_using

def run_bash_command(command):
    # Run the Bash command and return its output
    bash_result = subprocess.run(command, shell=True, text=True, capture_output=True)
    return extract_quota(bash_result.stdout.strip())

def save_number_to_file(number, filename="space_using_record.txt"):
    # Save the given number to a file, appending to the file
    with open(filename, "a") as file:
        file.write(number + ",")

# Number of iterations for demonstration (replace with a while True loop for continuous execution)
for _ in range(minutes):
    number = run_bash_command(bash_command)
    print(f"Space_using: {number}")
    save_number_to_file(number)
    
    # Wait for 60 seconds before running the command again
    time.sleep(60)


#test block
#run_bash_command(bash_command)