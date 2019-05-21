FROM ubuntu:18.10

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install  -y \
    automake \
    build-essential \
    wget \
    cmake \
    unzip \
    zip \
    curl \
    doxygen \
    libssl-dev \
    openssl \
    xxd \
    ccache \
    libtinfo5 \
    git \
    graphviz \
    python3-dev \
    python3-numpy \
    python-pyparsing\
    python3-pyparsing\
    openjdk-8-jdk \
    python \
    gcc \
    g++ \
    libc6:i386 \
    gcc-multilib \
    g++-multilib \
    clang-format \
    cppcheck \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME /opt/android-sdk-linux

# Below is taken from https://github.com/bitrise-docker/android
# see license at https://github.com/bitrise-docker/android/blob/master/LICENSE

# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME

RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm android-sdk-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# ------------------------------------------------------
# --- Install Android SDKs and other build packages

# Other tools and resources of Android SDK
#  you should only install the packages you need!
# To get a full list of available options you can use:
#  sdkmanager --list

# Accept licenses before installing components, no need to echo y for each component
# License is valid for all the standard components in versions installed from this file
# Non-standard components: MIPS system images, preview versions, GDK (Google Glass) and Android Google TV require separate licenses, not accepted there
RUN yes | sdkmanager --licenses

# Platform tools
RUN sdkmanager "emulator" "tools" "platform-tools"

# SDKs
# Please keep these in descending order!
# The `yes` is for accepting all non-standard tool licenses.

# Please keep all sections in descending order!
RUN yes | sdkmanager \
    "platforms;android-27" \
    "platforms;android-25" \
    "platforms;android-24" \
    "platforms;android-23" \
    "platforms;android-19" \
    "build-tools;27.0.3" \
    "build-tools;27.0.2" \
    "system-images;android-26;google_apis;x86_64" \
    "system-images;android-19;default;armeabi-v7a" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" \
    "add-ons;addon-google_apis-google-24"

# ------------------------------------------------------
# --- Install Gradle from PPA

# Gradle PPA
RUN apt-get update \
 && apt-get -y install gradle \
 && gradle -v

# ------------------------------------------------------
# --- Install Maven 3 from PPA

RUN apt-get purge maven maven2 \
 && apt-get update \
 && apt-get -y install maven \
 && mvn --version

# ------------------------------------------------------
# ------------------------------------------------------
# -----------------ANDROID NDK -------------------------
# ------------------------------------------------------
# ------------------------------------------------------
ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK_VERSION r17c

RUN mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && \
    wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
    cd ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp

ENV PATH ${PATH}:${ANDROID_NDK_HOME}


# ------------------------------------------------------
# ------------------------------------------------------
# -------------------- BAZEL ---------------------------
# ------------------------------------------------------
# ------------------------------------------------------
ENV BAZEL_VERSION 0.25.2
RUN wget -q https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh -O bazel_installer.sh \
      && chmod a+x ./bazel_installer.sh && ./bazel_installer.sh --prefix=/usr \
      && rm bazel_installer.sh
COPY .bazelrc /etc/bazel.bazelrc
RUN wget -q https://github.com/bazelbuild/buildtools/releases/download/0.25.1/buildifier -O /usr/local/bin/buildifier \
    && chmod +x /usr/local/bin/buildifier
