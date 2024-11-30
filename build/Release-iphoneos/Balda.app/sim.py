import subprocess
import re

def list_simulators():
    # Run the simctl list devices command
    result = subprocess.run(["xcrun", "simctl", "list", "devices"], capture_output=True, text=True)

    if result.returncode != 0:
        print("Failed to retrieve simulators.")
        print(result.stderr)
        return

    # Regex pattern to match simulator information
    simulator_pattern = re.compile(r'^\s*(?P<name>.+?) \((?P<udid>[0-9A-F-]+)\) \((?P<state>Booted|Shutdown)\)$')

    # Extract and print simulators
    print("Installed simulators:")
    for line in result.stdout.splitlines():
        match = simulator_pattern.match(line)
        if match:
            name = match.group("name")
            udid = match.group("udid")
            state = match.group("state")
            print(f"- {name} (UDID: {udid}, State: {state})")

# Run the function to list simulators
list_simulators()
