FROM ubuntu:bionic

RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get -y install build-essential patch git \
    libffi-dev libgdbm-dev libssl-dev libyaml-dev \
    procps zlib1g-dev libjemalloc-dev libgmp-dev libsasl2-dev libreadline-dev \
    build-essential libbz2-dev libncurses-dev libxml2-dev libxslt-dev xz-utils \
    libtool curl systemtap-sdt-dev

ENV RUBY_VERSION 2.6.9
RUN \
    curl -sSLo /tmp/ruby.tar.xz https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-${RUBY_VERSION}.tar.xz && \
    tar -C /tmp -xJf /tmp/ruby.tar.xz && \
    cd /tmp/ruby-${RUBY_VERSION} && \
    LDFLAGS="-Wl,--no-as-needed" ./configure --prefix=/usr/local --sysconfdir=/etc \
        --localstatedir=/var --with-jemalloc --enable-dtrace --disable-install-doc \
        --enable-shared && \
    sed -i 's/ENABLE_PATH_CHECK 1/ENABLE_PATH_CHECK 0/' file.c && \
    make -j 8 && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/ruby-${RUBY_VERSION} /tmp/ruby.tar.xz

COPY 0001-ICU-21353.patch /tmp/

RUN \
    export ICU_VERSION=60.3 && \
    curl -sS -o /tmp/icu.tar.gz -L "https://github.com/unicode-org/icu/releases/download/release-$(echo "$ICU_VERSION" | sed "s/\./-/g")/icu4c-$(echo "$ICU_VERSION" | sed "s/\./_/g")-src.tgz" && \
    tar -zxf /tmp/icu.tar.gz -C /tmp && \
    cd /tmp/icu/source && \
    ./configure --prefix="/opt/icu-${ICU_VERSION}" --enable-rpath && \
    make -j 8 && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/icu.tar.gz && \
    rm -rf /tmp/icu

RUN \
    export ICU_VERSION=70.1 && \
    curl -sS -o /tmp/icu.tar.gz -L "https://github.com/unicode-org/icu/releases/download/release-$(echo "$ICU_VERSION" | sed "s/\./-/g")/icu4c-$(echo "$ICU_VERSION" | sed "s/\./_/g")-src.tgz" && \
    tar -zxf /tmp/icu.tar.gz -C /tmp && \
    cd /tmp/icu/source && \
    ./configure --prefix="/opt/icu-${ICU_VERSION}" --enable-rpath && \
    make -j 8 && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/icu.tar.gz && \
    rm -rf /tmp/icu

RUN \
    export ICU_VERSION=70.1 && \
    curl -sS -o /tmp/icu.tar.gz -L "https://github.com/unicode-org/icu/releases/download/release-$(echo "$ICU_VERSION" | sed "s/\./-/g")/icu4c-$(echo "$ICU_VERSION" | sed "s/\./_/g")-src.tgz" && \
    tar -zxf /tmp/icu.tar.gz -C /tmp && \
    cd /tmp/icu && \
    patch -Np2 < /tmp/0001-ICU-21353.patch && \
    cd /tmp/icu/source && \
    ./configure --prefix="/opt/icu-${ICU_VERSION}-patched" --enable-rpath && \
    make -j 8 && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/icu.tar.gz && \
    rm -rf /tmp/icu


WORKDIR /app
ADD Gemfile* /app/
RUN \
    gem install bundler && \
    bundle install
ADD . /app/
