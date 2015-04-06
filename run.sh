#!/bin/sh

targetDocker="bixel"
port=443
targetPort=80

while getopts ':d::p::t:' opt; do
  case "$opt" in
    d)
      targetDocker=$OPTARG
      ;;
    p)
      port=$OPTARG
      ;;
    t)
      targetPort=$OPTARG
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

proxyname="${targetDocker}_proxy"

echo === Environment ===
echo Bixel App: ${targetDocker}
echo Proxy App Name: ${proxyname}
echo SSL Port: ${port}

echo
echo === Running SSL-Proxy Image... ===
docker rm -f ${proxyname}
docker run -d -p ${port}:${port} \
--name="${proxyname}" \
--link ${targetDocker}:proxyapp  \
--env PORT=${port} \
--env TARGET_PORT=${targetPort} \
${proxyname}