#!/bin/sh

cd /opt/dashcore/mynode/
exec /sbin/setuser dashcore /usr/local/lib/node_modules/@dashevo/dashcore-node/bin/dashcore-node start >> /var/log/dashcore-node.log 2>&1
