#!/bin/bash -x
TOOLSDIR=`dirname $0`
rm -rf $TOOLSDIR/../builds-browsable-dereferenced-links
cp -vrfpaL $TOOLSDIR/../builds $TOOLSDIR/../builds-browsable-dereferenced-links
