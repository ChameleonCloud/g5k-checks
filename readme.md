# CC-Checks (Chameleon Cloud alterations to G5K checks)

> **Note**: there are different branches in use!
> `centos8`: targets the CentOS8 flavor of the CC-CentOS image build
> `master`: targets everything else.

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

