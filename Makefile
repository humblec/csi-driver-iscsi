# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CMDS=iscsiplugin
all: build

include release-tools/build.make

REV=$(shell git describe --long --tags --match='v*' --dirty 2>/dev/null || git rev-list -n1 HEAD)
ISCSI_CSI_STAGING_VERSION ?= ${REV}
STAGINGVERSION=${ISCSI_CSI_STAGING_VERSION}
STAGINGIMAGE=${ISCSI_CSI_STAGING_IMAGE}
DRIVERBINARY=iscsi-csi-driver
DRIVERWINDOWSBINARY=${DRIVERBINARY}.exe

DOCKER=DOCKER_CLI_EXPERIMENTAL=enabled docker

BASE_IMAGE_LTSC2019=mcr.microsoft.com/windows/servercore:ltsc2019
BASE_IMAGE_1909=mcr.microsoft.com/windows/servercore:1909
BASE_IMAGE_2004=mcr.microsoft.com/windows/servercore:2004
BASE_IMAGE_20H2=mcr.microsoft.com/windows/servercore:20H2

# Both arrays MUST be index aligned.
WINDOWS_IMAGE_TAGS=ltsc2019 1909 2004 20H2
WINDOWS_BASE_IMAGES=$(BASE_IMAGE_LTSC2019) $(BASE_IMAGE_1909) $(BASE_IMAGE_2004) $(BASE_IMAGE_20H2)

iscsi-csi-driver-windows:
	mkdir -p bin
	GOOS=windows go build -mod=vendor -ldflags -X=main.version=$(STAGINGVERSION) -o bin/${DRIVERWINDOWSBINARY} ./cmd/iscsiplugin/