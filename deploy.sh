
VERSION=1.0.0

function zipFiles {
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lambda_test_${VERSION}', 'lambda_test_${VERSION}.zip'); }"
}

function createDirectories {
  mkdir lambda_test_${VERSION}
  cp app.py lambda_test_${VERSION}
  cp -r src lambda_test_${VERSION}
}

function cleanupDirectory {
    rm -rf lambda_test_${VERSION}
}

createDirectories
zipFiles
cleanupDirectory