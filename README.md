# tensorflow_opencv_fastrcnn_object_detection
Docker for object detection using tensorflow, Opencv and fastrcnn 

This project is based on ubuntu, it is used for object detection using the fast_rcnn library with tensorflow(python3) and opencv 

docker does the following
1. install tensorflow development build which supports python3 
2. download the tensorflow models
3. downloads, compiles and install opencv which is used for object detection
4. copy the preconfigured fast_rcnn library into a specific directory (it will be used for training the data for object detection)
5. preconfigured folder contains config files, scripts to generate xml from cv files  generated based on the labeled images which are used for training etc..

