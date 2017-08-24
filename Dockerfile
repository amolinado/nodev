FROM ubuntu
ENV APP_UID=1000
ENV APP_USER=app
ENV APP_PASS=app

RUN apt-get update
RUN apt-get install -y wget curl nano telnet sudo

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ssh openssh-server \
 && mkdir /var/run/sshd \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 

RUN apt-get install -y nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node
RUN apt-get install -y git
RUN apt-get clean

RUN useradd -m -u $APP_UID -s /bin/bash $APP_USER \
 && echo "$APP_USER:$APP_PASS" | chpasswd \
 && adduser $APP_USER sudo \
 && chmod 777 \
   /etc/ssh/ssh_host_rsa_key \
   /etc/ssh/ssh_host_dsa_key \
   /etc/ssh/ssh_host_ecdsa_key \
   /etc/ssh/ssh_host_ed25519_key 

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
CMD ["app.js", "-p", "3000"]
