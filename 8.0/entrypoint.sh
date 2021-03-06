#! /bin/sh

if [ ! -f /inited ]; then

    if [ "$USER_UID" != "" ]; then
        echo "Setting user's uid to $USER_UID"
        usermod -u $USER_UID user
        chown -R user:user /home/user
    fi
    
    if [ "$PUBLIC_AUTH_KEY" != "" ]; then
        echo "Adding public key to authorized keys"
        mkdir -p /root/.ssh
        echo $PUBLIC_AUTH_KEY >> /root/.ssh/authorized_keys2
    fi
    
    echo "Resetting password of root"
    echo root:`pwgen -cnsN 1 12` | chpasswd
    
    echo "Resetting password of user"
    echo user:`pwgen -cnsN 1 12` | chpasswd
    
    su user -c "cp -r /overrides/* /home/user/"
    
    touch /inited
fi

# for legacy purpose
if test ! -e /home/user/virtualenv; then
    su user -c "/usr/local/bin/virtualenv --system-site-packages /home/user/virtualenv"
fi

exec "$@"
