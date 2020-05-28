FROM ubuntu:focal

LABEL version="1.0"
LABEL maintainer="Guillaume Mazoyer"
LABEL description="Ubuntu 20.04 container for Ansible role testing"

ENV DEBIAN_FRONTEND noninteractive

# Install requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               build-essential libffi-dev libssl-dev \
               python3-pip python3-dev python3-setuptools python3-wheel \
               sudo systemd \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc && rm -rf /usr/share/man \
    && apt-get clean

# Install Ansible
RUN pip3 install cryptography ansible

# Ansible inventory file
RUN mkdir -p /etc/ansible/roles \
    && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Make sure systemd does not mess with us
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
