#!/bin/bash

# The test server to use
if [ -z "$RUN_SELENIUL" ]; then
    RUN_SELENIUM=0
fi


if [ "$RUN_SELENIUM" == "1" ]; then
    cd /var/www/mailvelope_selenium && \
       ./node_modules/.bin/wdio ./config/firefox.conf.js
       ./node_modules/.bin/wdio ./config/chrome.conf.js
fi


