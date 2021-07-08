FROM robsontenorio/laravel

LABEL maintainer="Robson Tenório"
LABEL site="http://github.com/robsontenorio"

ENV DEBIAN_FRONTEND=noninteractive 
ENV TERM xterm 
ENV npm_config_loglevel warn
ENV npm_config_unsafe_perm true
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV CHROME_VERSION 90.0.4430.212
ENV FIREFOX_VERSION 88.0.1
ENV CI=1
ENV CYPRESS_CACHE_FOLDER=/root/.cache/Cypress

RUN apt update && apt install -y \
    # Cypress dependencies
    libgtk2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb \
    # Extra dependencies
    fonts-liberation \ 
    libappindicator3-1 \ 
    xdg-utils \ 
    mplayer \ 
    apt-utils

# Chrome
RUN wget -O /usr/src/google-chrome-stable_current_amd64.deb "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" && \
    dpkg -i /usr/src/google-chrome-stable_current_amd64.deb ; \
    apt-get install -f -y && \
    rm -f /usr/src/google-chrome-stable_current_amd64.deb

# Firefox
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
    && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
    && rm /tmp/firefox.tar.bz2 \
    && ln -fs /opt/firefox/firefox /usr/bin/firefox

# Cypress & Utils
RUN npm -g install wait-on cypress