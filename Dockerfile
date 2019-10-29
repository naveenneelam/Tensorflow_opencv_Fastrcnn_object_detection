FROM tensorflow/tensorflow:nightly-devel-py3

RUN apt-get update -y && mkdir /tensorflow/ && mkdir /tensorflow/models/
RUN git clone --depth 1 https://github.com/tensorflow/models.git && \
    mv models /tensorflow/models
 
RUN apt-get install -y python3-setuptools libjpeg-dev libtiff5-dev libavcodec-dev libavformat-dev \
	libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev libatlas-base-dev \
	gfortran python3-dev build-essential pkg-config protobuf-compiler python-pil python-lxml && \
    pip install Cython && \
    pip install contextlib2 && \
    pip install jupyter && \
    pip install pillow && \
    pip install lxml && \
    pip install opencv-python && \
    pip install pandas && \
    pip install matplotlib

RUN \
	cd /root && \
	wget https://github.com/opencv/opencv/archive/3.3.0.tar.gz -O opencv.tar.gz && \
	tar zxf opencv.tar.gz && rm -f opencv.tar.gz && \
	wget https://github.com/opencv/opencv_contrib/archive/3.3.0.tar.gz -O contrib.tar.gz && \
	tar zxf contrib.tar.gz && rm -f contrib.tar.gz && \
	cd opencv-3.3.0 && mkdir build && cd build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-3.3.0/modules \
	-D WITH_CUDA=ON \
	-D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
	-D BUILD_DOCS=OFF \
	-D BUILD_TESTS=OFF \
	-D BUILD_EXAMPLES=OFF \
	-D BUILD_opencv_python2=OFF \
	-D BUILD_opencv_python3=ON \
	-D WITH_1394=OFF \
	-D WITH_MATLAB=OFF \
	-D WITH_OPENCL=OFF \
	-D WITH_OPENCLAMDBLAS=OFF \
	-D WITH_OPENCLAMDFFT=OFF \
	-D CMAKE_CXX_FLAGS="-O3 -funsafe-math-optimizations" \
	-D CMAKE_C_FLAGS="-O3 -funsafe-math-optimizations" \
	.. && make && make install && \
	cd /root && rm -rf opencv-3.3.0 opencv_contrib-3.3.0

# Install pycocoapi
RUN git clone --depth 1 https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    make -j8 && \
    cp -r pycocotools /tensorflow/models/research && \
    cd ../../ && \
    rm -rf cocoapi

# Get protoc 3.0.0, rather than the old version already in the container
RUN curl -OL "http://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip" && \
    unzip protoc-3.0.0-linux-x86_64.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin && \
    mv proto3/include/* /usr/local/include && \
    rm -rf proto3 protoc-3.0.0-linux-x86_64.zip

# Run protoc on the object detection repo
RUN cd /tensorflow/models/research && \
    protoc object_detection/protos/*.proto --python_out=.

# Set the PYTHONPATH to finish installing the API
ENV PYTHONPATH $PYTHONPATH:/tensorflow/models/research:/tensorflow/models/research/slim


# Install wget (to make life easier below) and editors (to allow people to edit
# the files inside the container)
COPY otherdata /tensorflow/
RUN apt-get install -y wget nano &&  cp /tensorflow/models/research/object_detection/samples/configs/faster_rcnn_inception_v2_pets.config /tensorflow/otherdata/training/ && \ wget http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz && \tar xzf faster_rcnn_inception_v2_coco_2018_01_28.tar.gz && \ mv faster_rcnn_inception_v2_coco_2018_01_28 /tensorflow/models/research/object_detection/ 


WORKDIR /tensorflow
