#!/usr/bin/env bash

# This is a script that fixes (at least in my cases) AndroidStudio tests problems 
# like "Empty test suite", "JUnit version 3.8 or later expected", etc. 

# It is designed to work on Unix systems with AndroidStudio 2.3 and later and git-based projects 
# with a .gitignore file adapted to work with AS git project (that ignores .gradle 
# and .idea folders, ie. https://gist.github.com/iainconnor/8605514)

####################################################################################
# WARNING! THIS SCRIPT "FIXES" ANDROID STUDIO TEST PROBLEMS BY RESETING YOUR PROJECT
# SETTINGS! ALL CODE CHANGES WILL BE KEPT, BUT YOU WILL LOSE YOUR PROJECT CONFIG 
# LIKE RUN CONFIGURATIONS DEFAULTS, EXISTING RUN CONFIGURATIONS, SUPRESSED WARNINGS 
# ETC. IT'S USUALLY JUST A FEW CLICKS TO RESTORE IT, BUT PLEASE, BE CAREFUL.
# TAKE INTO ACCOUNT THAT RESTORING THESE SETTINGS FROM BACKUP COULD DIMINISH EFFECTS
# OF THIS SCRIPT, SO IT'S RECOMMENDED TO RESTORE THEM MANUALLY.
####################################################################################

# More info on the github repo: https://github.com/mkoslacz/Android-Studio-tests-fixing-script

########################

androidStudioVersion="2.3" # edit this if needed - see above
androidStudioPrefsLocation="/Library/Preferences/AndroidStudio" # edit this if needed - see above
red='\033[0;31m'
yellow='\033[1;33m'
green='\033[0;32m'
noColor='\033[0m'

set -euo pipefail 
IFS=$'\n\t' # credits: http://redsymbol.net/articles/unofficial-bash-strict-mode/

echo -e "${green}Android Studio tests fixing script.${noColor}

${yellow}Make sure that:${noColor} 
	- you run this script inside the project you want to fix,
	- this project is a git-based project with a .gitignore file adapted to work with AndroidStudio (that ignores .gradle and .idea folders, ie. https://gist.github.com/iainconnor/8605514),
	- your project is ${red}NOT${noColor} opened in AndroidStudio right now,
	- you have tweaked this script to meet your AndroidStudio version and prefs location (see docs inside the script).

All code changes will be kept, but ${red}you will lose your project config${noColor} like run configurations defaults, existing run configurations, supressed warnings etc.

If you don't see some modules after the purge open settings.gradle file, remove its content, rebuild the project, restore the original content, and rebuild the project again. The modules should be visible again.

Read more on https://github.com/mkoslacz/Android-Studio-tests-fixing-script.\n"
read -p "Continue? (y/n)" -n 1 -r 
echo -e "\n"   # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	git stash
	git clean -xdf
	find ${HOME}${androidStudioPrefsLocation}${androidStudioVersion}/tasks | grep ${PWD##*/} | xargs rm || echo -e "${red}No AS tasks & contexts to delete found. Make sure that you are in the AS project dir and you have tweaked the Android Studio version and prefs dir inside this script.${noColor}"
	git stash pop || true
	echo -e "\nPurging the project for tests fixing purposes done. Read the log above. If everything is ok, reopen and rebuild the project."
fi