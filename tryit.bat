SETLOCAL

SET pscmd="Import-Module %~dp0out/PuppetDevelopmentKit.psd1; Get-command -Module PuppetDevelopmentKit"
mkdir tmp

pushd tmp
pwsh -NoExit -Command %pscmd%
popd
