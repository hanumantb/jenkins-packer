
param(
    $OSVersion,
    $OutputDirectory,
    $DestinationVCenter,
    [int]$NumTemplates = 2,
    [Switch]$RunVersioning
)

# Set up Packer json file name based on OSVersion
$packer_file = "03-$OSVersion-vsphere.json"

# Set packer log level
$env:PACKER_LOG=2

# Set up build
# TODO: Acutally implement this. & $env:packer_exe_path build -force -var-file=".\variables-global.json" -var "name=$OSVersion" -var "output_dir=$OutputDirectory" $packer_file
Write-Host "Deploy was successfull for $OSVersion to $DestinationVCenter with Templates to keep: $NumTemplates and versioning being $RunVersioning."