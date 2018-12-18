Git
===

* Find when a given string was introduced to the code:
    * `git log -S"Bad line of code"`
* Find when a bug was introduced:
    * `git bisect start`
    * `git bisect bad HEAD`
    * `git bisect good <known_good_commit>`
    * `git bisect good` or `git bisect bad` as appropriate
    * `git bisect reset` to return to HEAD
    * Better yet, automate the test: `git bisect start HEAD <known_good_commit> run ./build_script.sh`
* Check out a version of a file from another commit or branch:
    * `git checkout <commit_or_branch> my_file`
* Find recent changes to a file:
    * `git log --since=two.weeks.ago --reverse -- my_file`
* View a file from another branch/commit:
    * `git show <commit_or_branch>:my_file`
* List total number of commits per person:
    * `git shortlog -s -n`
* Show all commits by a given person:
    * `git log --author='J. Random User'`
* Find a file within the repo:
    * `git ls-files *.c`
* Find a string within the repo:
    * `git grep -i --heading --line-number "foo bar"`
* Show names of files that differ from `master`:
    * `git diff --name-only master..`
