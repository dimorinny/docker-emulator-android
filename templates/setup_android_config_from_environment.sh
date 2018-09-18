#!/usr/bin/env bash

CONFIG="/root/.android/avd/x86.avd/config.ini"
CONFIGTMP=${CONFIG}.tmp

if [ -n "$ANDROID_CONFIG" ];
then
  IFS=';' read -ra OPTS <<< "$ANDROID_CONFIG"
  for OPT in "${OPTS[@]}"; do
    IFS='=' read -ra KV <<< "$OPT"
    KEY=${KV[0]}
    VALUE=${KV[1]}
    mv ${CONFIG} ${CONFIGTMP}
    cat ${CONFIGTMP} | grep -v ${KEY}= > ${CONFIG}
    echo ${OPT} >> ${CONFIG}
  done
fi