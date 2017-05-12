# Mailvelope development docker container

This docker container is to be used for development purpose. It provides a quickly accessible working environment to build the chrome and firefox mailvelope extensions, and execute the selenium tests. 

## Requirements
Before you can use it, you will need to have docker installed on your system. You can download docker here: https://www.docker.com/

## To launch the container 
To use this container, you will need to follow the steps below

1) Download mailvelope and mailvelope_docker_dev sources:

`cd your_dev_directory`
`git clone git@github.com:mailvelope/mailvelope.git`
`git clone git@github.com:mailvelope/mailvelope_docker_dev.git`

2) Build the container

`docker build -t mailvelope_docker_dev ./mailvelope_docker_dev`

3) Start the container

`docker run -d -it --hostname=mailvelope.docker --name mailvelope_docker_dev \
     -v /{your_dev_directory}/mailvelope:/var/www/mailvelope \
     mailvelope_docker_dev`
     
You will notice that the mailvelope directory that you just downloaded is also mounted on the docker container in the command above. Thanks to this
we'll be able to interact with the mailvelope files directly from inside the container.
     
## How to use for development?
The container contains the needed environment to work on mailvelope. From inside the container you can directly execute the build commands to build mailvelope extensions.

You will first need to connect to the container in order to access its shell:
`docker exec -i -t mailvelope /bin/bash`

Once connected, mailvelope will be accessible in the /var/www directory.
`cd /var/www/mailvelope`

If the plugin has never been built before, a script to make the complete build of mailvelope is available:
`/root/install_dev_env.sh`

If the plugin has already been built before, you just need to execute the extensions build command from inside the container:
`grunt dist-cr` and `grunt dist-ff`

## Selenium tests: preparing your environment

To execute the selenium tests, you will need:

1) Download the mailvelope_selenium project, and mount it on the docker at run time.

`cd your_dev_directory`
`git clone git@github.com:mailvelope/mailvelope.git`

2) You will need to pull the [elgalu/selenium](https://github.com/elgalu/docker-selenium) image

`docker pull elgalu/selenium`

It will take a few minutes to download.

3) Run the selenium docker container:

`docker run -d --name=grid -p 4444:24444 -p 5900:25900 \
      -e TZ="US/Pacific" --shm-size=1g elgalu/selenium`


4) Run the mailvelope docker container while mounting also the mailvelope_selenium folder:

Beware to replace {selenium_server_ip} with the ip of your host. (you can obtain it with a ifconfig).

`docker run -d -it --hostname=mailvelope.docker --name mailvelope_docker_dev \
     -v /{your_dev_directory}/mailvelope:/var/www/mailvelope \
     -v /{your_dev_directory}/mailvelope_selenium:/var/www/mailvelope_selenium \
     -e SELENIUM_SERVER_IP="{selenium_server_ip}" \
     mailvelope_docker_dev`
     
5) If it's the first time you use the test suite, you will will have to build first the node dependencies.

`cd /var/www/mailvelope_selenium && npm install`

6) Execute the tests

`./node_modules/.bin/wdio ./config/firefox.conf.js`
`./node_modules/.bin/wdio ./config/chrome.conf.js`

To see the tests actually being executed in the selenium browser, you can use vnc on your host 
and connect to the grid ip:
`vnc {selenium_server_ip}`

More documentation on how to use the grid is [available here](https://github.com/elgalu/docker-selenium)
