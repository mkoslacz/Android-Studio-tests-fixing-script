# Android Studio tests fixing script

This is the script that fixes Android Studio tests problems like `Empty test suite`, `JUnit version 3.8 or later expected`, etc. that happen pretty often when you switch branches frequently, ie. in the big teams.

It is designed to work on Unix systems with AndroidStudio 2.3 and later and git-based projects 
with a `.gitignore` file adapted to work with AS git project (that ignores `.gradle`
and `.idea` folders, ie. https://gist.github.com/iainconnor/8605514)

Script itself will ask you for confirmation after displaying the checklist when run.

# Warning!
**This script "fixes" Android Studio test problems by reseting your project settings! All of the code changes will be kept, but you will lose your project config like run configurations defaults, existing run configurations, supressed warnings etc. It's usually just a few clicks to restore it, but please, be careful. Take into account that restoring these settings from backup could diminish effects of this script, so it's recommended to restore them manually.**

I am aware that it is rather a workaround than the real solution as this script just blindly wipes out all of the project config. The point is that it's not really known why these test problems happen - if it would be known they will probably be fixed. See [this](https://stackoverflow.com/questions/14381694/why-is-the-android-test-runner-reporting-empty-test-suite), [this](https://stackoverflow.com/questions/22582021/android-studio-no-tests-were-found), and [that](https://stackoverflow.com/questions/2422378/intellij-idea-with-junit-4-7-junit-version-3-8-or-later-expected) stackoverflow questions - each responder in these threads states that other solution worked.

## Before running the script

If you don't want to loose your project config, you can try to run the following procedure:
- Remove test configurations (`expand the dropdown at the left side of a Run button -> Edit Configurations -> remove all Android JUnit and Android Instrumented Tests configs from the list -> Apply`)
- Rebuild your project (`Build -> Rebuild Project`)
- Invalidate Cache/Restart Android Studio (`File -> Invalidate Cache / Restart -> Invalidate and Restart`)

If it does not help - use this script as below.

## How does it work?

The script is really short and simple. It cleans all of the gradle and IDE caches inside the project by doing:
```
git stash
git clean -xdf
find ${HOME}${androidStudioPrefsLocation}${androidStudioVersion}/tasks | grep ${PWD##*/} | xargs rm
git stash pop
```
This commands set basically stashes your current work, deletes all ignored files (`-x`) including directories (`-d`) ([see docs](https://git-scm.com/docs/git-clean)) what causes your project to be like it's freshly cloned from remote, and removes project related files from `home/Library/Preferences/AndroidStudiox.x/tasks`, and then restores your stashed work.

Actually it's so simple that you can use these commands by hand instead of using my script. At first you can also try only the git commands, as it sometimes works.

## Script usage

### Setup & installation

1. Modify the script if needed:
	1. Change the AS version to desired in the androidStudioVersion variable. Use only first two numbers (ie. 3.0)
	2. If you don't use mac - change the AS preferences location in the androidStudioPrefsLocation variable. It needs to point to AndroidStudioX.X folder without the version postfix. `~/.AndroidStudio` should be ok in the most Linux distros AFAIK.

2. Give this script a runtime permission executing `chmod u+x ./testfix.sh`

3. If you want, install this script as a command executing `cp ./testfix.sh /usr/local/bin/testfix; chmod a+x /usr/local/bin/testfix` or similar. Now you can run it anywhere by just typing `testfix`

### Running the script - manual 

1. Close your AS project. **IMPORTANT**

2. Run this script inside your AS project dir.

3. Reopen the project in AS using `Open`, NOT `Open Recent`.

4. Rebuild the project.

5. OPTIONAL: If you don't see some of your modules open `settings.gradle` file, remove its content, rebuild the project, restore the original content, and rebuild the project again. The modules should be visible again.

## When these problems happen? 

I noticed tests problems when: 
- porting a project between AS versions, 
- adding a submodule git root in AS and then changing a branch to the branch without submodule, 
- switching between branches frequently (especially when having lots of generated code),
- and sometimes randomly.