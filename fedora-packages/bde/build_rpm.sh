#!/bin/bash

#set -x

rm -rfv ~/rpmbuild
rpmdev-setuptree ~

tmp=`mktemp`

python -c "import rpm
spec = rpm.spec('bde.spec')
for src in spec.sources:
    print src[0]" > $tmp

pushd ~/rpmbuild/SOURCES

while read sourceurl
do
    echo "Source: $sourceurl"
    wget "$sourceurl"
done < $tmp

popd
rpmbuild -bb bde.spec

rm $tmp

#set +x
