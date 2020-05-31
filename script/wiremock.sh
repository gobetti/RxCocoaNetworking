#!/bin/bash

set -eo pipefail

VERSION=2.26.3
PORT=8080

project=RxCocoaNetworking
rootdir=${PWD%%${project}*}${project}

mkdir -p $rootdir/vendor
cd $rootdir/vendor

wiremock=wiremock-standalone-$VERSION.jar
wiremock_url=https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/$VERSION/$wiremock

if ! [ -f "$wiremock" ];
then
   echo "Downloading wiremock from $wiremock_url"
   curl $wiremock_url -o $wiremock
fi

java -jar $wiremock --port $PORT --root-dir ../wiremock --print-all-network-traffic
