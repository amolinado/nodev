FROM ubuntu

RUN apt-get update

RUN apt-get install -y wget curl nano telnet sudo

RUN apt-get install -y ssh openssh-server \
 && mkdir /var/run/sshd \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
# && echo 'Port 2022' >> /etc/ssh/sshd_config

RUN apt-get install -y nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node
 
RUN apt-get install -y nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node

RUN apt-get install -y git

RUN apt-get clean

RUN useradd -m -u 1000 -s /bin/bash app \
 && echo 'app:app' | chpasswd \
 && adduser app sudo \
 && chmod 777 \
   /etc/ssh/ssh_host_rsa_key \
   /etc/ssh/ssh_host_dsa_key \
   /etc/ssh/ssh_host_ecdsa_key \
   /etc/ssh/ssh_host_ed25519_key 

USER app
WORKDIR /home/app

RUN /usr/bin/ssh-keygen -A

RUN git clone https://github.com/krishnasrinivas/wetty \
 && cd wetty \
 && npm install

VOLUME ["/volume"]
EXPOSE 3000
ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]

#CMD ["/usr/sbin/sshd", "-D"]
