Ansible Cheatsheet
==================

General
-------

* List all available modules:
~~~ shell
ansible-doc -l
~~~
* To avoid being prompted to verify SSH signatures:
    * Run with environment variable `ANSIBLE_HOST_KEY_CHECKING=False` set
    * Or set `host_key_checking = False` in `[defaults]` of `~/.ansible.cfg`
    * Would not recommend this for PROD environments, but good for Vagrant
* Run against a single target machine (but use inventory to set variables):
~~~ shell
ansible-playbook --limit machine_to_run_on playbook.yml
~~~
* Including other files:
~~~ yaml
    - include: other.yml
      tags: other
~~~
* Tags - every task should probably have a tag
    * Either at the task level, or at the include or dependencies level
    * Makes it easier to run a subset with `-t tag_name`
    * Makes it easier to skip subsets with `--skip-tags tag_name`
* To start where you left off (if something failed), use the `--start` option, giving the name of a step.
* Use a more YAML-like format, placing each option on a separate line:
~~~ yaml
    - name: Copy file
      copy:
        src: /tmp/resolv.conf
        dest: /etc/resolv.conf
~~~
* To disable logging of a task:
~~~ yaml
    - name: Secret stuff
      command: "echo {{secret_root_password}} | sudo su -"
      no_log: true
~~~
    * It will hide any output
    * It will hide any commands that would be printed if you're using `-v`
    * It will print `censored due to no_log`
* Use `block` to run several sub-tasks within a task (but you should probably use multiple tasks or `with_items`):
~~~ yaml
    - name: Do some things
      block:
        - debug:
          msg: Doing some things
        - command: /bin/true
        - command: /bin/false
~~~
* If you want a file to be owned by a user, it's easiest to use `become_user`
~~~ yaml
    - name: Download Craig's config files
      git:
        dest: /home/booch/config_files
        repo: https://github.com/booch/config_files.git
      become_user: booch
~~~
* Avoid `command` and `shell`, if possible
    * Use a more appropriate module, if available
    * Of the 2, prefer `command`, if it will work for you
    * Use `shell` if you need shell functionality, like interpolation, pipes, or chained commands
* Use `creates` to run a command only if a file does not exist already:
~~~ yaml
    command: command_to_run
    args:
      creates: /file/to/create  # May include wildcards, as of Ansible 2.0
~~~
* Use `chdir` to change directories before running a command:
~~~ yaml
    command: command_to_run
    args:
      chdir: /path/to/run/in
~~~
* To determine if a condition already exists, use this pattern (this is a good way to ensure idempotency):
~~~ yaml
    - name: Determine xyz
      command: xyz --list
      register: xyz
      changed_when: FALSE
      ignore_errors: TRUE

    - name: Xyz
      command: xyz --install {{ item }}
      when: item not in xyz.stdout or xyz.stdout.startswith(item) or xyz.rc != 0
      with_items:
        - abc
        - def
~~~
* To suppress log output for a task (like if it has passwords/secrets):
    * On top-level of task: `no_log: true`
* Waiting for something:
~~~ yaml
    - name: Wait for Jenkins to start up before proceeding
      shell: curl -D - --silent http://{{ jenkins_hostname }}:{{ jenkins_http_port }}{{ jenkins_url_prefix }}/cli/
      register: result
      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("200 OK") != -1) and (result.stdout.find("Please wait while") == -1)
      retries: 60
      delay: 5
      changed_when: FALSE
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
      name:
        - openssl
        - openssl-devel
~~~
* Install an APT (Debian) package from a URL:
~~~ yaml
    apt:
      deb: https://example.com/python-ppq_0.1-1_all.deb
~~~
* Add a YUM repo:
~~~ yaml
    yum_repository:
      name: epel
      description: EPEL YUM repo
      baseurl: https://download.fedoraproject.org/pub/epel/$releasever/$basearch/
      gpgkey: https://getfedora.org/static/352C64E5.txt
      gpgcheck: yes
    when: ansible_pkg_mgr == "yum"
~~~
* Install an RPM package (via YUM):
~~~ yaml
    yum:
      state: installed
      name:
        - curl
        - httpie
    when: ansible_pkg_mgr == "yum"
~~~
* Install an RPM package (via YUM) from a URL:
~~~ yaml
    yum:
      state: installed
      name: http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
~~~
* Install a DEB (Debian) package from a URL:
~~~ yaml
    apt:
      deb: https://example.com/python-ppq_0.1-1_all.deb
~~~
* Download and unpack a ZIP file:
~~~ yaml
    unarchive:
      src: https://example.com/example.zip
      dest: /usr/local/bin
      remote_src: TRUE
~~~
    * Can also unpack `tar.gz`, `.tar.bz2`, and `.tgz` files


Files
-----

* Ensure a file exists (but don't touch it if it already exists):
~~~ yaml
    copy:
      dest: /path/to/file
      content: ""
      force: no
~~~
* Create a directory:
~~~ yaml
    file:
      path:
        - /path/to
        - /path/to/directory
      state: directory
      mode: 0755
~~~
* Create a soft link:
~~~ yaml
    file:
      src: /existing/file
      dest: /file/to/create/as/a/link/to/existing/file  # Can use `path` instead of `dest`.
      state: link
      force: yes
~~~
* Copy a file from the Ansible system to the target system:
~~~ yaml
    copy:
      src: path/to/file  # This is relative to the `files` directory that's a sibling of the `tasks` directory we're in.
      dest: /path/to/file
      mode: 0640
      owner: postgresql
      group: postgresql
~~~
* Copy a file from one place to another on the target system:
~~~ yaml
    copy:
      src: /path/to/original/file_or_directory
      dest: /path/to/file/file_or_directory_to_create
      remote_src: TRUE
~~~
* Download a file from the Internet to the target system:
~~~ yaml
    get_url:
      url: http://exmaple.com/blah
      dest: /path/to/destination
~~~
* Add a line to a file:
~~~ yaml
      lineinfile:
        dest: /path/to/file
        line: 'key=value'
        regexp: '^#?key=' # Replace last occurrence that matches this regular expression.
        validate: 'visudo -cf %s' # Run this command; if it fails, don't overwrite the file.
~~~
* Delete a file:
~~~ yaml
    file:
      path: /path/to/file
      state: absent
~~~
* Clone a git repository:
~~~ yaml
    git:
      dest: /usr/local/share/cheatsheets
      repo: https://github.com/boochtek/cheatsheets.git
    become_user: booch
~~~


Services
--------

* Start and enable a service (you should almost always start and enable the service in a single task):
~~~ yaml
    service:
      name: httpd
      state: started  # Or `restarted` if you need it to restart if it was already running.
      enabled: true  # DON'T FORGET THIS, OR YOUR SERVICE MIGHT NOT RUN AFTER REBOOTING.
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
