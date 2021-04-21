#!/bin/bash

V2RAY_VERSION=4.34.0

# Install requirements components

apt-get install unzip -y
apt-get install python3-pip -y
/usr/bin/pip3 install requests

FILE_NAME=v2ray-linux-64.zip
TMP_ZIP_PATH=/tmp/${FILE_NAME}

# Download v2ray zip file from github releases
curl -L https://github.com/v2fly/v2ray-core/releases/download/v${V2RAY_VERSION}/${FILE_NAME} --output ${TMP_ZIP_PATH}

LIB_PATH=/usr/lib/v2ray-linux-64
echo "Download and install v2ray-linux-64 to ${LIB_PATH}"
unzip -o ${TMP_ZIP_PATH} -d ${LIB_PATH}

echo "Create soft symbol link to /usr/bin/v2ray"
ln -s -f ${LIB_PATH}/v2ray /usr/bin/v2ray

# Generate v2ray config file

SCRIPT_FILE_NAME=generate_v2ray_config_file.py
SCRIPT_FILE_URL=https://github.com/Robert-lihouyi/aws-image/raw/main/${SCRIPT_FILE_NAME}
TMP_SCRIPT_FILE_PATH=/tmp/${SCRIPT_FILE_NAME}

# Download generate_v2ray_config_file.py

echo "Download generate_v2ray_config_file.py from <${SCRIPT_FILE_URL}>"
curl -L ${SCRIPT_FILE_URL} --output ${TMP_SCRIPT_FILE_PATH}

chmod u+x ${TMP_SCRIPT_FILE_PATH}

V2RAY_CONFIG_FILE_PATH=/etc/v2ray.json

echo "Generate v2ray config file to <${V2RAY_CONFIG_FILE_PATH}>"
/usr/bin/python3 ${TMP_SCRIPT_FILE_PATH} -w ${V2RAY_CONFIG_FILE_PATH}

# Install V2Ray as service

SERVICE_MODULE_FILE_URL=https://github.com/Robert-lihouyi/aws-image/raw/main/v2ray.service
SERVICE_MODULE_PATH=/etc/systemd/system/v2ray.service

curl -L ${SERVICE_MODULE_FILE_URL} --output ${SERVICE_MODULE_PATH}

chmod 644 ${SERVICE_MODULE_PATH}

echo "Enable service v2ray.service <${SERVICE_MODULE_PATH}>"
/usr/bin/systemctl enable v2ray.service
