param(
    $OSVersion,
    $OutputDirectory = "D:\PackerBuilds\"
)
# .source Helper-Functions
. ./Helper-Functions.ps1

Write-Host "Current directory is: $((Get-Location).path)"

# Set up Packer json file name based on OSVersion
$packer_file = "01-$OSVersion-base.json"

# Set packer log level
$env:PACKER_LOG=2

# Set up build
& $env:PACKER_EXE_PATH build -force -var-file="packer/variables-global.json" -var "name=$OSVersion" -var "output_dir=$OutputDirectory" "packer/$packer_file"

if($LastExitCode -eq 0) { # Run was successful
    Write-Host "Base OS was successfull for $OSVersion."
    $status = "SUCCEEDED"
} else {
    Write-Host "Base OS for $OSVersion FAILED."
    $status = "FAILED"
}
Set-LastBuild -OSVersion $OSVersion -Status $status -BuildDirectory $OutputDirectory -Task BuildOS
