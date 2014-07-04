#!/bin/bash

#set -x

rm -rfv ~/rpmbuild
rpmdev-setuptree ~

tmp=`mktemp`

python -c "import rpm
spec = rpm.spec('bde.spec')
for src in spec.sources:
    print src[0]" > $tmp

OLD_DIR=`pwd`
cd ~/rpmbuild/SOURCES

while read sourceurl
do
    echo "Source: $sourceurl"
    wget "$sourceurl"
done < $tmp
ls -l

cd "$OLD_DIR"

rpmbuild -ba bde.spec

rm $tmp

#set +x
