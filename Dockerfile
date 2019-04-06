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


# Install wine (needed for Windows build)
RUN dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    apt-add-repository https://dl.winehq.org/wine-builds/debian/ && \
    apt-get update && \
    apt-get install --install-recommends -y winehq-stable && \
    rm -rf /var/lib/apt/lists/*

# Install appimagetool (needed for Linux build)
RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod a+x appimagetool-x86_64.AppImage
