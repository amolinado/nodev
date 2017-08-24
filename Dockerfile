FROM ubuntu
ENV APP_UID=1000
ENV APP_USER=app
ENV APP_PASS=app

RUN apt-get update \
 && apt-get -y install libnss-wrapper gettext

RUN apt-get install -y wget curl nano telnet sudo

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ssh openssh-server \
 && mkdir /var/run/sshd \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && echo "Port 2022" >> /etc/ssh/sshd_config \
 && /etc/init.d/ssh start

RUN apt-get install -y nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node

RUN apt-get install -y git

RUN apt-get clean

RUN useradd -m -u $APP_UID -s /bin/bash $APP_USER \
 && echo "$APP_USER:$APP_PASS" | chpasswd \
 && adduser $APP_USER sudo

RUN chgrp -R 0 /etc \
  && chmod -R g+rwX /etc /home/$APP_USER

USER $APP_USER
WORKDIR /home/$APP_USER

RUN /usr/bin/ssh-keygen -A

RUN git clone https://github.com/krishnasrinivas/wetty \
 && cd wetty \
 && npm install

WORKDIR /home/$APP_USER/wetty

VOLUME ["/volume"]
EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000", "--sshport", "2022", "--sshuser", "app"]

#CMD ["/usr/sbin/sshd", "-D"]

