import os
import subprocess
import tempfile
import shutil
import git

# Constants
MODULES_FOLDER = "modules"
GITHUB_REPO = "https://github.com/rootstrap/flutter-base.git"


def add_module(module_name):
    # Create a temporary directory to clone the repository
    temp_dir = "/Users/Shared"

    module_branch = f"module/module_name"

    # git_cmd = "git clone -b " + module_name + " --no-checkout " + GITHUB_REPO + " " + temp_dir
    # os.system(git_cmd)
    current_dir = os.path.dirname(os.path.realpath(__file__))

    os.chdir(temp_dir)
    os.system(f"git clone -b {module_branch} {GITHUB_REPO}")
    # Clean up the temporary directory
    shutil.copytree(f"/Users/Shared/flutter-base/modules/{module_name}",
                    f"{current_dir}/modules/{module_name}")
    shutil.rmtree(f"{temp_dir}/flutter-base")

    print(f"Module '{module_name}' added successfully.")


# Main function
def main():
    module_name = input("Enter module name: ")
    add_module(module_name)


if __name__ == "__main__":
    main()
