import os
import shutil

# Constants
MODULES_FOLDER = "modules"
GITHUB_REPO = "https://github.com/rootstrap/flutter-modules.git"


def add_module(module_name):
    # Create a temporary directory to clone the repository
    temp_dir = "/Users/Shared"

    module_branch = f"module/{module_name}"

    current_dir = os.path.dirname(os.path.realpath(__file__))

    os.chdir(temp_dir)
    os.system(f"git clone -b {module_branch} {GITHUB_REPO}")

    shutil.copytree(f"/Users/Shared/flutter-base-may-2024/modules/{module_name}",
                    f"{current_dir}/modules/{module_name}")

    # Clean up the temporary directory
    shutil.rmtree(f"{temp_dir}/flutter-base")

    print(f"Module '{module_name}' added successfully.")


# Main function
def main():
    module_name = input("Add module. \n Enter module name: ")
    add_module(module_name)


if __name__ == "__main__":
    main()
