#!/bin/bash
# script to automate the creation of chroot jail
# w/ minimal executables to run git

export CHROOT=/home/sarabjot_22bai1104/os_script/chroot

function copy_binary(){
    for i in $(ldd $*|grep -v dynamic|cut -d " " -f 3|sed 's/://'|sort|uniq)
      do
        cp --parents $i $CHROOT
      done

    # ARCH amd64
    if [ -f /lib64/ld-linux-x86-64.so.2 ]; then
       cp --parents /lib64/ld-linux-x86-64.so.2 $CHROOT
    fi

    # ARCH i386
    if [ -f  /lib/ld-linux.so.2 ]; then
       cp --parents /lib/ld-linux.so.2 $CHROOT
    fi
}

# setup directory layout
mkdir $CHROOT
mkdir -p $CHROOT/{dev,etc,home,tmp,proc,root,var}

# setup device
mknod $CHROOT/dev/null c 1 3
mknod $CHROOT/dev/zero c 1 5
mknod $CHROOT/dev/tty  c 5 0
mknod $CHROOT/dev/random c 1 8
mknod $CHROOT/dev/urandom c 1 9
chmod 0666 $CHROOT/dev/{null,tty,zero}
chown root.tty $CHROOT/dev/tty

# copy programs and libraries
copy_binary /bin/{bash,ls,cp,rm,cat,mkdir,ln,grep,cut,sed} /usr/bin/{vim,head,tail,which,id,find,xargs} `which git`

# copy git resource files
cp -r --parents /usr/share/git-core $CHROOT
# copy vim resource files
cp -r --parents /usr/share/vim $CHROOT
# copy basic system level files
cp --parents /etc/group $CHROOT
cp --parents /etc/passwd $CHROOT
cp --parents /etc/shadow $CHROOT
cp --parents /etc/nsswitch.conf $CHROOT
cp --parents /etc/resolv.conf $CHROOT
cp --parents /etc/hosts $CHROOT
cp -r --parents /usr/share/terminfo $CHROOT


# create symlinks
cd $CHROOT/usr/bin
ln -s vim vi

echo "chroot jail is created. type: chroot $CHROOT to access it"
