#!/bin/bash -ex
#
#  Mint (C) 2017-2022 Minio, Inc.
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

source "${MINT_ROOT_DIR}"/source.sh

$APT update

RETRIES=0
while [ $RETRIES -lt 10 ]; do
	if xargs --arg-file="${MINT_ROOT_DIR}/install-packages.list" -n 1 $APT --no-install-recommends --no-install-suggests install; then
		break
	fi
	sleep 60
	let RETRIES+=1 || true
done

# download and install golang
download_url="https://mirrors.aliyun.com/golang/go${GO_VERSION}.linux-amd64.tar.gz"
if ! $WGET -t 3 --waitretry=30 --output-document=- "$download_url" | tar -C "${GO_INSTALL_PATH}" -zxf -; then
	echo "unable to install go$GO_VERSION"
	exit 1
fi

# set python 3.10 as default
update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

mkdir -p ${GRADLE_INSTALL_PATH}
gradle_url="https://github.com/gradle/gradle-distributions/releases/download/v8.5.0/gradle-${GRADLE_VERSION}-bin.zip"
if ! $WGET -t 3 --waitretry=30 --output-document=- "$gradle_url" | busybox unzip -qq -d ${GRADLE_INSTALL_PATH} -; then
	echo "unable to install gradle-${GRADLE_VERSION}"
	exit 1
fi

chmod +x -v ${GRADLE_INSTALL_PATH}/gradle-${GRADLE_VERSION}/bin/gradle

sync
