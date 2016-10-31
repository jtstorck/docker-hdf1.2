#!/bin/bash

/HDF-1.2.0.0/ncm/bin/nifi.sh start
/HDF-1.2.0.0/nifi/bin/nifi.sh start
tail -f /HDF-1.2.0.0/ncm/logs/nifi-app.log -f /HDF-1.2.0.0/nifi/logs/nifi-app.log
