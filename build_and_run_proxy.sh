#!/bin/sh

appname="bixel"
proxyname="${appname}_proxy"

echo === Building Proxy Image... ===
docker rm -f ${proxyname}
docker build -t ${proxyname} .

echo === Running Bixel Image... ===
docker run -d -p 443:443 --name="${proxyname}" --link ${appname}:nodeapp  ${proxyname}