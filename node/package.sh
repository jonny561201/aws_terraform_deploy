#!/bin/bash

YELLOW='\033[1;33m'
WHITE='\033[0m'
GREEN='\033[0;32m'

PRESENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZIP_DIR=lambda_node


function zipFiles {
  echo -e "${GREEN}----------Zipping up directory----------${WHITE}"
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('${ZIP_DIR}', '${ZIP_DIR}.zip'); }"
}

function createDirectories {
  echo -e "${GREEN}----------Creating zip directory and copying node files----------${WHITE}"
  mkdir -p ${ZIP_DIR}
  cp package.json ${ZIP_DIR}
  cp index.js ${ZIP_DIR}
  cp -r src ${ZIP_DIR}
  cp babel.config.js ${ZIP_DIR}
}

function cleanupDirectory {
  echo -e "${GREEN}----------Deleting original zip directory----------${WHITE}"
  rm -rf ${ZIP_DIR}
}

function installNodeDependencies {
  echo -e "${GREEN}----------Installing Node files to directory----------${WHITE}"
  npm --prefix ./${ZIP_DIR} install ./${ZIP_DIR} --only=prod
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
installNodeDependencies
zipFiles
cleanupDirectory
