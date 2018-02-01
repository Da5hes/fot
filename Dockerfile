# Base OS - Ubuntu 16.04
FROM ubuntu:16.04

# Update APT
RUN apt-get -y update && apt-get -y upgrade

# Prepare sudo user
RUN apt-get -y install sudo
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
USER docker

# Define Enviornment Variables
ENV HOME=/home/docker
ENV GOROOT=/usr/local/lib/go
ENV GOPATH=$HOME/gocode
ENV PATH=/usr/local/lib/go/bin:$GOPATH/bin:$HOME/.cargo/bin:/usr/local/lib/fot/bin:$PATH

# Copy local files into docker image: fot-base-img,
# target path will be : /home/docker/fot/
COPY . $HOME/fot/
WORKDIR $HOME/fot

# Set up Environment
RUN ./install.sh

CMD []



