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

    echo "SUCCESS:
  Done! Finished testing
  "
}

setup_dependencies() {
    echo "INFO:
  Running tests
  "
    ./vendor/bin/simple-phpunit --coverage-text --colors
}
