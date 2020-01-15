FROM node:10.18-stretch

# Build and install OpenSSL 1.0.2k
# Based on https://github.com/realm/realm-js/blob/master/Dockerfile
RUN curl -SL https://www.openssl.org/source/openssl-1.0.2k.tar.gz | tar -zxC / && \
    cd openssl-1.0.2k && \
    ./Configure -DPIC -fPIC -fvisibility=hidden -fvisibility-inlines-hidden \
    no-zlib-dynamic no-dso linux-x86_64 --prefix=/usr && make && make install_sw && \
    cd .. && rm -rf openssl-1.0.2k.tar.gz

# Use our version of OpenSSL instead of the Debian-provided one
ENV PATH "/usr/local/ssl:$PATH"

WORKDIR /app
