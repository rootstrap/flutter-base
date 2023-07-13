import os
import subprocess
import tempfile
import shutil

# Constants
MODULES_FOLDER = "module"
GITHUB_REPO = "https://github.com/rootstrap/flutter-base/"


def add_module(module_name):
    # Create a temporary directory to clone the repository
    temp_dir = tempfile.mkdtemp()

    # Clone the repository using git
    git_clone_cmd = ["git", "clone -b " + module_name, GITHUB_REPO, temp_dir]
    subprocess.run(git_clone_cmd)

    # Copy the module to the desired folder
    module_folder = os.path.join(MODULES_FOLDER, module_name)
    shutil.copytree(temp_dir + "/" + MODULES_FOLDER + "/" + module_name, module_folder)

    # Clean up the temporary directory
    shutil.rmtree(temp_dir)

    print(f"Module '{module_name}' added successfully.")


# Main function
def main():
    module_name = input("Enter module name: ").split()
    add_module(module_name)


if __name__ == "__main__":
    main()
