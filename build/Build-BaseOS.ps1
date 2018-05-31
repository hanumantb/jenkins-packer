param(
    $OSVersion,
    $OutputDirectory = "D:\PackerBuilds\"
)

# .source Helper-Functions
. ./Helper-Functions.ps1

Write-Host $PSScriptRoot

# Set up Packer json file name based on OSVersion
$packer_file = "01-$OSVersion-base.json"

# Set packer log level
$env:PACKER_LOG=2

# Set up build
# & $env:packer_exe_path build -force -var-file=".\variables-global.json" -var "name=$OSVersion" -var "output_dir=$OutputDirectory" $packer_file

# Sleep to test waiting in jenkins
$random = Get-Random -Minimum 5 -Maximum 15
Write-Host "Sleeping for $random seconds"
Start-Sleep -Seconds $random

Write-Host "Base OS was successfull for $OSVersion."

# Set last status
Set-LastBuild -OSVersion $OSVersion -Status SUCCEEDED -BuildDirectory $OutputDirectory -Task BuildOS