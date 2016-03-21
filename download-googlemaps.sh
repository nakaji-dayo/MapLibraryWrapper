#!/bin/sh

echo 'start: download GoogleMaps.framework'
pwd
ls -la .

wget https://www.gstatic.com/cpdc/6228ff6656915b62-GoogleMaps-1.12.3.tar.gz
echo 'finish download'

ls -la .

tar -xzf 6228ff6656915b62-GoogleMaps-1.12.3.tar.gz
echo 'finish un tgz'

echo 'try mkdir'
mkdir ./Dependencies
ls -la .
echo 'finish mkdir'

mv ./Frameworks/GoogleMaps.framework ./Dependencies/

ls -la .
ls -la ./Dependencies

echo 'finish: download GoogleMaps.framework'
