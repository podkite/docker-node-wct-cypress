FROM cypress/base:8.15.1

# install ssh-agent
RUN which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )

# npm global deps
RUN npm install -g polymer-cli --unsafe-perm=true
RUN npm install -g bower --unsafe-perm=true
RUN npm install -g firebase-tools
RUN npm install -g eslint
RUN npm install cypress

# Cypress
RUN node_modules/cypress/bin/cypress install

# # WCT
# ## install Java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | \
  tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | \
  tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get -qq update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install -y -qq oracle-java8-installer
RUN apt-get install -y -qq oracle-java8-set-default

## install chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list

### Update packages
RUN apt-get update -yqqq

### Install Chrome browser
RUN apt-get install -qq -y google-chrome-stable --allow-unauthenticated

### Install Virtual Display emulator
RUN apt-get install -qq -y xvfb

RUN whereis google-chrome
RUN whereis chrome

### try to fool google-chrome to run without sandbox
RUN mv /usr/bin/google-chrome /usr/bin/google-chrome-orig \
    && echo '#!/bin/bash' > /usr/bin/google-chrome \
    && echo '/usr/bin/google-chrome-orig --no-sandbox --disable-setuid-sandbox --allow-sandbox-debugging "$@"' >> /usr/bin/google-chrome  \
    && chmod +x /usr/bin/google-chrome

## install firefox
RUN apt-get update -y
RUN apt-get install firefox-esr -y
