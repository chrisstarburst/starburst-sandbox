FROM rockylinux:9.1
RUN dnf install -y jq python3
ADD ./docker/starburst/biac/setup-biac-roles.sh /tmp/setup-biac-roles.sh
RUN chmod +x /tmp/setup-biac-roles.sh
RUN /bin/bash -c ls /tmp/setup-biac-roles.sh
