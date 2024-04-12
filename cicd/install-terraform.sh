#!bin/bash

set -eu

sudo apt update

sudo apt install terraform -y

terraform --version
