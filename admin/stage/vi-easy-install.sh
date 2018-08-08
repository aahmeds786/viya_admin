#!/bin/bash

#######
# ABOUT
# This script is an easy button for installing VI and ESP from this specific AMI
# Simply execute this script and wait for it to complete (~40mins)
# Then, login to VI using psduser and F1tness# to add user permissions in VI
#
# To run this script in the backgroun...
# nohup ./easy-install.sh &> /tmp/install.log &
#
# TODO
## Make shutdown foolproof - likely need to change rc0.d
## Include Nick's /etc/hosts update in this script, instead of calling a separate script
## Parameterize the script for adminuser, adminpass, hostname
## Include openldap instead of relying on SAS AD
#######

DB_PW=Go4thsas


####################################
# Pre-deployment 
####################################
echo "$(date): Pre-deployment"

# fix multitenancy, ldap settings and psdcas passwd
# being explicit about the ldap lines b/c sed can't easily do a "not preceded by string" and therefore the DC=na in userDN gets removed.
sudo sed -i "s/           enabled: 'true'/           enabled: 'false'/; \
s/      administrator: ''/      administrator: 'psdcas'/; \
s/OU=Groups,DC=na,DC=SAS,DC=com/DC=SAS,DC=com/g; \
s/OU=User Accounts,OU=US,DC=na,DC=SAS,DC=com/DC=SAS,DC=com/g; \
s/d6sqtbUhRtX2qEeTfUuuf3eX7/F1tness#/" /install/sas_viya_playbook/roles/consul/files/sitedefault.yml

# update local psdcas password
echo "F1tness#" | sudo passwd psdcas --stdin


#########
## ESP predeployment - not certain this is needed. ESMAGENT is the only service that fails to report ready
export DFESP_HOME=/opt/sas/viya/home/SASEventStreamProcessingEngine/5.1.0
export LD_LIBRARY_PATH=$DFESP_HOME/lib:/opt/sas/viya/home/SASFoundation/sasexe
export PATH=$PATH:$DFESP_HOME/bin


### Run pre-deployment script
/install/preinstall.sh


#######################################
# Deploy software 
#######################################
echo "$(date): Deploying Software"
cd /install/sas_viya_playbook/
ansible-playbook site.yml



#######################################
# POST Deployment steps 
#######################################
echo "$(date): Post-Deployment"


##########
### change postgres password
OLD_PW=$(sudo /opt/sas/viya/home/bin/sas-bootstrap-config \
        --token-file /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token \
        kv read config/application/sas/database/postgres/password)
echo -e "dbmsowner\n$OLD_PW\n$DB_PW\n$DB_PW" | sudo -u sas /opt/sas/viya/home/libexec/sasdatasvrc/script/sds_change_user_pw.sh \
        -config_path /opt/sas/viya/config/etc/sasdatasvrc/postgres/pgpool0/sds_env_var.sh



###### CONFIGURE SAS VISUAL INVESTIGATOR #########
#### Configure CAS for SVI
# fix the oauth.ext->oauth and restart the controller
sudo service sas-viya-cascontroller-default stop
sudo sed -i "s/cas.provlist = 'oauth.ext'/cas.provlist = 'oauth'/" /opt/sas/viya/config/etc/cas/default/casconfig.lua
sudo service sas-viya-cascontroller-default start


#### Restart VI services
echo "$(date) - Restarting VI Services"
sudo bash /opt/sas/viya/home/share/svi-configuration/restart-vi-apps.sh
echo "$(date) - Sleeping for 3m to let the services fully start"
sleep 3m # 

#### CONFIGURE A STANDARD DEPLOYMENT #############
echo "$(date) - Configuring Standard Deployment"
# set the shortname, longname and ip in the bareos-tenant file
sudo sed -i 's/svi_HOST=""/svi_HOST="vi"/; s/svi_SERVICE_HTTP_DOMAIN=""/svi_SERVICE_HTTP_DOMAIN="aws.local"/; s/svi_SERVICE_CONSUL_IP=""/svi_SERVICE_CONSUL_IP="127.0.0.1"/' /opt/sas/viya/home/share/svi-configuration/tenant-management/bareos-tenant.sh
sudo bash /opt/sas/viya/home/share/svi-configuration/tenant-management/bareos-tenant.sh -i



#### Configure the First System User ###########
# In a browser, go to vi.aws.local/SASVisualInvestigator
# Login is user: TKTKT    pw: TKTKT
# Go to admin interface->permissions and add viadmin to sviadms group
# log out



################################################
# EXTRAS
################################################

#### Turn on console UI
echo "$(date) - Turning on console UI"
echo '{"ui": true}' | sudo tee /opt/sas/viya/config/etc/consul.d/config-ui.json > /dev/null
sudo service sas-viya-consul-default restart

#### Ensure safe shutdown
echo "$(date) - Creating shutdown cron entry for 9:10 UTC, M-F"
echo '10 21 * * 1-5 ec2-user sudo service sas-viya-all-services stop' | sudo tee --append /etc/crontab > /dev/null

### Add some domains/zones to make it easier to use multiple instances concurrently by setting various entries in client hosts file
echo "$(date) - Adding zones for convenience"
## GET THE CURRENT ZONES
OLD_ZONES=$(sudo /opt/sas/viya/home/bin/sas-bootstrap-config \
        --token-file /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token \
        kv read config/SASLogon/zones/internal/hostnames)
## DEFINE ZONES TO BE ADDED
NEW_ZONES="aws1,aws2,aws3,aws4,aws5"
echo NEW_ZONES: $NEW_ZONES
## UPDATE THE ZONES
sudo /opt/sas/viya/home/bin/sas-bootstrap-config \
        --token-file /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token \
        kv write -force config/SASLogon/zones/internal/hostnames $OLD_ZONES,$NEW_ZONES
## SHOW THAT THE UPDATE SUCCEEDED
REGISTERED_ZONES=$(sudo /opt/sas/viya/home/bin/sas-bootstrap-config \
        --token-file /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token \
        kv read config/SASLogon/zones/internal/hostnames)
echo REGISTERED_ZONES: $REGISTERED_ZONES


#################################################
# THE END
#################################################
echo "$(date) - Done!"
