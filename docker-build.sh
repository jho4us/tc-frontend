#!/bin/bash
## Author: Andrey Ivanov <jho4us@gmail.com>
## Version: 0.1.0
## Description: Script for bundling, building & deploying a web app with Docker

set -e

REBUILD=true

while getopts nh opt; do
    case $opt in
	h) echo "Usage: $0 target" && exit 1;;
        n) echo "Keep previous build"; REBUILD=false;;
	*) echo "No reasonable options found!";;
    esac
done	
shift $((OPTIND-1))

TARGET=$1

if [ -z "$TARGET" ]; then
  echo 'Missing deployment target. Possible values: production, staging'
  exit 1
fi

BASE_APP_NAME=tc-frontend

BASE_DOCKER_TAG=jho4us/$BASE_APP_NAME
BUILD_DIR=${PWD}/src/dist			# <-- This is where npm r build your files.
											#     Folder will be created and after build will be deleted
PRODUCTION_APP_NAME=$BASE_APP_NAME
PRODUCTION_DOCKER_TAG=$BASE_DOCKER_TAG:latest
PRODUCTION_ROOT_URL=https://tc.ispringsolutions.com

STAGING_APP_NAME=$BASE_APP_NAME-staging
STAGING_DOCKER_TAG=$BASE_DOCKER_TAG:staging
STAGING_ROOT_URL=https://tc-dev.ispringsolutions.com/

case "$TARGET" in
  'production' | 'staging')
    if [ "$TARGET" = 'production' ]; then
      APP_NAME=$PRODUCTION_APP_NAME
      DOCKER_TAG=$PRODUCTION_DOCKER_TAG
      ROOT_URL=$PRODUCTION_ROOT_URL
      BUILD_ENV=production
    elif [ "$TARGET" = 'staging' ]; then
      APP_NAME=$STAGING_APP_NAME
      DOCKER_TAG=$STAGING_DOCKER_TAG
      ROOT_URL=$STAGING_ROOT_URL
      BUILD_ENV=staging
    fi
    echo "Building & deploying $DOCKER_TAG to $TARGET"
    echo ""
    ;;
  *)
    echo 'Invalid deployment target. Possible values: production, staging'
    exit 0
    ;;
esac

echo "Start building container ${DOCKER_TAG} ..."

# Start Timestamp
STARTTIME=`date +%s.%N`

if [ "$REBUILD" = true ] || [ ! "$(ls -A $BUILD_DIR)" ]; then

    pushd src
    echo "Building webpack bundle to $BUILD_DIR"

    # clean old build if exist
    rm -rf $BUILD_DIR
    mkdir -p $BUILD_DIR
    # install node packages
    npm i 
    # build app
    npm run build
    popd
else
    echo "REUSE OLD BUILD.."
fi &&

# build container
docker build --rm -t ${DOCKER_TAG} . &&

echo "End build of container ${CONTAINER} ..."

# End timestamp
ENDTIME=`date +%s.%N`
# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`

echo "Time elapsed: $TIMEDIFF"
