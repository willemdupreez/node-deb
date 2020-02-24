#!/bin/bash
set -e

cd "$(dirname $0)"

# declare -ar images=('debian-buster')
declare -ar images=('debian-jessie'
                    'debian-stretch'
                    'debian-buster'
                    'ubuntu-trusty'
                    'ubuntu-xenial'
                    'ubuntu-bionic')

declare -r node_dl='./node.tar.xz'
declare -r node_out='./node'
declare -i push=0
declare -i force=0
declare -r docker_repository='runoptimised/node-deb-test'
declare -r node_version='12.16.1'

while [ -n "$1" ]; do
  if [ -z "$1" ]; then break; fi
  param="$1"
  value="$2"
  case $param in
    --push)
      push=1
      shift
    ;;
    --force)
      force=1
      shift
    ;;
    *)
      echo "Unknown arg: $param"
      exit 1
    ;;
  esac
done

set -u

if [ ! -f "$node_dl" ]; then
  curl "https://nodejs.org/dist/v$node_version/node-v$node_version-linux-x64.tar.xz" >> "$node_dl"
fi

if [ ! -d  "$node_out" ]; then
  tar -xJf "$node_dl"
  mv "node-v$node_version-linux-x64" node
fi

if [ $force -eq 1 ]; then
  for image in ${images[@]}; do
    docker rmi --force "$docker_repository:$image"
  done
fi

for image in ${images[@]}; do
  docker build -t "$docker_repository:$image" -f "$image" .
done

if [[ $push -eq 1 ]]; then
  for image in ${images[@]}; do
    docker push "$docker_repository:$image"
  done
fi
