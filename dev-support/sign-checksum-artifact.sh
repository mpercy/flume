#!/bin/bash -e
###########################################################
# Sign and checksum release artifacts.
###########################################################

usage() {
  echo "Usage: $0 RELEASE_ARTIFACT"
  echo "Example: $0 ./apache-flume-1.7.0-bin.tar.gz"
  exit 1
}

ARTIFACT=$1

# Find GnuPG.
GPG=$(which gpg)

# Find md5.
MD5=$(which md5sum)
[ -z "$MD5" ] && MD5=$(which md5)

# Find sha1.
SHA1=$(which sha1sum)
[ -z "$MD5" ] && MD5=$(which shasum)

if [ -z "$GPG" ]; then
  echo "Cannot find gpg. Please install GnuPG to continue."
  usage
fi
if [ -z "$MD5" ]; then
  echo "Cannot find md5sum. Please install the md5sum program to continue."
  usage
fi
if [ -z "$SHA1" ]; then
  echo "Cannot find sha1sum. Please install the sha1sum program to continue."
  usage
fi
if [ -r "$ARTIFACT" ]; then
  echo "The artifact at $ARTIFACT does not exist or is not readable."
  usage
fi

# Now sign and checksum the artifact.
set -x
gpg --sign $ARTIFACT
$MD5 < $ARTIFACT > $ARTIFACT.md5
$SHA1 < $ARTIFACT > $ARTIFACT.sha1

exit 0
