FROM ubuntu

RUN apt-get update

RUN apt-get install -y wget curl nano

RUN apt-get install -y ssh openssh-server \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && echo 'Port 2022' >> /etc/ssh/sshd_config \
 && mkdir /var/run/sshd 

RUN apt-get install -y nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node

RUN apt-get clean

RUN useradd -m -u 1000 -s /bin/bash pau \
 && echo 'pau:pau' | chpasswd \
 && chmod 777 \
   /etc/ssh/ssh_host_rsa_key \
   /etc/ssh/ssh_host_dsa_key \
   /etc/ssh/ssh_host_ecdsa_key \
   /etc/ssh/ssh_host_ed25519_key 

VOLUME ["/volume"]

EXPOSE 2022 8080 8443

USER 1000

RUN /usr/bin/ssh-keygen -A

CMD ["/usr/sbin/sshd", "-D"]
