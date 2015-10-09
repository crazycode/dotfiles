#!/bin/bash

ORGIN_SVN_PARENT_DIR="/Volumes/DATA/backups/tangliqun-diskbackup/disk1/snda/sdpsvnroot"

for SVN_DIR in $ORGIN_SVN_PARENT_DIR/*; do
    if [[ -d $SVN_DIR/db ]]; then
        echo "SVN_DIR=$SVN_DIR"
        SVN_NAME=$(basename $SVN_DIR)
        echo "SVN_NAME=$SVN_NAME"
        svnadmin dump $SVN_DIR > $SVN_NAME
        gzip $SVN_NAME
    else
        echo "......................不是SVN路径: $SVN_DIR "
    fi
done
