# This is Windows Only right now
if (($PSVersionTable.PSEdition -eq 'Desktop') -or
    (($PSVersionTable.PSEdition -eq 'Core') -and $IsWindows)) {
  $fso = New-Object -ComObject Scripting.FileSystemObject

  $env:DEVKIT_BASEDIR = (Get-ItemProperty -Path "HKLM:\Software\Puppet Labs\DevelopmentKit").RememberedInstallDir64
  # Windows API GetShortPathName requires inline C#, so use COM instead
  $env:DEVKIT_BASEDIR = $fso.GetFolder($env:DEVKIT_BASEDIR).ShortPath
  $env:RUBY_DIR       = "$($env:DEVKIT_BASEDIR)\private\ruby\2.4.4"
  $env:SSL_CERT_FILE  = "$($env:DEVKIT_BASEDIR)\ssl\cert.pem"
  $env:SSL_CERT_DIR   = "$($env:DEVKIT_BASEDIR)\ssl\certs"
  # Disable the spinner
  $env:PDK_FRONTEND   = 'noninteractive'

  function Invoke-PDK($PDKArgs) {
    if ($DebugPreference -ne 'SilentlyContinue') { $PDKArgs += @('--debug') }
    Write-Verbose "Using PDK comamand line $($PDKArgs -join ' ')"

    if ($env:ConEmuANSI -eq 'ON') {
      &$env:RUBY_DIR\bin\ruby -S -- $env:RUBY_DIR\bin\pdk $PDKArgs
    } else {
      &$env:DEVKIT_BASEDIR\private\tools\bin\ansicon.exe $env:RUBY_DIR\bin\ruby -S -- $env:RUBY_DIR\bin\pdk $PDKArgs
    }
  }

} else {
  Throw 'The PDK module is not supported on this platform yet'
  return
}

<#
.DESCRIPTION
Convert an existing module to be compatible with the PDK.

.PARAMETER TemplateUrl
Specifies the URL to the template to use when creating new modules or classes. (default: https://github.com/puppetlabs/pdk-templates)

.PARAMETER FullInterview
When specified, interactive querying of metadata will include all optional questions.

.PARAMETER Noop
Do not convert the module, just output what would be done.

.PARAMETER TemplateRef
Specifies the template git branch or tag to use when creating new modules or classes.

.PARAMETER Force
Convert the module automatically, with no prompts.

.PARAMETER SkipInterview
When specified, skips interactive querying of metadata.
#>
Function ConvertTo-PDKModule
{
  [CmdletBinding()]
  param(
    [String] $TemplateUrl,

    [Switch] $FullInterview,

    [Switch] $Noop,

    [String] $TemplateRef,

    [Switch] $Force,

    [Switch] $SkipInterview
  )

  $args = @('convert')
  if (![string]::IsNullOrEmpty($TemplateUrl)) { $args += @('--template-url', $TemplateUrl )}
  if ($FullInterview) { $args += @('--full-interview') }
  if ($Noop) { $args += @('--noop') }
  if (![string]::IsNullOrEmpty($TemplateRef)) { $args += @('--template-ref', $TemplateRef )}
  if ($Force) { $args += @('--force') }
  if ($SkipInterview) { $args += @('--skip-interview') }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function ConvertTo-PDKModule

<#
.DESCRIPTION
Create a new class named <class_name> using given options

.PARAMETER ClassName
The specified class_name
#>
Function New-PDKClass
{
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [String] $ClassName
  )

  $args = @('new', 'class')
  if (![string]::IsNullOrEmpty($ClassName)) { $args += $ClassName }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function New-PDKClass

<#
.DESCRIPTION
Create a new defined type named <name> using given options

.PARAMETER Name
The specified name
#>
Function New-PDKDefinedType
{
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [String] $Name
  )

  $args = @('new', 'defined_type')
  if (![string]::IsNullOrEmpty($Name)) { $args += $Name }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function New-PDKDefinedType

<#
.DESCRIPTION
Create a new module named [module_name] using given options

.PARAMETER TemplateUrl
Specifies the URL to the template to use when creating new modules or classes. (default: https://github.com/puppetlabs/pdk-templates)

.PARAMETER FullInterview
When specified, interactive querying of metadata will include all optional questions.

.PARAMETER TemplateRef
Specifies the template git branch or tag to use when creating new modules or classes.

.PARAMETER License
Specifies the license this module is written under. This should be a identifier from https://spdx.org/licenses/. Common values are 'Apache-2.0', 'MIT', or 'proprietary'.

.PARAMETER SkipInterview
When specified, skips interactive querying of metadata.

.PARAMETER SkipBundleInstall
Do not automatically run `bundle install` after creating the module.
#>
Function New-PDKModule
{
  [CmdletBinding()]
  param(
    [String] $TemplateUrl,

    [Switch] $FullInterview,

    [String] $TemplateRef,

    [String] $License,

    [Switch] $SkipInterview,

    [Switch] $SkipBundleInstall
  )

  $args = @('new', 'module')
  if (![string]::IsNullOrEmpty($TemplateUrl)) { $args += @('--template-url', $TemplateUrl )}
  if ($FullInterview) { $args += @('--full-interview') }
  if (![string]::IsNullOrEmpty($TemplateRef)) { $args += @('--template-ref', $TemplateRef )}
  if (![string]::IsNullOrEmpty($License)) { $args += @('--license', $License )}
  if ($SkipInterview) { $args += @('--skip-interview') }
  if ($SkipBundleInstall) { $args += @('--skip-bundle-install') }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function New-PDKModule

<#
.DESCRIPTION
[experimental] Create a new ruby provider named <name> using given options

.PARAMETER Name
The specified name
#>
Function New-PDKProvider
{
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [String] $Name
  )

  $args = @('new', 'provider')
  if (![string]::IsNullOrEmpty($Name)) { $args += $Name }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function New-PDKProvider

<#
.DESCRIPTION
Create a new task named <name> using given options

.PARAMETER Name
The specified name

.PARAMETER Description
A short description of the purpose of the task
#>
Function New-PDKTask
{
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [String] $Name,

    [String] $Description
  )

  $args = @('new', 'task')
  if (![string]::IsNullOrEmpty($Description)) { $args += @('--description', $Description )}
  if (![string]::IsNullOrEmpty($Name)) { $args += $Name }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function New-PDKTask

<#
.DESCRIPTION
Run unit tests.

.PARAMETER PeVersion
Puppet Enterprise version to run tests or validations against.

.PARAMETER CleanFixtures
Clean up downloaded fixtures after the test run.

.PARAMETER PuppetDev
When specified, PDK will validate or test against the current Puppet source from github.com. To use this option, you must have network access to https://github.com.

.PARAMETER List
List all available unit test files.

.PARAMETER Tests
Specify a comma-separated list of unit test files to run.

.PARAMETER PuppetVersion
Puppet version to run tests or validations against.

.PARAMETER Parallel
Run unit tests in parallel.
#>
Function Test-PDKUnit
{
  [CmdletBinding()]
  param(
    [String] $PeVersion,

    [Switch] $CleanFixtures,

    [Switch] $PuppetDev,

    [Switch] $List,

    [String] $Tests,

    [String] $PuppetVersion,

    [Switch] $Parallel
  )

  $args = @('test', 'unit')
  if (![string]::IsNullOrEmpty($PeVersion)) { $args += @('--pe-version', $PeVersion )}
  if ($CleanFixtures) { $args += @('--clean-fixtures') }
  if ($VerbosePreference -eq 'Continue') { $args += '--verbose' }
  if ($PuppetDev) { $args += @('--puppet-dev') }
  if ($List) { $args += @('--list') }
  if (![string]::IsNullOrEmpty($Tests)) { $args += @('--tests', $Tests )}
  if (![string]::IsNullOrEmpty($PuppetVersion)) { $args += @('--puppet-version', $PuppetVersion )}
  if ($Parallel) { $args += @('--parallel') }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function Test-PDKUnit

<#
.DESCRIPTION
Update a module that has been created by or converted for use by PDK.

.PARAMETER Noop
Do not update the module, just output what would be done.

.PARAMETER Force
Update the module automatically, with no prompts.

.PARAMETER TemplateRef
Specifies the template git branch or tag to use when creating new modules or classes.
#>
Function Update-PDKModule
{
  [CmdletBinding()]
  param(
    [Switch] $Noop,

    [Switch] $Force,

    [String] $TemplateRef
  )

  $args = @('update')
  if ($Noop) { $args += @('--noop') }
  if ($Force) { $args += @('--force') }
  if (![string]::IsNullOrEmpty($TemplateRef)) { $args += @('--template-ref', $TemplateRef )}

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function Update-PDKModule

<#
.DESCRIPTION
Run static analysis tests.

.PARAMETER PeVersion
Puppet Enterprise version to run tests or validations against.

.PARAMETER PuppetDev
When specified, PDK will validate or test against the current Puppet source from github.com. To use this option, you must have network access to https://github.com.

.PARAMETER List
List all available validators.

.PARAMETER Parallel
Run validations in parallel.

.PARAMETER PuppetVersion
Puppet version to run tests or validations against.

.PARAMETER AutoCorrect
Automatically correct problems where possible.
#>
Function Validate-PDKModule
{
  [CmdletBinding()]
  param(
    [String] $PeVersion,

    [Switch] $PuppetDev,

    [Switch] $List,

    [Switch] $Parallel,

    [String] $PuppetVersion,

    [Switch] $AutoCorrect
  )

  $args = @('validate')
  if (![string]::IsNullOrEmpty($PeVersion)) { $args += @('--pe-version', $PeVersion )}
  if ($PuppetDev) { $args += @('--puppet-dev') }
  if ($List) { $args += @('--list') }
  if ($Parallel) { $args += @('--parallel') }
  if (![string]::IsNullOrEmpty($PuppetVersion)) { $args += @('--puppet-version', $PuppetVersion )}
  if ($AutoCorrect) { $args += @('--auto-correct') }

  Invoke-PDK -PDKArgs $args
}
Export-ModuleMember -Function Validate-PDKModule



