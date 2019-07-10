#!/bin/bash

set -eu

############################################################
# Installing dependencies
############################################################
if [ $RAMDISK != "yes" ]
    sudo yum install -y rubygems-devel

############################################################
# Preparing tmp folder and its subfolders
############################################################
USE_HOME_FOLDER=${USE_HOME_FOLDER:-yes}
if [ "$USE_HOME_FOLDER" != "yes" ]; then
    TMP_FOLDER=$(mktemp -d)
    BUILD_FOLDER=$TMP_FOLDER/rpmbuild
else
    BUILD_FOLDER="$HOME/rpmbuild"
fi

echo "%_topdir $BUILD_FOLDER" > ~/.rpmmacros

rm -rf $BUILD_FOLDER
mkdir -p $BUILD_FOLDER/{BUILD,RPMS,SOURCES,SPECS,SRPMS}


############################################################
# Generating a new GEM file
############################################################
# Generate a new gems file
GEM_BUILD_OUTPUT=$(gem build g5k-checks.gemspec)
GEM_FILE_NAME=$(echo $GEM_BUILD_OUTPUT | grep -o -E '[a-z.A-Z0-9-]+\.gem')
echo $GEM_FILE_NAME
cp $GEM_FILE_NAME $BUILD_FOLDER/SOURCES/.

# (Generate and) copy the gemspec file in the temporary rpmbuild folder
cp rpmbuild/SPECS/g5k-checks.spec $BUILD_FOLDER/SPECS/g5k-checks.spec


############################################################
# Generating the RPM package
############################################################
pushd $BUILD_FOLDER
rpmbuild -ba $BUILD_FOLDER/SPECS/g5k-checks.spec
popd


############################################################
# Checking that everything worked
############################################################
echo "RPM files should have been produced in $BUILD_FOLDER:"
find $BUILD_FOLDER -name "*.rpm"

RPM_CANDIDATE_FILE=$(find $BUILD_FOLDER -name '*.rpm' | grep -v 'SRPMS' | head -n 1)
echo ""
echo "To install the RPM, use the following command:"
echo "sudo yum localinstall -y $RPM_CANDIDATE_FILE"

exit 0
