FROM node:10.21-stretch

VOLUME /dist

# Install dependencies
RUN apt-get update && apt-get install -y git python \
    gcc-multilib g++-multilib \
    build-essential libssl-dev rpm \
    libsecret-1-dev software-properties-common apt-transport-https \
    libudev-dev libusb-1.0-0-dev && \
    rm -rf /var/lib/apt/lists/*

# Build and install OpenSSL 1.0.2k
# Based on https://github.com/realm/realm-js/blob/master/Dockerfile
RUN curl -SL https://www.openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz | tar -zxC / && \
    cd openssl-1.0.2k && \
    ./Configure -DPIC -fPIC -fvisibility=hidden -fvisibility-inlines-hidden \
    no-zlib-dynamic no-dso linux-x86_64 --prefix=/usr && make && make install_sw && \
    cd .. && rm -rf openssl-1.0.2k

# Use our version of OpenSSL instead of the Debian-provided one
ENV PATH "/usr/local/ssl:$PATH"

# Install appimagetool (needed for Linux build)
RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod a+x appimagetool-x86_64.AppImage

WORKDIR /app
