@{
    RootModule           = 'ADObjectPicker.psm1'
    ModuleVersion        = '2026.11.18.817'
    GUID                 = 'ce4ff236-1d92-4cb6-b922-a2641e35bab5'
    Author               = 'Holger Zimmermann | zimmermann.holger@live.de'
    CompanyName          = 'Community'
    Copyright            = 'License: MIT | Copyright (c) 2026 Holger Zimmermann'
    Description          = 'Windows Forms picker for browsing Active Directory forests and selecting objects by distinguished name. Supports users, groups, computers, OUs, containers, domains and Group Policy Objects, with optional Tier 0 highlighting.'
    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    FunctionsToExport    = @('Select-ADObject')
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()

    PrivateData = @{
        PSData = @{
            LastUpdate = '2026-11-18'
            Tags         = @('ActiveDirectory', 'LDAP', 'Windows', 'WindowsForms', 'GUI', 'GroupPolicy', 'Tier0', 'PSEdition_Desktop', 'PSEdition_Core')
            ProjectUri   = 'https://github.com/HerrHozi/Select-ADObject'
            LicenseUri   = 'https://github.com/HerrHozi/Select-ADObject/blob/main/LICENSE'
            ReleaseNotes = '2026.11.15.744 - Initial ADObjectPicker release with the Select-ADObject function.'

        }
    }
}
