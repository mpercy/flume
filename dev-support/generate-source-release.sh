#!/bin/bash -e
################################################
# Shell script to generate a source release
################################################
VERSION_NUMBER=$1
GIT_TAG=$2

if [[ -z "$VERSION_NUMBER" || -z "$GIT_TAG" ]]; then
  echo "Usage: $0 VERSION_NUMBER GIT_TAG"
  echo "Example: $0 1.7.0 release-1.7.0-rc1"
  exit 1
fi

EXT=tar.gz
ARTIFACT_NAME=apache-flume-${VERSION_NUMBER}-src
ARTIFACT_PATH=$ARTIFACT_NAME.$EXT

set -x
git archive --prefix=$ARTIFACT_NAME/ --output=$ARTIFACT_PATH --format "$EXT" "$GIT_TAG"
set +x
ABS_PATH=$(readlink -f $ARTIFACT_PATH)
echo "Source artifact created at $ABS_PATH"
exit 0
