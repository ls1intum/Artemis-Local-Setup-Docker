#!/bin/bash

CHANGED_DIRS=$(git diff-tree --no-commit-id --name-only -r ${GITHUB_SHA} -m '*Dockerfile' '*RELEASE' | xargs -I {} dirname {} | uniq)  # Only matches, if `Dockerfile` or `RELEASE` is changed!
echo -n "Changes in directories: "
echo $CHANGED_DIRS

MATRIX_BASE_INCLUDE=""
MATRIX_VARIANTS_INCLUDE=""

for DIR in ${CHANGED_DIRS}; do
    if [[ -f "${DIR}/RELEASE" ]]; then
        DO_BUILD=$(grep "BUILD=" "${DIR}"/RELEASE | awk -F '=' '{ print $2}')
        if [[ "${DO_BUILD}" != "yes" ]]; then
            echo "Skipping ${DIR} because BUILD is not set to yes."
        elif [[ "${DIR}" != *"bamboo-c"* && "${DIR}" != *"bamboo-swift"* && "${DIR}" != *"jenkins-swift"* ]]; then # Handle C & Swift different.
            NAME=$DIR
            VERSION=$(grep "VERSION=" "${NAME}"/RELEASE | awk -F '=' '{ print $2}')
            MATRIX_BASE_INCLUDE+="{\"name\": \"${NAME}\", \"version\": \"${VERSION}\"}"
        elif [[ "${DIR}" = *"bamboo-"* || "${DIR}" = *"jenkins-swift"* ]]; then
            NAME=$(echo ${DIR} | awk -F '/' '{ print $2}')
            VERSION=$(grep "VERSION=" "${DIR}"/RELEASE | awk -F '=' '{ print $2}')
            PLATFORMS=$(grep "PLATFORMS=" "${DIR}"/RELEASE | awk -F '=' '{ print $2}')
            MATRIX_VARIANTS_INCLUDE+="{\"name\": \"${NAME}\", \"version\": \"${VERSION}\", \"platforms\": \"${PLATFORMS}\"}"
        fi
    else
        echo "Skipping directory \"${DIR}\" because it does not contain a RELEASE file."
    fi
done

SPLIT='}, {'
MATRIX_BASE_INCLUDE="[${MATRIX_BASE_INCLUDE//\}\{/$SPLIT}]"
MATRIX_BASE="{\"include\": ${MATRIX_BASE_INCLUDE}}"

MATRIX_VARIANTS_INCLUDE="[${MATRIX_VARIANTS_INCLUDE//\}\{/$SPLIT}]"
MATRIX_VARIANTS="{\"include\": ${MATRIX_VARIANTS_INCLUDE}}"

echo "Matrix for base images: ${MATRIX_BASE}"
echo "Matrix in directories for variants images: ${MATRIX_VARIANTS}"

BUILD_BASE_IMAGES="no"
if [[ "${MATRIX_BASE_INCLUDE}" != "[]" ]]; then
    BUILD_BASE_IMAGES="yes"
fi

BUILD_VARIANTS="no"
if [[ "${MATRIX_VARIANTS_INCLUDE}" != "[]" ]]; then
    BUILD_VARIANTS="yes"
fi

echo "::set-output name=matrix::${MATRIX_BASE}"
echo "::set-output name=matrix_variants::${MATRIX_VARIANTS}"
echo "::set-output name=build_base_images::${BUILD_BASE_IMAGES}"
echo "::set-output name=build_variants::${BUILD_VARIANTS}"
