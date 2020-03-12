#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

# Main function that describes the behavior of the
# script.
# By making it a function we can place our methods
# below and have the main execution described in a
# concise way via function invocations.
main() {
  install_project_dependencies

  echo "SUCCESS:
  Done! Finished installing project for test.
  "
}

install_project_dependencies() {
  echo "INFO:
  Installing composer dependencies
  "
  composer install --no-interaction

  echo "INFO:
  Installing database settings
  "
  php bin/console doctrine:database:create --env=test
  php bin/console doctrine:schema:update --force --env=test

  echo "INFO:
  Loading database fixtures
  "
  php bin/console doctrine:fixtures:load -n --env=test
}
