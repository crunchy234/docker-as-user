FROM ubuntu:16.04
LABEL maintainer="Crunchy234"

# Update the apt packages in the container.
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    sudo \
    apt-utils

# Create directories for the container
RUN mkdir /home/working

# Set default UID and GID to create user with
ENV USERID 1001
ENV GROUPID 1001

RUN mkdir -p /home/developer && \
    echo "developer:x:${USERID}:${GROUPID}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${USERID}:" >> /etc/group && \
    chown ${USERID}:${GROUPID} -R /home/working && \
    cp /root/.bashrc /home/developer && \
    usermod -m -d /home/developer developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${USERID}:${GROUPID} -R /home/developer

WORKDIR /home/working
ENTRYPOINT bash -c "usermod -u $USERID developer &&  sudo groupmod -g $GROUPID developer" && \
    su developer && \
    bash
