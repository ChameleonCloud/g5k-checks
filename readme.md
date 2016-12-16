## Build an RPM package

  $ bash build_script/build_rpm.sh

## Build a Debian package

### Build docker image

  $ docker build --tag grid5000/g5kchecks-debuilt .

### Run docker

  $ docker run --rm -v $(pwd):/sources grid5000/g5kchecks-debuilt

Checks `./build` directory.

