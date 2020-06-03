#!/bin/bash

YELLOW='\033[1;33m'
WHITE='\033[0m'
GREEN='\033[0;32m'
echo -e "${YELLOW}Enter App Version:${WHITE}"
read VERSION


PRESENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZIP_DIR=lambda_test_${VERSION}


function zipFiles {
  echo -e "${GREEN}----------Zipping up directory----------${WHITE}"
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lambda_test_${VERSION}', 'lambda_test_${VERSION}.zip'); }"
}

function createDirectories {
  echo -e "${GREEN}----------Creating zip directory and copying python files----------${WHITE}"
  mkdir "${ZIP_DIR}"
  cp app.py ${ZIP_DIR}
  cp -r src ${ZIP_DIR}
}

function cleanupDirectory {
  echo -e "${GREEN}----------Deleting original zip directory----------${WHITE}"
  rm -rf ${ZIP_DIR}
}

function installPythonDependencies {
  echo -e "${GREEN}----------Installing Python files to directory----------${WHITE}"
  UPDATED_REQUIREMENTS=$(cat requirements.txt | grep -v boto3)
  UPDATED_REQUIREMENTS=$(echo $UPDATED_REQUIREMENTS | tr '\r\n' ' ')
  pip install --target="${PRESENT_DIR}/${ZIP_DIR}" -U ${UPDATED_REQUIREMENTS}
}

function deleteExistingFolders {
  if [[ -d "$ZIP_DIR" ]]; then
    echo -e "${GREEN}----------Deleting existing zip directory: ${ZIP_DIR}----------${WHITE}"
    rm -rf ${ZIP_DIR}
  fi
}

function deleteExistingZipFile {
  if [[ -f "${ZIP_DIR}.zip" ]]; then
    echo -e "${GREEN}----------Deleting existing zip file: ${ZIP_DIR}.zip----------${WHITE}"
    rm -rf "${ZIP_DIR}.zip"
  fi
}


deleteExistingFolders
deleteExistingZipFile
createDirectories
installPythonDependencies
zipFiles
cleanupDirectory
