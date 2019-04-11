# Puppet PDK MODULE

Uses the [EPS PowerShell module](https://www.powershellgallery.com/packages/EPS)

`generate_module.ps1` : Generates the module PSM1 and PSD1 files from the JSON UI schema

`loopbuild.ps1` : Useful when I was developing the script. It continually builds the module fromthe schema

`pwsh_module_template_psd1` : The template file to create the PSD1 file

`pwsh_template_ps1` : The template file to create the PSM1 file

Best to use PowerShell Core (6), but it'll probably work on Windows PowerShell

## To generate the module from the JSON UI data

``` powershell
PS> .\generate_module.ps1
```

## Example output

** EXPERIMENTAL - Git History will be REWRITTEN **

``` powershell

PS C:\Source\PDKPSModule\tmp\testmodule> Get-Command -Module PuppetDevelopmentKit

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        ConvertTo-PDKModule                                1.10.1     PuppetDevelopmentKit
Function        New-PDKClass                                       1.10.1     PuppetDevelopmentKit
Function        New-PDKDefinedType                                 1.10.1     PuppetDevelopmentKit
Function        New-PDKModule                                      1.10.1     PuppetDevelopmentKit
Function        New-PDKProvider                                    1.10.1     PuppetDevelopmentKit
Function        New-PDKTask                                        1.10.1     PuppetDevelopmentKit
Function        Test-PDKUnit                                       1.10.1     PuppetDevelopmentKit
Function        Update-PDKModule                                   1.10.1     PuppetDevelopmentKit
Function        Validate-PDKModule                                 1.10.1     PuppetDevelopmentKit

PS C:\Source\PDKPSModule\tmp\testmodule> Get-Help Validate-PDKModule

NAME
    Validate-PDKModule

SYNOPSIS


SYNTAX
    Validate-PDKModule [[-PeVersion] <String>] [-PuppetDev] [-List] [-Parallel] [[-PuppetVersion] <String>] [-AutoCorrect]
    [<CommonParameters>]


DESCRIPTION
    Run static analysis tests.


RELATED LINKS

REMARKS
    To see the examples, type: "get-help Validate-PDKModule -examples".
    For more information, type: "get-help Validate-PDKModule -detailed".
    For technical information, type: "get-help Validate-PDKModule -full".

PS C:\Source\PDKPSModule\tmp\testmodule> Get-Help New-PDKClass

NAME
    New-PDKClass

SYNOPSIS


SYNTAX
    New-PDKClass [[-ClassName] <String>] [<CommonParameters>]


DESCRIPTION
    Create a new class named <class_name> using given options


RELATED LINKS

REMARKS
    To see the examples, type: "get-help New-PDKClass -examples".
    For more information, type: "get-help New-PDKClass -detailed".
    For technical information, type: "get-help New-PDKClass -full".

PS C:\Source\PDKPSModule\tmp> New-PDKModule
pdk (INFO): Creating new module:

We need to create the metadata.json file for this module, so we're going to ask you 5 questions.
If the question is not applicable to this module, accept the default option shown after each question. You can modify any answers at any time by manually updating the metadata.json file.

[Q 1/5] If you have a name for your module, add it here.
This is the name that will be associated with your module, it should be relevant to the modules content.
--> testmodule

[Q 2/5] If you have a Puppet Forge username, add it here.
We can use this to upload your module to the Forge when it's complete.
--> glennsarti

[Q 3/5] Who wrote this module?
This is used to credit the module's author.
--> glennsarti

[Q 4/5] What license does this module code fall under?
This should be an identifier from https://spdx.org/licenses/. Common values are "Apache-2.0", "MIT", or "proprietary".
--> Apache-2.0

[Q 5/5] What operating systems does this module support?
Use the up and down keys to move between the choices, space to select and enter to continue.
--> Windows

Metadata will be generated based on this information, continue? Yes
pdk (INFO): Module 'testmodule' generated at path 'C:/Source/PDKPSModule/tmp/testmodule', from template 'file://C:/Program Files/Puppet Labs/DevelopmentKit/share/cache/pdk-templates.git'.
pdk (INFO): In your module directory, add classes with the 'pdk new class' command.

PS C:\Source\PDKPSModule\tmp> cd .\testmodule\

PS C:\Source\PDKPSModule\tmp\testmodule> new-pdkclass -ClassName test
pdk (INFO): Creating 'C:/Source/PDKPSModule/tmp/testmodule/manifests/test.pp' from template.
pdk (INFO): Creating 'C:/Source/PDKPSModule/tmp/testmodule/spec/classes/test_spec.rb' from template.

PS C:\Source\PDKPSModule\tmp\testmodule> new-pdkclass something
pdk (INFO): Creating 'C:/Source/PDKPSModule/tmp/testmodule/manifests/something.pp' from template.
pdk (INFO): Creating 'C:/Source/PDKPSModule/tmp/testmodule/spec/classes/something_spec.rb' from template.

PS C:\Source\PDKPSModule\tmp\testmodule> Validate-PDKModule -List
pdk (INFO): Available validators: metadata, puppet, ruby, tasks

PS C:\Source\PDKPSModule\tmp\testmodule> Test-PDKUnit
pdk (INFO): Using Ruby 2.5.1
pdk (INFO): Using Puppet 6.0.2
No examples found.
  Evaluated 0 tests in 4.389425 seconds: 0 failures, 0 pending.

PS C:\Source\PDKPSModule\tmp\testmodule> Validate-PDKModule
pdk (INFO): Running all available validators...
pdk (INFO): Using Ruby 2.5.1
pdk (INFO): Using Puppet 6.0.2
info: task-name: ./: Target does not contain any files to validate (tasks/**/*).
info: task-metadata-lint: ./: Target does not contain any files to validate (tasks/*.json).
```

### Looking at more in depth integration with PDK when using Test-PDKUnit2

Running unit tests on the puppetlabs-registry module where I injected some failures on purpose

``` text
PS> Test-PDKUnit2 -Verbose

VERBOSE: Using PDK comamand line -S -- C:\PROGRA~1\PUPPET~1\DEVELO~1\private\ruby\2.4.4\bin\pdk test unit --format=junit:C:\Users\glenn.sarti\AppData\Local\Temp\tmp14D0.tmp
WARNING: This module is compatible with an older version of PDK. Run `pdk update` to update it to your version of PDK.
VERBOSE: Using Ruby 2.5.1
VERBOSE: Using Puppet 6.0.2
VERBOSE:   Evaluated 173 tests in 44.660815 seconds: 6 failures, 8 pending.

SkippedCount : 8
StartTime    : 12/04/2019 11:24:44
TotalCount   : 173
PassedCount  : 159
Duration     : 00:01:00.0356678
ErrorCount   : 0
FailedCount  : 6
Tests        : {@{Detail=; Message=; Line=21; File=./spec/classes/mixed_default_settings_spec.rb; Result=Success;
               Name=mixed_default_settings should compile into a catalogue without dependency cycles;
               Source=rspec}, @{Detail=; Message=; Line=23; File=./spec/classes/mixed_default_settings_spec.rb;
               Result=Success; Name=mixed_default_settings should contain Registry_value[hklm\Software\foo\];
               Source=rspec}, @{Detail=; Message=; Line=24; File=./spec/classes/mixed_default_settings_spec.rb;
               Result=Success; Name=mixed_default_settings should contain Registry_value[hklm\Software\foo];
               Source=rspec}, @{Detail=; Message=; Line=16; File=./spec/defines/value_spec.rb; Result=Success;
               Name=registry::value Given a minimal resource should compile into a catalogue without dependency
               cycles; Source=rspec}...}

```

Now have a more strict object output onto the pipeline.  The `.Tests` attribute is an array of all of the tests in a structured format
