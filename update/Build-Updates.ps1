# .source Helper-Functions
. ../Helper-Functions.ps1

param(
    $OSVersion,
    $OutputDirectory
)

# Set up Packer json file name based on OSVersion
$packer_file = "02-$OSVersion-updates.json"

# Set packer log level
$env:PACKER_LOG=2

# Set up build
# TODO: Acutally implement this. & $env:packer_exe_path build -force -var-file=".\variables-global.json" -var "name=$OSVersion" -var "output_dir=$OutputDirectory" $packer_file

# Sleep to test waiting in jenkins
$random = Get-Random -Minimum 5 -Maximum 15
Write-Host "Sleeping for $random seconds"
Start-Sleep -Seconds $random

Write-Host "Updates were successfull for $OSVersion to $OutputDirectory"

# Set last status
Set-LastBuild -OSVersion $OSVersion -Status SUCCEEDED -BuildDirectory $OutputDirectory -Task Updates