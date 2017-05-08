FROM debian:jessie

# Update debian packages.
RUN apt-get update

# Install needed packages.
RUN apt-get install -y \
    git npm curl zip vim-common

# Install curl.
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install v6 && \
    npm install -g grunt && \
    npm install -g bower

# Add run.sh script, which will be executed at the launch.
ADD /run.sh /run.sh
ADD /install_dev_env.sh /root/install_dev_env.sh
RUN chmod 0755 /run.sh
RUN chmod 0755 /root/install_dev_env.sh

CMD ["bash", "/run.sh"]
