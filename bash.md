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
