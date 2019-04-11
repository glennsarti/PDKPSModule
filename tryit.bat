SETLOCAL

SET pscmd="Import-Module %~dp0PuppetDevelopmentKitV2.psm1; Get-command -Module PuppetDevelopmentKitV2; Test-PDKUnit2"
REM SET pscmd="Import-Module %~dp0out/PuppetDevelopmentKit.psd1; Get-command -Module PuppetDevelopmentKit"
mkdir tmp

pushd tmp\testmodule
REM pushd C:\Source\puppetlabs-registry\registry
REM pwsh -NoExit -Command %pscmd%
pwsh -Command %pscmd%
popd
