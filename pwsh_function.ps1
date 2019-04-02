
Function new-pdkmodule
{
  [CmdletBinding()]
  param(
    $templateurl,
    $templateref,
    $skipinterview,
    $fullinterview,
    $license,
    $skipbundleinstall
  )

  &$env:RUBY_DIR\bin\ruby -S -- $env:RUBY_DIR\bin\pdk new module # Splat params here
<#
.DESCRIPTION

Create a new module named [module_name] using given options

.PARAMETER templateurl

Specifies the URL to the template to use when creating new modules or classes. (default: https://github.com/puppetlabs/pdk-templates)

.PARAMETER templateref

Specifies the template git branch or tag to use when creating new modules or classes.

.PARAMETER skipinterview

When specified, skips interactive querying of metadata.

.PARAMETER fullinterview

When specified, interactive querying of metadata will include all optional questions.

.PARAMETER license

Specifies the license this module is written under. This should be a identifier from https://spdx.org/licenses/. Common values are 'Apache-2.0', 'MIT', or 'proprietary'.

.PARAMETER skipbundleinstall

Do not automatically run `bundle install` after creating the module.

#>
}