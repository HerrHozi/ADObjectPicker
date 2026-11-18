# Root module for ADObjectPicker.
# Load internal helpers before the public commands that use them.
$PrivateFunctions = @(Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Filter '*.ps1' -File | Sort-Object Name)
$PublicFunctions = @(Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1' -File | Sort-Object Name)

foreach ($File in $PrivateFunctions) {
    . $File.FullName
}

foreach ($File in $PublicFunctions) {
    . $File.FullName
}

Export-ModuleMember -Function $PublicFunctions.BaseName