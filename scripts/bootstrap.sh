#!/usr/bin/env bash
#-------------------------------------------------------------------------------
set -e

TOP_DIR="`pwd`"
APP_USER="${1:-vagrant}"
LOG_FILE="${2:-/dev/stderr}"
TIME_ZONE="${3:-America/New_York}"

if [ "$APP_USER" == 'root' ]
then
    APP_HOME="/root"
else
    APP_HOME="/home/${APP_USER}"
fi
#-------------------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

echo "Upgrading core OS packages" | tee -a "$LOG_FILE"
apt-get update -y >>"$LOG_FILE" 2>&1
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >>"$LOG_FILE" 2>&1

echo "Installing core dependencies" | tee -a "$LOG_FILE"
apt-get install -y \
        apt-utils \
        software-properties-common \
        curl \
        wget \
     >>"$LOG_FILE" 2>&1

echo "Syncronizing time" | tee -a "$LOG_FILE"
apt-get --yes install ntpdate >>"$LOG_FILE" 2>&1
ntpdate pool.ntp.org >>"$LOG_FILE" 2>&1

echo "Installing development tools" | tee -a "$LOG_FILE"
apt-get install -y \
        net-tools \
        git \
        g++ \
        gcc \
        make \
        python3-pip \
     >>"$LOG_FILE" 2>&1
