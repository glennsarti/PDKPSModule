Import-Module EPS

$root = $PSScriptRoot
$outDir = Join-Path -Path $root -ChildPath 'out'

# Clean
if (Test-Path -Path $outDir) {
  Remove-Item -Path $outDir -Force -Recurse -Confirm:$false | Out-Null
}
New-Item -Path $outDir -ItemType Directory | Out-Null

# Generate the psm1
$psm1Path = Join-Path -Path $outDir -ChildPath 'PuppetDevelopmentKit.psm1'
$psd1Path = Join-Path -Path $outDir -ChildPath 'PuppetDevelopmentKit.psd1'
$json = Get-Content -Path ./pdk_command_spec.json | ConvertFrom-JSON

#TODO Get rid of the pre-json massaging

# Massage the JSON
$TextInfo = (Get-Culture).TextInfo
$json.subcommands | ForEach-Object {
  # Generate PS friendly function name
  $PSFunctionName = 'Module' # $TextInfo.ToTitleCase($_.name).replace('-','').replace('_','')
  Add-Member -InputObject $_ -MemberType NoteProperty -Name PSFunctionName -Value $PSFunctionName | Out-Null

  $_.options | ForEach-Object {
    # Generate PS friendly parameter name
    $PSParamName = $TextInfo.ToTitleCase($_.long).replace('-','').replace('_','')
    Add-Member -InputObject $_ -MemberType NoteProperty -Name PSParamName -Value $PSParamName | Out-Null
  }

  $_ | Select-Object -Expand subcommands | ForEach-Object {
    # Generate PS friendly function name
    $PSFunctionName = $TextInfo.ToTitleCase($_.name).replace('-','').replace('_','')
    Add-Member -InputObject $_ -MemberType NoteProperty -Name PSFunctionName -Value $PSFunctionName | Out-Null

    $_.options | ForEach-Object {
      # Generate PS friendly parameter name
      $PSParamName = $TextInfo.ToTitleCase($_.long).replace('-','').replace('_','')
      Add-Member -InputObject $_ -MemberType NoteProperty -Name PSParamName -Value $PSParamName | Out-Null
    }
  }
}

Invoke-EpsTemplate -Path ./pwsh_template_ps1 -Safe -Binding @{ 'json' = $json } | Out-File -FilePath $psm1Path -Encoding utf8 -Force -Confirm:$false
Invoke-EpsTemplate -Path ./pwsh_module_template_psd1 -Safe -Binding @{ 'version' = '1.10.1' } | Out-File -FilePath $psd1Path -Encoding utf8 -Force -Confirm:$false
