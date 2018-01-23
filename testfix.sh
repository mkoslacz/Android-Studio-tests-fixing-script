#!/usr/bin/env bash

# This is a script that fixes (at least in my cases) AndroidStudio tests problems 
# like "Empty test suite", "JUnit version 3.8 or later expected", etc. 

# It is designed to work with AndroidStudio 2.3 and later and git-based project 
# with a .gitignore file adapted to work with AS git project (that ignores .gradle 
# and .idea folders, ie. https://gist.github.com/iainconnor/8605514)

# First of all, the first procedure you shall execute when you have the mentioned problems is:
# - Remove test configurations (expand the dropdown at the left side of a Run button -> Edit Configurations -> remove all Android JUnit and Android Instrumented Tests configs from the list -> Apply)
# - Rebuild your project (Build -> Rebuild Project)
# - Invalidate Cache/Restart Android Studio (File -> Invalidate Cache / Restart -> Invalidate and Restart)

# If it does not help - use this script as below:

# 0.0 Modify the script if needed:
# - Change the AS version to desired in the androidStudioVersion variable. Use only first two numbers (ie. 3.0)
# - If you don't use mac - change the AS preferences location in the androidStudioPrefsLocation variable. It needs to point to AndroidStudioX.X folder without the version postfix. "~/.AndroidStudio" should be ok in the most Linux distros AFAIK.

# 0.1 Give this script a runtime permission executing "chmod u+x ./testfix.sh"

# 0.2 If you want, install this script as a command executing 
# "cp ./testfix.sh /usr/local/bin/testfix; chmod a+x /usr/local/bin/testfix"
# or similar. Now you can run it anywhere by just typing "testfix"

# 1. Close your AS project.

# 2. Run this script inside your AS project dir.

# 3. Reopen the project in AS using "Open", NOT "Open Recent".

# 4. Rebuild the project.

# OPTIONAL: If you don't see some modules open settings.gradle file, remove its content, 
# rebuild the project, restore the original content, and rebuild the project 
# again. The modules should be visible again.

# BTW, I noticed test problems when: 
# porting a project between AS versions, 
# adding a submodule git root in AS and then changing a branch to the branch without submodule, 
# and sometimes randomly.

########################

androidStudioVersion="2.3" # edit this if needed - see above
androidStudioPrefsLocation="/Library/Preferences/AndroidStudio" # edit this if needed - see above

set -euo pipefail 
IFS=$'\n\t' # credits: http://redsymbol.net/articles/unofficial-bash-strict-mode/

git stash
git clean -xdf
find ${HOME}${androidStudioPrefsLocation}${androidStudioVersion}/tasks | grep ${PWD##*/} | xargs rm || echo "No AS tasks & contexts to delete found."
git stash pop || true
echo "Purging the project for tests fixing purposes done. Reopen and rebuild the project."