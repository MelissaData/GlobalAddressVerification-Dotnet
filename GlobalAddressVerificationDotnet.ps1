# Name:    GlobalAddressVerificationCloudAPI
# Purpose: Execute the GlobalAddressVerificationCloudAPI program

######################### Parameters ##########################
param(
    $addressline1 = '',
    $locality = '',
    $administrativearea = '',
    $postal = '',
    $country = '', 
    $license = '',
    [switch]$quiet = $false
    )

# Uses the location of the .ps1 file 
# Modify this if you want to use 
$CurrentPath = $PSScriptRoot
Set-Location $CurrentPath
$ProjectPath = "$CurrentPath\GlobalAddressVerificationDotnet"
$BuildPath = "$ProjectPath\Build"

If (!(Test-Path $BuildPath)) {
  New-Item -Path $ProjectPath -Name 'Build' -ItemType "directory"
}

########################## Main ############################
Write-Host "`n=================== Melissa Global Address Verification Cloud API ======================`n"

# Get license (either from parameters or user input)
if ([string]::IsNullOrEmpty($license) ) {
  $license = Read-Host "Please enter your license string"
}

# Check for License from Environment Variables 
if ([string]::IsNullOrEmpty($license) ) {
  $license = $env:MD_LICENSE
}

if ([string]::IsNullOrEmpty($license)) {
  Write-Host "`nLicense String is invalid!"
  Exit
}

# Start program
# Build project
Write-Host "`n===================================== BUILD PROJECT ===================================="

dotnet publish -f="net7.0" -c Release -o $BuildPath GlobalAddressVerificationDotnet\GlobalAddressVerificationDotnet.csproj

# Run project
if ([string]::IsNullOrEmpty($addressline1) -and [string]::IsNullOrEmpty($locality) -and [string]::IsNullOrEmpty($administrativearea) -and [string]::IsNullOrEmpty($postal) -and [string]::IsNullOrEmpty($country)) {
  dotnet $BuildPath\GlobalAddressVerificationDotnet.dll --license $license 
}
else {
  dotnet $BuildPath\GlobalAddressVerificationDotnet.dll --license $license --addressline1 $addressline1 --locality $locality --administrativearea $administrativearea --postal $postal --country $country
}
