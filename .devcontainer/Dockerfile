#
# Dockerfile for a general purpose AWS development environment on Ubuntu.
#
# Why Ubuntu when it is so heavyweight? Well, Alpine's libs are compiled against
# some unorthodox alternative to libc and so whilst we can get CDk to run, we can't
# install AWS CLI v2 and that's not acceptable. One might think that perhaps 
# Amazon Linux might be a good alternative but I haven't had much luck running 
# this as a dev container in VS Code.
#

# Set Ubuntu version. Default to `latest`. 
#
# Override default by supplying `--build-arg UBUNTU_VERSION=<arg value>`
# to `docker build`.
#ARG UBUNTU_VERSION="latest"

# Specify base image.
# FROM ubuntu:${UBUNTU_VERSION}
FROM mcr.microsoft.com/devcontainers/java:17
# Set the locale. Default to `en_AU.UTF-8`. 
#
# Override default by supplying `--build-arg LOCALE=<arg value>`
# to `docker build`.
ARG LOCALE="en_US.UTF-8"

# Set the username and user/group IDs that we want containers to run as.
#
# Override defaults by:
#   * Supplying `--build-arg <arg name>=<arg value>` if building the image
#     from the command line, or
#   * Settting the value in ARGS in `devcontainer.json` if building the image
#     from VSCode
#
# It is best practice for containers to run non-root, so here we set the
# username and user/group IDs for the user that will run in containers
# built from this image. It is a convenience that we use USER_UID 1000
# because this typically corresponds with the USER_UID in the container 
# host. Thus, when we mount volumes, the container user is able to 
# interact with the files from the host without having to change their 
# permissions.
ARG USER_NAME="devcontainer"
ARG USER_UID="1001"
ARG USER_GID="1001"

# Update Ubuntu and install common tools/dependencies. Add to the list 
# as required and maintain in alphabetical order for maintenance. 
#
# We install `sudo` so we can switch to a non-root user later.
#
# No need to run `apt-get clean -y` because this is automatically done by 
# Ubuntu. Removing `/var/lib/apt/lists/*` keeps the image layer size down.
RUN set -x \
  && deps=" \
  ca-certificates \
  curl \
  git \
  jq \
  less \
  locales \
  openssh-client \
  sudo \
  unzip \
  # vim \
  wget \
  nodejs \
  npm \
  # python3-setuptools \
  # python3-pip \
  # python3.12-venv \
  # iproute2 \
  zsh \
  git \
  curl \
  mc \
  dos2unix \
  fzf \
  dialog \
  fd-find\
  w3m \
  html2text \
  " \
  && apt-get update && apt-get install -y ${deps} --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen ${LOCALE} 

# Install JDK and Maven for Spring Boot development
# RUN set -x \
#   && apt-get update \
#   && apt-get install -y --no-install-recommends \
#      openjdk-17-jdk \
#      maven \
#   && rm -rf /var/lib/apt/lists/* \
#   && ln -s /usr/share/maven/bin/mvn /usr/local/bin/mvn

# Set JAVA_HOME environment variable and add Spring Boot related paths
# ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
#     PATH=$PATH:/usr/lib/jvm/java-17-openjdk-amd64/bin \
#     SPRING_HOME=/opt/spring-boot

# Create the non-root user and enable sudo for them.
RUN groupadd --gid ${USER_GID} ${USER_NAME} \
  && useradd --create-home --uid ${USER_UID} --gid ${USER_GID} -s /bin/bash ${USER_NAME} \
  && echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers \
  && chmod 0440 /etc/sudoers

# Switch to non-root user.
USER ${USER_NAME}

# Switch working directory to non-root user home.
WORKDIR /home/${USER_NAME}

# Install Node.js.
RUN curl -k -sSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
  && deps="nodejs" \
  && sudo apt-get update && sudo apt-get install -y ${deps} --no-install-recommends \
  && sudo rm -rf /var/lib/apt/lists/* 

# Install Spring Boot CLI directly
# RUN sudo apt-get update && \
#     sudo apt-get install -y maven && \
#     sudo rm -rf /var/lib/apt/lists/* && \
#     mvn --version

# Install AWS CLI v2 and enable AWS CLI auto-completion.
# using https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip for arm chipset
# RUN curl -k "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#   && unzip awscliv2.zip \
#   && sudo ./aws/install \
#   && rm ./awscliv2.zip \
#   && rm -rf ./aws \
#   && echo "" >> ~/.bashrc \
#   && echo "# Enables AWS CLI auto-completion." >> ~/.bashrc \
#   && echo "export PATH=/usr/local/bin:$PATH" >> ~/.bashrc \
#   && echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc


# Add Python utilities to PATH
RUN echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc

# Allow for caching python modules
#VOLUME [ "/usr/lib/python3.8/site-packages/" ]

#VOLUME [ "/${USER_NAME}/.aws" ]

# You might enable these if using the dev container outside of VS Code. When using VS Code 
# dev containers a volume is automatically created that exposes the project directory as 
# `/workspaces/<project name>`.
# VOLUME [ "/opt/app" ]
# WORKDIR /opt/app