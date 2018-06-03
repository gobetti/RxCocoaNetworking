#!/bin/bash

set -eo pipefail

VERSION=2.18.0
PORT=8080

project=RxCocoaNetworking
rootdir=${PWD%%${project}*}${project}

cd $rootdir/vendor

wiremock=wiremock-standalone-$VERSION.jar

if ! [ -f "$wiremock" ];
then
   curl http://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/$VERSION/$wiremock -o $wiremock
fi

java -jar $wiremock --port $PORT --root-dir ../wiremock --print-all-network-traffic