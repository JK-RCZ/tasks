#!/usr/bin/env bash

echo -e "     Warning! You should run this script from its root folder!\n     You should run this script with SUDO privilages.\n     If you do, type 'y', if don't type 'e' to EXIT!"
read value;
            if [ $value == e ]
            then
            exit 0
            else
            echo "----------------------- Let's begin! -----------------------"
            zypper install -y meson
            zypper install -y libeditorconfig-devel
            zypper install -y libgee-0_8-2
            zypper install -y libgit2-glib-devel
            zypper install -y libgtksourceview-4-0
            zypper install -y libgtkspell3-3-0
            zypper install -y libgranite5
            zypper install -y libhandy-1-0
            zypper install -y libpeas-devel
            zypper install -y libsoup2-devel
            zypper install -y libvala-0_54-devel
            zypper install -y libvterm-devel
            meson build --prefix=/usr
            cd build
            ninja test
            ninja install
            echo "Done! Now you can find Code app in your Apps!"
            exit 0
            fi





#zypper install -y meson
#zypper install -y libeditorconfig-dev
