#!/bin/bash

# This script deletes compiled code and app dependencies to prevent errors due to changing OS versions and varying system architectures.

rm -rf ./.elixir_ls
rm -rf assets/node_modules

mix do clean, deps.clean --all, deps.get, compile
npm i --prefix assets