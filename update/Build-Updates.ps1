
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
Write-Host "Sleeping for 15 seconds"
Start-Sleep -Seconds 15

Write-Host "Updates were successfull for $OSVersion to $OutputDirectory"