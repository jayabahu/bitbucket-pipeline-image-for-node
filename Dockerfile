FROM ubuntu:16.04
MAINTAINER Vimukthi Jayabahu

# Install base dependencies
RUN apt-get update \
    && apt-get install -y \
    software-properties-common \
    build-essential \
    wget \
    xvfb \
    curl \
    git \
    mercurial \
    maven \
    openjdk-8-jdk \
    ant \
    ssh-client \
    unzip \
    iputils-ping \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Install nvm with node and npm
ENV NODE_VERSION=10.20.0 \
    NVM_DIR=/root/.nvm \
    NVM_VERSION=0.35.1

RUN curl https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Set node path
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Default to UTF-8 file.encoding
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8

# Xvfb provide an in-memory X-session for tests that require a GUI
ENV DISPLAY=:99

# Set the path.
ENV PATH=$NVM_DIR:$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Create dirs and users
RUN mkdir -p /opt/build \
    && sed -i '/[ -z \"PS1\" ] && return/a\\ncase $- in\n*i*) ;;\n*) return;;\nesac' /root/.bashrc \
    && useradd --create-home --shell /bin/bash --uid 1000 pipelines

RUN npm install -g yarn

WORKDIR /opt/build
ENTRYPOINT /bin/bash