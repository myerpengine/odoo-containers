#! /bin/sh
echo "Setting user's uid to $USER_UID"
usermod -u $USER_UID user

if test ! -e /home/user/virtualenv; then
    su user -c "/usr/local/bin/virtualenv --system-site-packages /home/user/virtualenv"
fi

exec supervisord
