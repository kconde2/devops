#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

# Main function that describes the behavior of the
# script.
# By making it a function we can place our methods
# below and have the main execution described in a
# concise way via function invocations.
main() {
  setup_dependencies
  update_docker_configuration

  echo "SUCCESS:
  Done! Finished setting up Travis machine.
  "
}

# Prepare the dependencies that the machine need.
# Here I'm just updating the apt references and then
# installing both python and python-pip. This allows
# us to make use of `pip` to fetch the latest `docker-compose`
# later.
# We also upgrade `docker-ce` so that we can get the
# latest docker version which allows us to perform
# image squashing as well as multi-stage builds.
setup_dependencies() {
  echo "INFO:
  Setting up dependencies.
  "

  sudo apt update -y
  sudo apt install realpath python python-pip -y
  sudo apt install --only-upgrade docker-ce -y

  sudo pip install docker-compose || true

  docker info
  docker-compose --version
}

# Tweak the daemon configuration so that we
# can make use of experimental features (like image
# squashing) as well as have a bigger amount of
# concurrent downloads and uploads.
update_docker_configuration() {
  echo "INFO:
  Updating docker configuration
  "

  echo '{
  "experimental": true,
  "storage-driver": "overlay2",
  "max-concurrent-downloads": 50,
  "max-concurrent-uploads": 50
}' | sudo tee /etc/docker/daemon.json
  sudo service docker restart
}

main
With that set, we can move on to the Travis configuration file (.travis.yml):

# make use of vm's
sudo: 'required'

# have the docker service set up (we'll
# update it later)
services:
  - 'docker'

# prepare the machine before any code
# installation scripts
before_install:
  - './.travis/main.sh'

# first execute the test suite.
# after the test execution is done and didn't
# fail, build the images (if this step fails
# the whole Travis build is considered a failure).
script:
  - 'make test'
  - 'make image'

# only execute the following instructions in
# the case of a success (failing at this point
# won't mark the build as a failure).
# To have `DOCKER_USERNAME` and `DOCKER_PASSWORD`
# filled you need to either use `travis`' cli
# and then `travis set ..` or go to the travis
# page of your repository and then change the
# environment in the settings pannel.
after_success:
  - if [[ "$TRAVIS_BRANCH" == "master" ]]; then
      docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD ;
      make push-image ;
    fi

# don't notify me when things fail
notifications:
  email: false
