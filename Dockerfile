# Base OS - Ubuntu 16.04
FROM ubuntu:16.04

# Update APT
RUN apt-get -y update

# Prepare sudo user
RUN apt-get -y install sudo
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
USER docker

# Define Enviornment Variables
# Build
ENV HOME=/home/docker
ENV GOROOT=/usr/lib/go-1.9
ENV GOPATH=$HOME/gocode
ENV PATH=$GOROOT/bin:$GOPATH/bin:$HOME/.cargo/bin:/usr/local/lib/fot/bin:$PATH

# Fuzz
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server

# Copy local files into docker image: fot-base-img,
# target path will be : /home/docker/fot/
COPY . $HOME/fot/
WORKDIR $HOME/fot

CMD []