#!/usr/bin/env bash

set -eu

apt update &> /dev/null && apt install -y wget curl jq &> /dev/null

ADOPTOPENJDK_API='https://api.adoptopenjdk.net'

releases="$(curl -Ss "${ADOPTOPENJDK_API}/v2/info/releases/openjdk${JAVA_VERSION}")"

latest_linux_x64_releases="$(echo ${releases} | jq -r '.[] | select(.binaries[].os == "linux" and .binaries[].architecture == "x64") | .release_name' | grep -v 'openj9' | sort -rV | head -n1)"

echo "Latest release of Java ${JAVA_VERSION} for linux is ${latest_linux_x64_releases}"

jre_download_url="$(echo ${releases} | jq -r ".[] | select(.release_name == \"${latest_linux_x64_releases}\") | .binaries[]| select(.os == \"linux\" and .architecture == \"x64\" and .binary_type == \"jre\") | .binary_link")"
jdk_download_url="$(echo ${releases} | jq -r ".[] | select(.release_name == \"${latest_linux_x64_releases}\") | .binaries[]| select(.os == \"linux\" and .architecture == \"x64\" and .binary_type == \"jdk\") | .binary_link")"

echo "Fetching $(basename ${jre_download_url})"
wget --quiet "${jre_download_url}" -P jre/

echo "Fetching $(basename ${jdk_download_url})"
wget --quiet "${jdk_download_url}" -P jdk/
