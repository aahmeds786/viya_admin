#!/bin/bash

export HOST=localhost
export CODE=$(ls -tr /var/log/sas/viya/saslogon/default/sas-saslogon_* | tail -n1 | grep '.log$' | xargs grep 'sasboot' | cut -d'=' -f2)
[ -n "$CODE" ] # fail if no value is found
echo $CODE

## make the first request, this expands the link
curl http://${HOST}/SASLogon/reset_password?code=${CODE} -c cookies -o output

## get a few things out of the output to use in the next request
export CSRF_TOKEN=$(grep 'name="_csrf"' output | cut -f 6 -d '"')
export NEW_CODE=$(grep 'name="code"' output | cut -f 6 -d '"')
      
echo CSRF_TOKEN=$CSRF_TOKEN
echo NEW_CODE=$NEW_CODE
#curl -f --cookie cookies http://${HOST}/SASLogon/reset_password.do -H "Content-Type: application/x-www-form-urlencoded" -d "code=${NEW_CODE}&email=none" -d 'password={{sasboot_pw|b64decode|urlencode}}' -d 'password_confirmation={{sasboot_pw|b64decode|urlencode}}' -d "_csrf=${CSRF_TOKEN}"
