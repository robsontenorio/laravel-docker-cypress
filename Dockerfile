FROM robsontenorio/laravel

LABEL maintainer="Robson Tenório"
LABEL site="http://github.com/robsontenorio"

RUN apt update && apt install -y \
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
    xvfb

RUN npm -g install wait-on --unsafe-perm