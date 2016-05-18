#!/bin/bash
#source build-esen.sh

# check if token is present
if [ -z "$WERCKER_CONTXT_DEPLOY_TOKEN" ]; then
  fail "Please provide a Contxt API Token"
fi

if [ -z "$WERCKER_CONTXT_DEPLOY_SERVICE_DESCRIPTOR" ]; then
  fail "Please provide a Contxt Service Descriptor"
fi

json="{
    \"tag\": \"$WERCKER_GIT_COMMIT\"
}"

# post the result to the slack webhook
RESULT=$(curl -d "$json" -H "Authorization: $WERCKER_CONTXT_DEPLOY_TOKEN" -H "Content-Type: application/json" -s "http://coordinator.api.ndustrial.io/v1/services/$WERCKER_CONTXT_DEPLOY_SERVICE_DESCRIPTOR/deploy" --output "$WERCKER_STEP_TEMP"/result.txt -w "%{http_code}")
cat "$WERCKER_STEP_TEMP/result.txt"

if [ "$RESULT" = "403" ]; then
  fail "Access denied. Check your token!"
fi


if [ "$RESULT" = "404" ]; then
  fail "Service not found."
fi