FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl openssl \
    && curl https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add - \
    && echo "deb http://dl.bintray.com/jasonbeverage/pelicanmapping xenial main" | tee -a /etc/apt/sources.list \
    && apt-get update -qq \
    && apt-get install -y python-software-properties software-properties-common \
    && add-apt-repository ppa:ubuntugis/ppa --yes \
    && apt-get update -qq \
    && apt-get install -y \
    openscenegraph=3.6.3 \
    gdal-bin \
    libgdal-dev \
    libgeos-dev \
    libsqlite3-dev \
    protobuf-compiler \
    libprotobuf-dev \
    libpoco-dev \
    git \
    unzip \
    nano \
    wget

RUN curl https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4-Linux-x86_64.tar.gz -L -o cmake-3.18.4-Linux-x86_64.tar.gz \
    && tar -xvf cmake-3.18.4-Linux-x86_64.tar.gz \
    && export PATH=$PATH:$PWD/cmake-3.18.4-Linux-x86_64/bin

ENV PATH="/cmake-3.18.4-Linux-x86_64/bin:${PATH}"
ENV OSGEARTH_CACHE_PATH="/osgearth_cache"

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN git clone https://github.com/gwaldron/osgearth.git
RUN cd osgearth && cmake -DCMAKE_BUILD_TYPE=Release . && make -j8 && make install && ldconfig

ADD tile.sh /bin/tile.sh
RUN chmod a+x /bin/tile.sh