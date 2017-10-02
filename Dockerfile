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
ENV USERID 1000
ENV GROUPID 1000

RUN export uid=$USERID gid=$GROUPID && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/working && \
    cp /root/.bashrc /home/developer && \
    usermod -m -d /home/developer developer && \
    chown ${uid}:${gid} -R /home/developer

WORKDIR /home/working
ENTRYPOINT usermod -u $USERID developer && \
    groupmod -g $GROUPID developer && \
    su developer && \
    bash
