# CC-Checks (Chameleon Cloud alterations to G5K checks)

This fork includes changes made to Grid5000's for ChameleonCloud images:
* Branches for Ubuntu usage
  * Bionic
  * Trusty
  * Xenial
* Added the -n flag to run checks without Openstack API call
  * Used to run checks at deploy time of an instance

## Build RPM package

  $ ./scripts/build_rpm.sh

## Build Debian package

### Build docker image

  $ docker build --tag grid5000/g5kchecks-debuilt .

### Run docker

  $ docker run --rm -v $(pwd):/sources grid5000/g5kchecks-debuilt

Checks `./build` directory.

