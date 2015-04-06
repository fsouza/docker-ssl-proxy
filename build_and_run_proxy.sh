#!/bin/sh

appname="bixel"
port=443

while getopts ':d::p:' opt; do
  case "$opt" in
    d)
      appname=$OPTARG
      ;;
    p)
      port=$OPTARG
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

proxyname="${appname}_proxy"

echo === Environment ===
echo Bixel App: ${appname}
echo Proxy App Name: ${proxyname}
echo SSL Port: ${port}

echo
echo === Building Proxy Image... ===
docker rm -f ${proxyname}
docker build -t ${proxyname} .

echo
echo === Running Bixel Image... ===
docker run -i -t -p ${port}:${port} \
--name="${proxyname}" \
--link ${appname}:proxyapp  \
--env PORT=${port} \
${proxyname}