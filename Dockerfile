FROM alpine:edge

RUN apk add --no-cache python3-dev py3-pip py3-wheel git openssh-client \
    && apk add --no-cache py3-numpy-dev \
    && pip install --no-cache-dir scikit-build \
    # pip install cmake is just a fancy way of installing cmake,
    # with --no-build-isolation we can just apk add cmake:
    # https://cliutils.gitlab.io/modern-cmake/chapters/intro/installing.html
    # https://cmake-python-distributions.readthedocs.io/en/latest/installation.html#install-package-with-pip
    && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --virtual .build-deps blas-dev cmake eigen-dev ffmpeg-dev freetype-dev glew-dev gstreamer-dev harfbuzz-dev hdf5-dev lapack-dev libdc1394-dev libgphoto2-dev libtbb-dev mesa-dev openexr-dev openjpeg-dev openjpeg-tools qt5-qtbase-dev vtk-dev ninja make g++ openssl-dev libpng-dev \
    # pip install opencv-python says GStreamer: NO despite having gstreamer-dev installed
    # gstreamer-dev should also install glib-dev yet ocv_check_modules(GSTREAMER_base): can't find library 'glib-2.0'.
    # ocv_check_modules(GSTREAMER_base): can't find library 'gobject-2.0'.
    # ocv_check_modules(GSTREAMER_base): can't find library 'gstbase-1.0'.
    # ocv_check_modules(DC1394_2): can't find library 'dc1394'. despite apk add libdc1394-dev
    # ocv_check_modules(FFMPEG_libavresample): can't find library 'avresample'.
    # ocv_check_modules(FFMPEG): can't find library 'swscale'.
    # ocv_check_modules(FFMPEG): can't find library 'avutil'.
    # ocv_check_modules(FFMPEG): can't find library 'avformat'.
    # ocv_check_modules(FFMPEG): can't find library 'avcodec'.
    # ocv_check_modules(GTHREAD): can't find library 'intl'.
    # apk add musl-libintl results in musl-libintl-1.2.2-r1: trying to overwrite usr/include/libintl.h owned by gettext-dev
    # ocv_check_modules(GTHREAD): can't find library 'gthread-2.0'.
    # Could NOT find PNG (missing: PNG_LIBRARY) (found version "1.6.37")
    # --no-build-isolation should allow using the installed numpy so it doesn't try to install another numpy
    && pip install --no-cache-dir --no-build-isolation opencv-python \
    && apk del --no-cache .build-deps \
    && apk add --no-cache lapack blas openexr openjpeg libdc1394 ffmpeg-libs \
    && python3 -c "import cv2" \
    && . ./cleanup.sh

