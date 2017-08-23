FROM ubuntu

RUN apt-get update \
 && apt-get install -y wget curl ssh openssh-server nano\
 && apt-get clean \
 && mkdir /var/run/sshd 

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && echo 'Port 2022' >> /etc/ssh/sshd_config \
 && /etc/init.d/ssh start

RUN apt-get -y install nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node
RUN useradd -m -u 1000 -s /bin/bash pau \
 && echo 'pau:pau' | chpasswd

VOLUME ["/volume"]

EXPOSE 2022 8080 8443

USER 1000

RUN /usr/bin/ssh-keygen -A

