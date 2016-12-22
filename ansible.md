Ansible Cheatsheet
==================

General
-------

* Including other files:
~~~ yaml
    - include: other.yml
      tags: other
~~~
* Use a more YAML-like format, placing each option on a separate line:
~~~ yaml
    - name: Copy file
      copy:
        src: /tmp/resolv.conf
        dest: /etc/resolv.conf
~~~
* Use `block` to run several sub-tasks within a task:
~~~ yaml
    - name: Do some things
      block:
        - debug:
          msg: Doing some things
        - command: /bin/true
        - command: /bin/false
~~~
    * But you should probably use multiple tasks or `with_items`
* If you want a file to be owned by a user, it's easiest to use `become_user`
~~~ yaml
    - name: Download Craig's config files
      git:
        dest: /home/booch/config_files
        repo: https://github.com/booch/config_files.git
      become_user: booch
~~~
* Use `command` if possible, but use `shell` if using interpolation, pipes, or chained commands.
* Use `creates` to run a command only if a file does not exist already:
~~~ yaml
    command: command_to_run
    args:
      creates: /file/to/create
~~~
* Use `chdir` to change directories before running a command:
~~~ yaml
    command: command_to_run
    args:
      chdir: /path/to/run/in
~~~


Package Installation
--------------------

* Install a Homebrew package:
~~~ yaml
    homebrew:
      name: bash
~~~
* Install a Homebrew Cask package:
~~~ yaml
    homebrew_cask:
      name: atom
~~~
* Add a Homebrew tap:
~~~ yaml
    homebrew_tap:
      tap: homebrew/dupes
~~~
* Install an APT (Debian) package:
~~~ yaml
    apt:
      name: openssl-devel
~~~
* Install a DEB (Debian) package from a URL:
~~~ yaml
    apt:
      deb: https://example.com/python-ppq_0.1-1_all.deb
~~~


Files
-----

* Create a directory:
~~~ yaml
    file:
      path: /path/to/directory
      state: directory
      mode: 0700
~~~
* Create a soft link:
~~~ yaml
    file:
      src: /existing/file
      dest: /file/to/create/as/a/link/to/existing/file
      state: link
      force: yes
~~~
* Copy a file from the Ansible system to the target system:
~~~ yaml
    copy:
      src: files/path/to/file
      dest: /path/to/file
      mode: 0640
      owner: postgresql
      group: postgresql
~~~
* Add a line to a file:
~~~ yaml
      lineinfile:
        dest: /path/to/file
        line: 'key=value'
        regexp: '^#?key=' # Replace last occurrence that matches this regular expression.
        validate: 'visudo -cf %s' # Run this command; if it fails, don't overwrite the file.
~~~


Services
--------

* Start a service:
~~~ yaml
    service:
      name: httpd
      state: started
~~~
* Ensure a service starts on boot:
~~~ yaml
    service:
      name: httpd
      enabled: true
~~~


Users
-----

* Create a user:
~~~ yaml
  user:
    name: craig
    comment: "Craig Buchek"
    shell: /bin/bash
    groups: admins,developers
    append: yes    # Append the above groups to the default/existing set of groups.
    password: "$6$rounds=1000000$SALT$HASHED_PASSWORD_GENERATED_BY_mkpasswd"
    update_password: on_create    # Don't override the password if the user has changed it.
~~~
