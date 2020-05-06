

function zipFile {
  VERSION=1.0.0
  mkdir lambda_test_${VERSION}
  cp lambda_test.py lambda_test_${VERSION}
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lambda_test_${VERSION}', 'lambda_test_${VERSION}.zip'); }"
  rm -rf lambda_test_${VERSION}
}

zipFile