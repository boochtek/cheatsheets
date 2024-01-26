Bash Cheatsheet
===============

This is primarily for shell scripting.
I've begun to transition to using ZSH as my default interactive shell.


## Script Template

Here's a good template to start with, which includes all the best practices I know of.

~~~ bash
#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail
[[ "$DEBUG" ]] && set -o xtrace
IFS=$' \n\t'

main() {
    print_help
    confirm_prerequisites
    trap cleanup EXIT
    # ... do the actual work (mostly in functions) ...
}

print_help() {
    if [ ${#@} -ne 0 ] && [ "${@#"--help"}" = "" ]; then
        echo 'Help message for the command'
        exit 0;
    fi
}

confirm_prerequisites() {
    command -v brew > /dev/null || ( echo 'Please install Homebrew!' && exit 127 )
}

cleanup() {
    ERROR_CODE="$?"
    # ... cleanup code ...
    exit $ERROR_CODE
}

main
~~~

NOTES:

* `-o errexit` is equivalent to `-e`: stop immediatedly if any command fails
    * If you want to continue running despite errors, change this to `+o errexit`
    * Note that there are some gotchas with `set -e`:
        * http://mywiki.wooledge.org/BashFAQ/105/Answers
        * But I think I can work around them, and they'd be easily found during testing
* `-o errtrace` is equivalent to `-E`: stop immediatedly if any command fails within a function or subshell
* `-o nounset` is equivalent to `-u`: raise an error when trying to evaluate an unset variable
* `-o xtrace` is equivalent to `-x`: print each line before executing it
* `IFS=$' \n\t'` resets field separators to the default, so any external setting doesn't mess us up
    * See https://unix.stackexchange.com/q/26784 for more details
* If your file is normally used as a library, use this instead of just calling `main`:
    * `[[ "$0" == "$BASH_SOURCE" ]] && my_local_main`
    * Also considering passing `"$@"` to `my_local_main`

## Modifying file contents

~~~ bash
# Uncomment a commented-out line in a file.
# NOTE: Don't actually use `-i`; it doesn't work in macOS.
WORDS_IN_LINE='Part of the line to uncomment that will be unique within the file, being careful not to mess up the regex'
sed -i "/${WORDS_IN_LINE}/s/^#//g" file.txt

# Add a line to the end of a file, only if it's not already in the file.
LINE_TO_ADD='This line will be added'
FILE='file.txt'
grep --silent --line-regexp -F "$LINE_TO_ADD" "$FILE" || \
    echo "$LINE_TO_ADD" >> "$FILE"

# Add a line to a file, only if it's not already in the file.
LINE_TO_ADD='This line will be added'
AFTER='This line will be before the new line'
FILE='file.txt'
grep --silent --line-regexp -F "$LINE_TO_ADD" "$FILE" || \
    sed -i "/${AFTER}/a ${LINE_TO_ADD}" "$FILE"
~~~



## Git post-checkout hook

~~~ bash
PREVIOUS_HEAD="$1"
NEW_HEAD="$2"
NEW_BRANCH="$(git branch --show-current)"
[[ "$3" == 1 ]] && CHECKOUT_TYPE='branch' || CHECKOUT_TYPE='file'

if [[ "$CHECKOUT_TYPE" == 'branch' ]]; then
    # Do whatever you want to do when a branch is checked out.
    # Note that stdout and stderr seemingly get dropped.
    bundle install
fi
~~~

## Prompt

~~~ bash
# TODO: Check Stack Overflow; shellcheck should also help.

# Read 1 character without waiting for a return.
read -r -n 1 var_name

# Prompt for a yes/no question, read only 1 character.
# Return 0 (true) if a `y` or `Y` is entered, otherwise a 1.
# Adapted from https://stackoverflow.com/a/29436423.
yes_or_no() {
    prompt="$*"
    read -n 1 -p "$prompt [y/n]: " -r -s yn
    [[ "$yn" == [Yy]* ]] && return 0 || return 1
}
yes_or_no 'Continue?' && echo 'continue' || echo 'nope!'
~~~

## Color

~~~ bash
ansi() {
    # Don't output anything unless we're outputting to a terminal on stdout.
    [[ -t 1 ]] || return

    case "$1" in
    'black')
        tput setaf 0
        ;;
    'red')
        tput setaf 1
        ;;
    'green')
        tput setaf 2
        ;;
    'yellow')
        tput setaf 3
        ;;
    'blue')
        tput setaf 4
        ;;
    'magenta')
        tput setaf 5
        ;;
    'cyan')
        tput setaf 6
        ;;
    'white')
        tput setaf 7
        ;;
    'bold' | 'bright')
        tput bold
        ;;
    'reset' | 'normal')
        tput sgr0
        ;;
    *)
        echo default
        ;;
    esac
}

## What process is using a file?

~~~ bash
lsof -r /path/to/file
~~~

## Other
