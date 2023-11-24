Commands to Create a Chroot Environment in Your Virtual Machine

To establish a chroot environment within your virtual machine, use the following commands:

bash
chroot /path/to/new/root command
# OR
chroot /path/to/new/root /path/to/server
# OR
chroot [options] /path/to/new/root /path/to/server


bash
$ mkdir jailed
$ cd jailed
$ mkdir -p bin lib64/x86_64-linux-gnu lib/x86_64-linux-gnu


Before proceeding, if you've aliased ls or bash, unalias them:

bash
$ unalias ls
$ unalias bash
$ cp $(which ls) ./bin/
$ cp $(which bash) ./bin/


Then, examine the dependencies of bash and ls:

bash
$ ldd $(which bash)
$ ldd$(which ls)

After analysis, copy the necessary libraries to the chroot environment:

bash
$ cp /lib/x86_64-linux-gnu/libtinfo.so.5 lib/x86_64-linux-gnu/
$ cp /lib/x86_64-linux-gnu/libdl.so.2 lib/x86_64-linux-gnu/
$ cp /lib/x86_64-linux-gnu/libc.so.6 lib/x86_64-linux-gnu/
$ cp /lib64/ld-linux-x86-64.so.2 lib64/
# Repeat for other required libraries

Finally, enter the chroot environment using:
bash
$ sudo chroot jailed /bin/bash

An interesting note is that when running $ ps aux, you'll notice only one process present. For example:
bash
root 24958 … 03:21 0:00 /usr/bin/sudo -E chroot jailed/ /bin/bash

This setup isolates the environment effectively for specific operations within the chrooted directory.
