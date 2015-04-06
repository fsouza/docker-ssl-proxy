#!/bin/sh

targetDocker="bixel"

while getopts ':d:' opt; do
  case "$opt" in
    d)
      targetDocker=$OPTARG
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

echo
echo === Building Proxy Image... ===
docker rm -f ${proxyname}
docker build -t ${proxyname} .