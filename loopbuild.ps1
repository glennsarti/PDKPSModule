$ErrorActionPreference = 'Continue'
# powershell -NoProfile -file loopbuild.ps1

do {
  Write-Host "."
  .\generate_module.ps1
  Start-Sleep -Seconds 5
} until (1 -eq 2)
