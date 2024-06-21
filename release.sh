#!/bin/bash -ex
#
#  Minio Cloud Storage, (C) 2017 Minio, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

export MINT_ROOT_DIR=${MINT_ROOT_DIR:-/mint}
source "${MINT_ROOT_DIR}"/source.sh

git config --global http.proxy "$http_proxy"
git config --global https.proxy "$https_proxy"

# install mint app packages
for pkg in "$MINT_ROOT_DIR/build"/*/install.sh; do
	echo "Running $pkg"
	RETRIES=0
	while [ $RETRIES -lt 5 ]; do
		if $pkg; then
			break
		fi
		sleep 60
		let RETRIES+=1 || true
	done
done

#"${MINT_ROOT_DIR}"/postinstall.sh
