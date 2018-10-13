#!/bin/bash

set -ex

# broctl install
broctl deploy
broctl check
broctl start