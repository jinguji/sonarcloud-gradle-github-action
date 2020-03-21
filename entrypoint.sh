#!/bin/bash

set -eu

SONAR_HOST_URL="${SONAR_HOST_URL:-"https://sonarcloud.io"}"
SONAR_ORGANIZATION="${SONAR_ORGANIZATION:-"${GITHUB_REPOSITORY%/*}"}"
SONAR_PROJECT_KEY="${SONAR_PROJECT_KEY:-"${GITHUB_REPOSITORY/\//_}"}"
SONAR_TOKEN="${SONAR_TOKEN:?}"
GRADLE_CLI_OPTS="${GRADLE_CLI_OPTS:-""}"
GRADLE_BEFORE_TASK="${GRADLE_BEFORE_TASK:-""}"
GRADLE_AFTER_TASK="${GRADLE_AFTER_TASK:-""}"
TASKS="${GRADLE_BEFORE_TASK} sonarqube ${GRADLE_AFTER_TASK}"
echo ::add-mask::"${SONAR_TOKEN}"

if [ -e ./gradlew ]; then
  GRADLE_PATH=./gradlew
elif command -v gradle; then
  GRADLE_PATH="$(command -v gradle)"
else
  echo "gradle(w) not found."
  exit 1
fi

# string to array
IFS=', ' read -r -a GRADLE_CLI_OPTS <<< "${GRADLE_CLI_OPTS}"
IFS=', ' read -r -a TASKS <<< "${TASKS}"

case "${GITHUB_EVENT_NAME}" in
  "push")
    "${GRADLE_PATH}" "${TASKS[@]}" "${GRADLE_CLI_OPTS[@]}" \
      -Dsonar.host.url="${SONAR_HOST_URL}" \
      -Dsonar.organization="${SONAR_ORGANIZATION}" \
      -Dsonar.projectKey="${SONAR_PROJECT_KEY}" \
      -Dsonar.login="${SONAR_TOKEN}" \
      -Dsonar.branch.name="${GITHUB_REF##*/}"
    ;;

  "pull_request")
    "${GRADLE_PATH}" "${TASKS[@]}" "${GRADLE_CLI_OPTS[@]}" \
      -Dsonar.host.url="${SONAR_HOST_URL}" \
      -Dsonar.organization="${SONAR_ORGANIZATION}" \
      -Dsonar.projectKey="${SONAR_PROJECT_KEY}" \
      -Dsonar.login="${SONAR_TOKEN}" \
      -Dsonar.pullrequest.provider=GitHub \
      -Dsonar.pullrequest.github.repository="${GITHUB_REPOSITORY}" \
      -Dsonar.pullrequest.key="$(jq -r ".number" < "${GITHUB_EVENT_PATH}")"
    ;;

  *)
    echo "Don't spport event: ${GITHUB_EVENT_NAME}"
    ;;

esac
