#!/bin/bash

# TOGO:
# Think about how to get the encrypted into the olc.

# REVISIONS:
# 5/4 - added creation of 'cas' in /etc/passwd as deployment fails
# 5/4 - added creation of home directories

_PASSWD=progress
_DOMAIN=aws.com
_BASEDN="dc=aws,dc=com"
_REPOROOT=/workspace

# Functions

function build_users() {
  sudo useradd sas
  sudo useradd sasdemo
  sudo useradd cas

  sudo useradd -G sas sasdemo
  sudo useradd -G sas cas

  grep "sas:" /etc/passwd >> ${_OCONFIG}/passwd
  grep "sasdemo:" /etc/passwd >> ${_OCONFIG}/passwd
  grep "cas:" /etc/passwd >> ${_OCONFIG}/passwd
  grep "sas:" /etc/group >> ${_OCONFIG}/group

  sudo ${_MTOOLS}/migrate_passwd.pl ${_OCONFIG}/passwd ${_OCONFIG}/passwd.ldif
  sudo ${_MTOOLS}/migrate_group.pl ${_OCONFIG}/group ${_OCONFIG}/group.ldif

  sudo rm ${_OCONFIG}/passwd
  sudo rm ${_OCONFIG}/group
}

function mkhomedir() {
_ULIST=$(grep uid: $_REPOROOT/viya/admin/openldap/passwd.ldif | awk '{print $2}')

for user in ${_ULIST}; do
 if [ ! -d /home/${user} ]; then
   sudo mkdir /home/${user}
   sudo cp -a /etc/skel/. /home/${user}
   sudo chown -R ${user}:${user} /home/${user}
   sudo chmod -R 700 /home/${user}
 fi
done
}

# ------------------------------------------

_OCONFIG=$_REPOROOT/viya/admin/openldap
_OPATH=/etc/openldap/slapd.d/cn=config
_MTOOLS=/usr/share/migrationtools

# Install packages
sudo yum install -y openldap-* migrationtools nss-pam-ldapd

# Get the name of the host we are running on
if [ -z "${LDAP_HOST}" ]; then
    LDAP_HOST=$(hostname -f)
fi

sudo slappasswd -s ${_PASSWD}

# Update the configuration
sudo sed -i "s/olcSuffix:.*/olcSuffix: ${_BASEDN}/" ${_OPATH}/olcDatabase={2}hdb.ldif
sudo sed -i "s/olcRootDN:.*/olcRootDN: cn=admin,${_BASEDN}/" ${_OPATH}/olcDatabase={2}hdb.ldif

echo 'olcRootPW: {SSHA}s8xq3UhIbmuuNsnBCZkgltfBrBnbOMGA' | sudo tee -a ${_OPATH}/olcDatabase={2}hdb.ldif
#echo 'olcTLSCertificateFile: /etc/pki/tls/certs/awsldap.pem' | sudo tee -a ${_OPATH}/olcDatabase={2}hdb.ldif
#echo 'olcTLSCertificateKeyFile: /etc/pki/tls/certs/awsldapkey.pem' | sudo tee -a ${_OPATH}/olcDatabase={2}hdb.ldif

sudo sed -i "s/dn.base=\"cn=manager.*/dn.base=\"cn=admin,${_BASEDN}\" read  by * n/" ${_OPATH}/olcDatabase={1}monitor.ldif
sudo cp -urvf /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

# Generate the certs for TLS configuration
sudo openssl req -new -x509 -nodes -out /etc/pki/tls/certs/awsldap.pem -keyout /etc/pki/tls/certs/awsldapkey.pem -subj "/C=US/ST=North Carolina/L=Cary/O=SDE/CN=${LDAP_HOST}"

sudo chown -R ldap:ldap /etc/pki/tls/certs/awsldap*.pem

# Start/Register the service
sudo systemctl start slapd
sudo systemctl enable slapd
sudo systemctl start nslcd
sudo systemctl enable nslcd

# Add the schema
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

# Update Migration Tools
sudo sed -i "s/$DEFAULT_MAIL_DOMAIN = */$DEFAULT_MAIL_DOMAIN = "${_DOMAIN}";/" ${_MTOOLS}/migrate_common.ph
sudo sed -i "s/$DEFAULT_BASE = */$DEFAULT_BASE = "${_BASEDN}";/" ${_MTOOLS}/migrate_common.ph
sudo sed -i 's/$EXTENDED_SCHEMA = */$EXTENDED_SCHEMA = 1;/' ${_MTOOLS}/migrate_common.ph
sudo sed -i 's/$NAMINGCONTEXT{'passwd'}            = "ou=People";/$NAMINGCONTEXT{'passwd'}            = "ou=users";/' ${_MTOOLS}/migrate_common.ph
sudo sed -i 's/$NAMINGCONTEXT{'group'}             = "ou=Group";/$NAMINGCONTEXT{'group'}             = "ou=groups";/' ${_MTOOLS}/migrate_common.ph

# Insert base configuration
sudo ldapadd -H ldap://${LDAP_HOST}:389 -D "cn=admin,${_BASEDN}" -w ${_PASSWD} -f ${_OCONFIG}/base.ldif
sudo ldapadd -H ldap://${LDAP_HOST}:389 -D "cn=admin,${_BASEDN}" -w ${_PASSWD} -f ${_OCONFIG}/passwd.ldif
sudo ldapadd -H ldap://${LDAP_HOST}:389 -D "cn=admin,${_BASEDN}" -w ${_PASSWD} -f ${_OCONFIG}/group.ldif

# Setup system authentication
sudo authconfig --enableldap --enableldapauth --enablemkhomedir --ldapserver="${LDAP_HOST}" --ldapbasedn="${_BASEDN}" --update

# Add cas to /etc/passwd
_uid=`id cas | awk '{print $1}' | sed 's/[^0-9]*//g'`
_gid=`id cas | awk '{print $2}' | sed 's/[^0-9]*//g'`
echo "cas:x:${_uid}:${_gid}:cas:/home/cas:/bin/bash" | sudo tee -a /etc/passwd 1>&2

# Create user home directories
mkhomedir
