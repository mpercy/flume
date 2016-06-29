#!/bin/bash -e

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Compare class outputs from different runs of proguard.

if [ -z "$2" ]; then
  echo "Usage: $0 dir1 dir2"
  exit 1
fi

DIR1=$1
DIR2=$2

unpack_and_checksum() {
  DIR=$1
  echo "Unpacking JARs and checksumming classes in $DIR"
  pushd $DIR
  for JAR in *.jar; do
    jar xf $JAR
  done
  find . -type f -name \*.class | xargs md5sum | sort > classes.md5
  popd
}

unpack_and_checksum $DIR1
unpack_and_checksum $DIR2

set -x
comm -3 $DIR1/classes.md5 $DIR2/classes.md5 | awk '{print $2}' | sort -u
