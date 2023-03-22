#!/bin/bash

usage () {
    echo "USAGE: image.sh COMMAND"
    echo "Commands:"
    echo "     build:       (Re)build the aptcrowd/discourse:build_ac image"
    echo "     push:        Tag and push the image to the aptcrowd Docker Hub repository"
}

SAVED_ARGV=("$@")

command=$1

if [ -z "$command" ]
then
  usage
fi

build() {
  docker build --no-cache --tag aptcrowd/discourse:build_ac . 
}

pushImage() {
  cur_ts=$(date +%Y%m%d_%H%M%S)
  echo "Tagging images as $cur_ts. Please ensure all code changes have been committed and pushed."
  docker tag aptcrowd/discourse:build_ac aptcrowd/discourse:$cur_ts
  docker login
  docker push aptcrowd/discourse:build_ac
  docker push aptcrowd/discourse:$cur_ts
  docker logout

  echo "Images pushed. Update launcher's image variable to:"
  echo "aptcrowd/discourse:$cur_ts"
}

if [ "$command" == "build" ]
then
  build
elif [ "$command" == "push" ]
then
  pushImage
else
  usage
fi