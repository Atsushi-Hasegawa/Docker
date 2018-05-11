FROM centos:centos7

#RUN install
RUN yum check
RUN yum update -y
RUN yum install -y openssh-server openssh-clients openssh sudo passwd

#ssh_config変更
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
#パスワードを禁止する
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# 使わないにしてもここに公開鍵を登録しておかないとログインできない
RUN ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
#手元の鍵をコピーする
COPY id_rsa.pub /root/authorized_keys

EXPOSE 22
#ssh鍵の権限変更
RUN mkdir /root/.ssh && \
    mv /root/authorized_keys /root/.ssh/authorized_keys && \
    chmod 0700 /root/.ssh && \
    chmod 0600 /root/.ssh/authorized_keys
CMD ["/usr/sbin/sshd", "-D"]
