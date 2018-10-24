FROM phusion/baseimage:0.11
ARG DEBIAN_FRONTEND=noninteractive

ENV DASHD_VERSION 0.12.3.3
ENV DASHD_SHA256 19191193a8eaf5a10be08eaa3f33ea60c6a2b8848cd8cfeb8aa2046c962b32bd
ENV DASHCORE_NODE_VERSION 3.0.6
ENV DASHCORE_NODE /usr/local/lib/node_modules/@dashevo/dashcore-node/bin/dashcore-node
ENV DASHCORE_PATH /opt/dashcore
ENV DAEMON_USER dashcore

# Add bitcoin ppa repository
#RUN apt-add-repository -y ppa:bitcoin/bitcoin

# Update & install dependencies and do cleanup
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
        nodejs \
        npm \
        inetutils-ping \
        build-essential \
        libzmq3-dev \
        curl \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and install dashd release
RUN curl --silent -L "https://github.com/dashpay/dash/releases/download/v$DASHD_VERSION/dashcore-$DASHD_VERSION-x86_64-linux-gnu.tar.gz" -o /tmp/dashcore.tar.gz && \
    mkdir /opt/dashd && \
    cd /tmp && \
    echo "$DASHD_SHA256 *dashcore.tar.gz" | sha256sum -c - && \
    tar xzf /tmp/dashcore.tar.gz -C /opt/dashd --strip 1 && \
    rm /tmp/dashcore.tar.gz

# Add dascore system user
RUN useradd -m -r -d $DASHCORE_PATH -s /bin/bash $DAEMON_USER

# Install dashcore
RUN npm install -g @dashevo/dashcore-node@$DASHCORE_NODE_VERSION

# Switch user for setting up dashcore services
USER $DAEMON_USER
RUN cd ~ && \
    bitcore-node-dash create mynode && \
    cd mynode && \
    $DASHCORE_NODE install @dashevo/insight-api && \
    $DASHCORE_NODE install @dashevo/insight-ui

# Add our config
COPY dashcore-node.json $DASHCORE_PATH/mynode/dashcore-node.json

USER root
# Add our startup script
RUN mkdir /etc/service/dashcore-node
COPY dashcore-node.sh /etc/service/dashcore-node/run
RUN chmod +x /etc/service/dashcore-node/run

EXPOSE 3001
VOLUME ["$DASHCORE_PATH/mynode/data/"]
CMD ["/sbin/my_init"]
