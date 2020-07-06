FROM python:3.7.8-slim

MAINTAINER Varun Bal <varun.bal.work@gmail.com>

ARG opencv_version=4.3.0
ENV DEBIAN_FRONTEND noninteractive
ENV WORK_DIR "/home"

WORKDIR $WORK_DIR

RUN apt-get update \
    && apt-get install -y build-essential

RUN apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

RUN apt-get install -y python3.7-dev python3.7-numpy

RUN git clone https://github.com/opencv/opencv.git \
    && cd opencv \
    && git checkout $opencv_version\
    && mkdir build \
    && cd build \
    && cmake \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D PYTHON3_EXECUTABLE=/usr/local/bin/python3 \
    -D PYTHON_INCLUDE_DIR=/usr/include/python3.7/ \
    -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.7m/ \
    -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.7m.so \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ \
    .. \
    && make install/strip \
    && cd $WORK_DIR \
    && rm -rf opencv

WORKDIR $WORK_DIR

RUN pip install numpy jupyter

RUN apt-get install -y wget \
    && wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" \
    && chmod u+x Miniconda3-latest-Linux-x86_64.sh \
    && ./Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local -u \
    && rm Miniconda3-latest-Linux-x86_64.sh \
    && conda install -y xeus-cling -c conda-forge

CMD ["jupyter","notebook","--ip","0.0.0.0","--allow-root","--no-browser"]
