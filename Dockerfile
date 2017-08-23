FROM ubuntu

RUN apt-get update \
 && apt-get install -y wget curl ssh openssh-server nano\
 && apt-get clean \
 && mkdir /var/run/sshd 

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && sed -ri 's/Port 22/Port 2022/g' /etc/ssh/sshd_config

RUN apt-get -y install nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node

RUN /usr/bin/ssh-keygen -A \
 && /etc/init.d/ssh restart

RUN useradd -m -u 1000 -s /bin/bash pau \
 && echo 'pau:pau' | chpasswd

VOLUME ["/volume"]

EXPOSE 2022 8080 8443

USER 1000
