#!/bin/bash

VERSION=1.0.0
WHITE='\033[0m'
GREEN='\033[0;32m'
PRESENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZIP_DIR=lambda_test_


function zipFiles {
  echo -e "${GREEN}Zipping up directory${WHITE}"
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lambda_test_${VERSION}', 'lambda_test_${VERSION}.zip'); }"
}

function createDirectories {
  echo -e "${GREEN}Creating zip directory and copying python files${WHITE}"
  mkdir "${ZIP_DIR}${VERSION}"
  cp app.py lambda_test_${VERSION}
  cp -r src lambda_test_${VERSION}
}

function cleanupDirectory {
  echo -e "${GREEN}Deleting original zip directory${WHITE}"
  rm -rf lambda_test_${VERSION}
}

function installPythonDependencies {
  echo -e "${GREEN}Installing Python files to directory${WHITE}"
  UPDATED_REQUIREMENTS=$(cat requirements.txt | grep -v boto3)
  UPDATED_REQUIREMENTS=$(echo $UPDATED_REQUIREMENTS | tr '\r\n' ' ')
  pip install --target="${PRESENT_DIR}/${ZIP_DIR}${VERSION}" -U ${UPDATED_REQUIREMENTS}
}


# TODO: delete directory if exists
createDirectories
installPythonDependencies
zipFiles
cleanupDirectory
