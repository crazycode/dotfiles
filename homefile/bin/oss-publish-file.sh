#!/bin/bash

echo "ossutil cp $1 oss://hys-upload/file/$2"
ossutil cp $1 "oss://hys-upload/file/$2"

echo "uploaded: http://hys-upload.oss-cn-hangzhou.aliyuncs.com/file/$2"
