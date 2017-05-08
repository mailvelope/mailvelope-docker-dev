#!/usr/bin/env bash

echo "Step 1: download submodules"
cd /var/www/mailvelope
git submodule update --init

echo "Step 2: Build openpgpjs for chrome"
cd dep/chrome/openpgpjs
npm install && grunt

echo "Step 3: Build openpgpjs for firefox"
cd ../../firefox/openpgpjs
npm install && grunt

echo "Step 4: Build other components"
cd ../../..
npm install &&  \
    bower install --allow-root --force && \
    grunt