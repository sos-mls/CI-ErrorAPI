#!/bin/bash

# setup ssh information.
. "helpers/get-ssh-info.sh"

echo -n "Username for MySQL: "
read -s ERRORAPI_MYSQL_USERNAME
echo

echo -n "Password for MySQL: "
read -s ERRORAPI_MYSQL_PASSWORD
echo

echo -n "SendGrid Username: "
read -s SEND_GRID_USERNAME
echo

echo -n "SendGrid Password: "
read -s SEND_GRID_PASSWORD
echo

echo -n "SendGrid API Key: "
read -s SEND_GRID_KEY
echo

echo -n "SendGrid Template ID: "
read -s SEND_GRID_TEMPLATE_ID
echo


COMMANDS[0]="echo '${SSH_PASSWORD}' | sudo -S apt-get -y --force-yes install git"
COMMANDS[1]="git clone https://github.com/sos-mls/ErrorApi.git"
COMMANDS[2]="sudo mkdir /var/www"
COMMANDS[3]="sudo mkdir /var/www/error_api"
COMMANDS[4]="sudo mv ErrorApi/src /var/www/error_api/src"
COMMANDS[5]="mv ErrorApi/vagrant install"
COMMANDS[6]="mv ErrorApi/sql sql"
# Configure Installtion process
COMMANDS[7]="sed -i 's/\/home\/vagrant/\/root/g' install/install.sh"
COMMANDS[8]="sed -i 's/default_username/${ERRORAPI_MYSQL_USERNAME}/g' install/helpers/config.txt"
COMMANDS[9]="sed -i 's/default_password/${ERRORAPI_MYSQL_PASSWORD}/g' install/helpers/config.txt"
COMMANDS[10]="sed -i 's/My_SendGrid_Username/${SEND_GRID_USERNAME}/g' install/helpers/config.txt"
COMMANDS[11]="sed -i 's/My_SendGrid_Password/${SEND_GRID_PASSWORD}/g' install/helpers/config.txt"
COMMANDS[12]="sed -i 's/My_SendGrid_Key/${SEND_GRID_KEY}/g' install/helpers/config.txt"
COMMANDS[13]="sed -i 's/My_SendGrid_TemplateId/${SEND_GRID_TEMPLATE_ID}/g' install/helpers/config.txt"

# Run Installation
COMMANDS[14]="sudo bash install/install.sh"
COMMANDS[15]="sudo mkdir /var/www/error_api/src/errors"
COMMANDS[16]="sudo chown www-data:www-data -R /var/www/error_api/src"

n_elements=${#COMMANDS[@]}

for ((i = 0; i < $n_elements; i ++)); do
    sshpass -p $SSH_PASSWORD ssh $SSH_URL ${COMMANDS[i]}
done

# unset ssh information
. "helpers/unset-ssh-info.sh"