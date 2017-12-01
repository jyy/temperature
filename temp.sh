#!/bin/bash

JQ="/usr/local/bin/jq"
LAST_UPDATED_FILE="./temp_lastupdated.txt"
CSV_FILE="./temp.csv"
URL=$(head -n 1 ./temp_url.txt)
RESP=$(curl -s "${URL}")
TEMP_C_NO_DECIMAL=$(echo ${RESP} | ${JQ} '.state.temperature')
TEMP_C=$(echo "${TEMP_C_NO_DECIMAL}/100" | bc -l)
TEMP_F=$(echo "(${TEMP_C}*(9/5))+32" | bc -l)

TIMESTAMP=$(echo ${RESP} | ${JQ} '.state.lastupdated' | tr -d \")

touch ${CSV_FILE}
touch ${LAST_UPDATED_FILE}

LAST_UPDATED=$(head -n 1 ${LAST_UPDATED_FILE})
if [ "${TIMESTAMP}" != "${LAST_UPDATED}" ]; then
  echo ${TIMESTAMP} > ${LAST_UPDATED_FILE}
  echo "${TIMESTAMP},${TEMP_C},${TEMP_F}" >> ${CSV_FILE}
fi
