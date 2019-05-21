FROM node:8.15-stretch

VOLUME /dist

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y git python \
    gcc-multilib g++-multilib \
    build-essential libssl-dev rpm \
    libsecret-1-dev software-properties-common apt-transport-https \
    libudev-dev libusb-1.0-0-dev && \
    rm -rf /var/lib/apt/lists/*

# Install appimagetool (needed for Linux build)
RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod a+x appimagetool-x86_64.AppImage
