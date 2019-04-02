# Puppet PDK MODULE

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
