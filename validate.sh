#!/bin/bash

set -euo pipefail

JENKINS_URL="http://localhost:8090"
JENKINS_CRUMB=$(curl "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
JENKINS_VALIDATE_OUTPUT=$(curl -X POST -H "${JENKINS_CRUMB}" -F "jenkinsfile=<Jenkinsfile" "${JENKINS_URL}/pipeline-model-converter/validate")
echo "${JENKINS_VALIDATE_OUTPUT}"
[[ "${JENKINS_VALIDATE_OUTPUT}" =~ "successfully validated" ]]
