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

    # git_cmd = "git clone -b " + module_name + " --no-checkout " + GITHUB_REPO + " " + temp_dir
    # os.system(git_cmd)

    os.chdir(temp_dir)
    os.system(f"git clone {GITHUB_REPO}")
    os.system(f"git checkout {module_name}")
    #os.system(f"cp {TARGET_FOLDER} {TARGET_DESTINATION}")

    # Clone the repository using git
    # git_clone_cmd = ["git", "clone -b", git_ref, temp_dir]
    # subprocess.run(git_clone_cmd)

    # git.Git(temp_dir).clone(GITHUB_REPO).branch(module_name)
    # .execute(git_cmd)
    # .clone(GITHUB_REPO).branch(module_name)

    # Copy the module to the desired folder
    module_folder = os.path.join(MODULES_FOLDER, module_name)
    shutil.copytree(temp_dir + "/flutter-base/" + module_folder, module_folder)

    # Clean up the temporary directory
    shutil.rmtree(temp_dir)

    print(f"Module '{module_name}' added successfully.")


# Main function
def main():
    module_name = input("Enter module name: ")
    add_module(module_name)


if __name__ == "__main__":
    main()
