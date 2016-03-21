#!/bin/sh

echo 'start: download GoogleMaps.framework'
pwd
ls -la .

wget https://www.gstatic.com/cpdc/6228ff6656915b62-GoogleMaps-1.12.3.tar.gz
tar -xzvf 6228ff6656915b62-GoogleMaps-1.12.3.tar.gz

ls -la .
mkdir ./Dependencies
ls -la .
mv 6228ff6656915b62-GoogleMaps-1.12.3/Frameworks/GoogleMaps.framework
./Dependencies/

ls -la .
ls -la ./Dependencies

echo 'finish: download GoogleMaps.framework'
