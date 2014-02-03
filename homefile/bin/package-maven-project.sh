#!/bin/bash
# 打包Maven项目
# 接收以下参数：
#      -g

usage() {
    echo "打包Maven项目工具，把WORK_DIR目录中target目录下生成的war文件，解压到$TEMP_DIR/ROOT目录，并提交到对应git服务器."
    echo "Usage: $0 [-g GIT_URL] [-t TEMP_DIR] [-p WORK_DIR]";
    exit 1;
}

while getopts ":g:t:p:" o; do
    case "${o}" in
        g)
            GIT_URL=${OPTARG}
            ;;
        t)
            TEMP_DIR=${OPTARG}
            ;;
        p)
            WORK_DIR=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${GIT_URL}" ] || [ -z "${TEMP_DIR}" ] || [ -z "${WORK_DIR}" ]; then
    usage
fi

REAL_TEMP_DIR=`readlink -f $TEMP_DIR`
REAL_WORK_DIR=`readlink -f $WORK_DIR`


# 检查REAL_WORK_DIR目录下是否存在而且只存在一个war文件
WAR_NUM=`find $REAL_WORK_DIR -name "*.war" | wc -l`
if [ ! $WAR_NUM == 1 ]; then
    echo "${REAL_WORK_DIR}存在多个war文件."
    exit 1
fi

WAR_FILE=`find $REAL_WORK_DIR -name "*.war"`
if [ -e $WAR_FILE ]; then
    echo "$WAR_FILE 存在."
fi


if [ ! -d "${REAL_TEMP_DIR}" ]; then
    # 建立git临时目录
    git clone ${GIT_URL} ${REAL_TEMP_DIR}
fi

if [ ! -d "${REAL_TEMP_DIR}/.git" ]; then
    echo "${REAL_TEMP_DIR}不是git目录，请先执行："
    echo "    git clone ${GIT_URL} ${REAL_TEMP_DIR}"
    exit 1;
fi

if [ ! -d "${REAL_WORK_DIR}/target" ] && [ ! -e "${REAL_WORK_DIR}/pom.xml" ]; then
    echo "${REAL_WORK_DIR}不是maven工作目录！"
    exit 1;
fi


cd ${REAL_TEMP_DIR}
echo "Begin Copy to ${REAL_TEMP_DIR}"

git pull
git rm -rf ROOT/*
mkdir -p ROOT
cp ${WAR_FILE} ROOT/
cd ROOT
jar -xf *.war
rm *.war

NOW_TIME=`date +'%Y-%m-%d %H:%M:%S'`
#生成版本
BUILD_VERSION="v1.0"

rm -f WEB-INF/version.conf
echo "build.time=${NOW_TIME}" >> WEB-INF/version.conf
echo "version=${BUILD_VERSION}" >> WEB-INF/version.conf
echo "revision=${SVN_REVISION}" >> WEB-INF/version.conf
echo "generate version.conf success."

cat conf/version.conf

git add --all .
echo git commit -m "build ${BUILD_VERSION}"
git commit -m "build ${BUILD_VERSION}"
git push

echo "PACKAGE TO GIT REPOSITORY SUCCESS!"

exit 0;
