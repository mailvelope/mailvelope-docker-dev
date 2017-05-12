#!/bin/bash

# The test server to use
if [ -z "$RUN_SELENIUM" ]; then
    RUN_SELENIUM=0
fi

if [ "$RUN_SELENIUM" == '1' ]; then
    KEEP_ALIVE=0
else
    KEEP_ALIVE=1
fi

# Copy the mailvelope_selenium key inside the mailvelope directory.
cp /var/www/mailvelope_selenium/config/key.pem /var/www/mailvelope/.travis/key.pem

# Build maivelope extension for chrome and firefox.
cd /var/www/mailvelope && grunt build
# Build for ff.
grunt dist-ff
# Build for chrome.
./.travis/crxmake.sh ./build/chrome /var/www/mailvelope/.travis/key.pem

# create symlinks.
ln -s -f /var/www/mailvelope/dist/mailvelope.chrome.crx /var/www/mailvelope_selenium/data/extensions/
ln -s -f /var/www/mailvelope/dist/mailvelope.xpi /var/www/mailvelope_selenium/data/extensions/

if [ "$RUN_SELENIUM" == "1" ]; then
    cd /var/www/mailvelope_selenium
    #./node_modules/.bin/wdio ./config/firefox.conf.js
    ./node_modules/.bin/wdio ./config/chrome.conf.js
fi

########################################################
## Keep the container alive after
########################################################

if [ "$KEEP_ALIVE" == '1' ]; then
    /bin/bash
fi
