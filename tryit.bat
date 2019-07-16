SETLOCAL

ECHO Generating...
powershell.exe -NoProfile -File generate_module.ps1

REM SET pscmd="Import-Module %~dp0PuppetDevelopmentKitV2.psm1; Get-command -Module PuppetDevelopmentKitV2; Test-PDKUnit2"
SET pscmd="Set-Location 'C:\Source\PDKPSModule\tmp\testmodule'; Import-Module %~dp0out/PuppetDevelopmentKit.psd1; Get-command -Module PuppetDevelopmentKit; Test-PDKUnit2"
mkdir tmp



REM pushd tmp\testmodule
REM REM pushd C:\Source\puppetlabs-registry\registry
REM REM pwsh -NoExit -Command %pscmd%
pwsh -NoExit -Command %pscmd%
REM popd

ECHO EXITED TEST BATCH
