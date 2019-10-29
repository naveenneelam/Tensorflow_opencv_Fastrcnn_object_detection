#!/usr/bin/env python
# coding: utf-8

# In[12]:


import os,shutil
fldr="C:\\Users\\user\\Desktop\\raccoon_dataset-master\\kk\\tenseobjdet\\data\\"
totllab=len(os.listdir(fldr+"\\images\\"))
trainlabel=totllab*0.8
if(os.path.isdir(fldr+"train")):
    print('exists')
else:
    os.mkdir(fldr+"train")
if(os.path.isdir(fldr+"test")):
    print('exists')
else:
    os.mkdir(fldr+"test\\")
if(os.path.isdir(fldr+"train\\images\\")):
    print('exists')
else:
    os.mkdir(fldr+"train\\images\\")
if(os.path.isdir(fldr+"test\\images\\")):
    print('exists')
else:
    os.mkdir(fldr+"test\\images\\")
if(os.path.isdir(fldr+"train\\labels\\")):
    print('exists')
else:
    os.mkdir(fldr+"train\\labels\\")
if(os.path.isdir(fldr+"test\\labels\\")):
    print('exists')
else:
    os.mkdir(fldr+"test\\labels\\")
i=0
for fls in os.listdir(fldr+"images"):
    if(i<=trainlabel):
        shutil.move(fldr+"images\\"+fls,fldr+"train\\images")
    else:
        shutil.move(fldr+"images\\"+fls,fldr+"test\\images")
    i=i+1 
i=0
for fls in os.listdir(fldr+"labels"):
    if(i<=trainlabel):
        shutil.move(fldr+"labels\\"+fls,fldr+"train\\labels")
    else:
        shutil.move(fldr+"labels\\"+fls,fldr+"test\\labels")
    i=i+1 

