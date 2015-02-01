#!/bin/bash
# Argumento: linux user
sed -i 's/"linux_user":"radar"/"linux_user":"'$1'"/' node.json
sed -i 's/"linux_user":"radar"/"linux_user":"'$1'"/' node-bootstrap.json
sed -i 's/radar/'$1'/' solo.rb