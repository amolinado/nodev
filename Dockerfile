FROM ubuntu
ENV APP_UID=999666
ENV APP_USER=app
ENV APP_PASS=app

RUN apt-get update \
 && apt-get install -y wget curl nano telnet sudo

RUN apt-get install -y nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node

RUN apt-get install -y git

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ssh openssh-server \
 && echo "Port 2022" >> /etc/ssh/sshd_config \
 && chmod 775 /var/run

RUN apt-get clean

RUN useradd -m -u $APP_UID -g 0 -s /bin/bash $APP_USER \
 && echo "$APP_USER:$APP_PASS" | chpasswd \
 && adduser $APP_USER sudo

RUN chgrp -R 0     /etc /home \
 && chmod -R g+rwX /etc /home \ 
 && chmod 664 /etc/passwd /etc/group

USER $APP_USER
WORKDIR /home/$APP_USER

RUN git clone https://github.com/krishnasrinivas/wetty \
 && cd wetty \
 && npm install

WORKDIR /home/$APP_USER/wetty

VOLUME ["/volume"]
EXPOSE 2022 3000

CMD sed -ri "s/:x:$APP_UID:/:x:`id -u`:/g" /etc/passwd \
 && mkdir -p /home/$APP_USER/.ssh \
 && touch /home/$APP_USER/.ssh/authorized_keys \
 && chmod 700 /home/$APP_USER/.ssh \
 && chmod 600 /home/$APP_USER/.ssh/authorized_keys \
 && ssh-keygen -A \
 && exec /usr/sbin/sshd -D

#ENTRYPOINT ["node"]
#CMD ["app.js", "-p", "3000", "--sshport", "2022", "--sshuser", "app"]

#node app.js -p 3000 --sshport 2022 --sshuser app
#echo "ocuser:x:`id -u`:0::/home/app:/bin/bash" >> /etc/passwd
