
FROM centos:centos6

RUN yum -y install wget yum-utils && \
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O epel-release-6-8.noarch.rpm && \
    rpm -Uvh epel-release-6-8.noarch.rpm && \
    rm epel-release-6-8.noarch.rpm && \

    # fish
    yum-config-manager --add-repo http://fishshell.com/files/linux/RedHat_RHEL-6/fish.release:2.repo && \

    # packages
    yum -y update && \
    yum groupinstall -y 'development tools' && \
    yum -y install git \
        fish \
        htop \
        gcc \
        pychart \
        postgresql-devel \
        byobu \
        bzr \
        openssh-server \
        vim \
        pwgen \
        xz-libs \
        zlib-devel \
        bzip2-devel \
        openssl-devel \
        xz-libs \
        ncurses-devel \
        curl \
        curl-devel \
        libxslt-devel \
        openldap-devel \
        tar \
        libjpeg-devel \
        wget \
        sqlite-devel \
        readline-devel \
        tk-devel \
        gdbm-devel \
        db4-devel \
        libffi-devel \
        libxslt \
        libxml2 \
        libxml2-devel \
        libjpeg-turbo-devel \
        openjpeg-devel \
        libtiff-devel \
        libpng \
        libXext \
        libz.so.1 \
        xorg-x11-fonts-Type1 \
        cabextract \
        nodejs \
        npm && \

    echo "Install additional fonts" && \
    rpm -ivh https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm && \

    echo "Install python 2.7" && \
    wget http://www.python.org/ftp/python/2.7.8/Python-2.7.8.tar.xz && \
    xz -d Python-2.7.8.tar.xz && \
    tar -xvf Python-2.7.8.tar && \
    cd Python-2.7.8 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall && \
    export PATH="/usr/local/bin:$PATH" && \
    cd .. && \
    wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz && \
    tar -xvf setuptools-1.4.2.tar.gz && \
    cd setuptools-1.4.2 && \
    python2.7 setup.py install && \
    cd .. && \
    curl https://bootstrap.pypa.io/get-pip.py | python2.7 - && \

    echo "Install python dependencies" && \
    pip2.7 install "babel>=1.0" \
        decorator \
        docutils \
        feedparser \
        gevent \
        Jinja2 \
        lxml \
        mako \
        mock \
        passlib \
        pillow \
        psutil \
        psycogreen \
        "psycopg2>=2.2" \
        pydot \
        "pyparsing<2" \
        pypdf \
        pyserial \
        python-dateutil \
        python-ldap \
        python-openid \
        pytz \
        "pyusb>=1.0.0b1" \
        pyyaml \
        qrcode \
        reportlab \
        requests \
        simplejson \
        unittest2 \
        vatnumber \
        vobject \
        werkzeug \
        xlwt \
        MarkupSafe \
        PyWebDAV \
        "distribute>=0.6.10" \
        "gdata>=2.0.11" \
        "supervisor>=3.0" \
        "virtualenv>=1.11.4" \
        pudb \
        flask \
        wsgiref \
        suds-jurko \
        ofxparse \
        jcconv \
        argparse \
        Python-Chart && \
    pip2.7 install http://download.gna.org/pychart/PyChart-1.39.tar.gz && \

    echo "install wkhtmltopdf" && \
    wget http://nicolas-van.github.io/variousfiles/wkhtmltox-linux-amd64_0.12.0-03c001d.tar.xz && \
    tar -Jxvf wkhtmltox*.tar.xz && \
    cp wkhtmltox/bin/wkhtmltopdf /usr/bin/wkhtmltopdf && \
    chmod 755 /usr/bin/wkhtmltopdf && \

    echo "install less" && \
    npm install -g less less-plugin-clean-css && \

    # generate password for root
    # (must do this or ssh will refuse to login)
    echo root:`pwgen -cnsN 1 12` | chpasswd && \

    # ssh service
    # (it's necessary to disable pam)
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    # (not really necessary but speeds up login)
    sed -i "s/\#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config && \
    sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/" /etc/ssh/sshd_config
    
ENV ODOO_VERSION 10.0
    
RUN adduser user && \
    echo user:`pwgen -cnsN 1 12` | chpasswd && \
    su user -c "mkdir -p /home/user/odoo" && \
    su user -c "git clone https://github.com/myerpengine/odoo.git /home/user/odoo/odoo -b $ODOO_VERSION" && \
    su user -c "git clone https://github.com/myerpengine/additionalodooaddons.git /home/user/odoo/other_addons -b $ODOO_VERSION" && \
    su user -c "/usr/local/bin/virtualenv --system-site-packages /home/user/virtualenv" && \
    mkdir /overrides
    
ADD supervisord.conf /etc/supervisord.conf
ADD entrypoint.sh /entrypoint.sh
ADD odoo_config.ini /home/user/odoo_config.ini
RUN chown user:user /home/user/odoo_config.ini
ADD launch_app.sh /home/user/launch_app.sh
RUN chown user:user /home/user/launch_app.sh

EXPOSE 22 8069 8072
VOLUME ["/home/user", "/tmp", "/var/tmp"]
CMD ["/entrypoint.sh", "supervisord"]
