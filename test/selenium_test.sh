#!/usr/bin/env bash

# set -e: exit asap if a command exits with a non-zero status
set -e

# echo fn that outputs to stderr http://stackoverflow.com/a/2990533/511069
echoerr() {
  cat <<< "$@" 1>&2;
}

# print error and exit
die () {
  echoerr "ERROR: $1"
  # if $2 is defined AND NOT EMPTY, use $2; otherwise, set to "3"
  errnum=${2-3}
  exit $errnum
}

# Required params
[ -z "${1}" ] && die "Need first argument to be the browser name"
browser_name=${1}

echo "--------------------------"
echo "- Self test on ${browser_name}"
echo "--------------------------"

if [ "${VIDEO}" = "true" ]; then
  stop-video >/dev/null 2>&1 || true
  rm -f /test/videos/${browser_name}/*
  start-video
fi

python_test ${browser_name}

if [ "${VIDEO}" = "true" ]; then
  stop-video
  mkdir -p /test/videos/${browser_name}
  mv /videos/* /test/videos/${browser_name}/
fi

# How to archive console.png and videos from the docker host:
#  docker cp grid:/test/console.png .
#  docker cp grid:/test/videos/chrome/test.mkv chrome.mkv
#  docker cp grid:/test/videos/firefox/test.mkv firefox.mkv
