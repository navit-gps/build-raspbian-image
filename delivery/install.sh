#!/bin/sh

machine=`uname -m`
if [ "${machine}" != "armv7l" ]; then
  echo "This script will be executed at mounted raspbian enviroment (armv7l). Current environment is ${machine}."
  exit 1
fi

echo "Please check environment variables etc, this script can be executed ONLY within RPI environment!"
echo "When tasks done, type \"exit\" to return"
echo ""

apt-get install -y subversion imagemagick libdbus-1-dev libdbus-glib-1-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libimlib2-dev librsvg2-bin libspeechd-dev libxml2-dev ttf-liberation libgtk2.0-dev
apt-get install -y gcc g++ cmake make zlib1g-dev libpng12-dev librsvg2-bin
apt-get install -y libgps-dev
svn co  svn://svn.code.sf.net/p/navit/code/trunk/navit/ navit
mkdir navit-build
cd navit-build
cmake ~navit -DFREETYPE_INCLUDE_DIRS=/usr/include/freetype2/ && make && make install
echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
useradd navit
mkdir /home/navit
chown navit:users /home/navit
cat > /home/navit/.xinitrc << EOF
navit &
exec fluxbox
EOF
sed -i -e 's/type="internal" enabled="yes"/type="internal" fullscreen="1" enabled="yes"/' /usr/local/share/navit/navit.xml
apt-get install slim
sed -i -e 's/simone/navit/g' /etc/slim.conf
sed -i -e 's/auto_login          no/auto_login          yes/' /etc/slim.conf
sed -i -e 's@#login_cmd           exec /bin/sh - ~/.xinitrc %session@login_cmd           exec /bin/sh - ~/.xinitrc %session@g' /etc/slim.conf
sed -i -e 's@login_cmd           exec /bin/bash -login /etc/X11/Xsession %session@#login_cmd           exec /bin/bash -login /etc/X11/Xsession %session' /etc/slim.conf
