import subprocess

# Define your list of simulators
simulators = [
    {"name": "iPhone 16", "os": "iOS 18.0"},
#    {"name": "iPhone SE (3rd generation)", "os": "iOS 17.0"},
#    {"name": "iPad Pro (11-inch) (4th generation)", "os": "iOS 17.0"}
]

# Path to your Xcode project and scheme
project_path = "/Users/poryadin.andrey/Desktop/snake/sleeper/sleeper/balda/balda-2/balda-2/balda-2.xcodeproj"  # Replace with your project path
scheme = "balda-2UITests"                      # Replace with your UI test scheme

# Iterate through each simulator and run the tests
for simulator in simulators:
    print(f"Running UI tests on {simulator['name']} with OS {simulator['os']}...")

    # Construct the xcodebuild command
    command = [
        "xcodebuild",
        "-project", project_path,
        "-scheme", scheme,
        "-destination", f"platform=iOS Simulator,name={simulator['name']},OS={simulator['os']}",
        "test"
    ]

    # Run the command
    result = subprocess.run(command, capture_output=True, text=True)

    # Check if the command was successful
    if result.returncode == 0:
        print(f"Tests succeeded on {simulator['name']} with OS {simulator['os']}")
    else:
        print(f"Tests failed on {simulator['name']} with OS {simulator['os']}")
        print("Error output:")
        print(result.stderr)

print("All tests completed on specified simulators.")
