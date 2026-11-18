# ADObjectPicker

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Module Type](https://img.shields.io/badge/type-PowerShell%20Module-orange)

```Text
Author:          Holger Zimmermann | zimmermann.holger@live.de
Current Version: 2026.11.18.804
Last Update:     2026-11-18
```

An interactive Active Directory object picker for PowerShell with GUI-based forest browsing, Tier 0 highlighting and disabled-account markers.

<img width="527" height="546" alt="image" src="https://github.com/user-attachments/assets/5c85d3a8-5613-4c81-ae12-2c29e853337f" />

> **Note**
> The parameters are tailored to the author's AS2Go PowerShell module, and the icons are optimized for PowerShell 7.

## Overview

`Select-ADObject` is a PowerShell function that displays a Windows Forms dialog for browsing and selecting Active Directory objects in a forest. Child objects are loaded on demand when a node is expanded, so large forests stay responsive.

- Browse the forest hierarchy across **multiple domains**
- Select **OUs, containers, users, groups, computers, GPOs** and **domains**
- Restrict the view to the **local domain** only
- **Highlight Tier 0 objects** with a red dot (regex based, customizable)
- Mark **disabled user and computer accounts** with a red cross
- Enable or disable **user accounts** from the context menu
- **Block the selection of OUs/containers** while still browsing through them (e.g. to pick only users)
- Optionally **create new OUs** from a context menu
- Optionally show **linked GPOs** below each domain, OU or container
- Returns the **distinguished name (DN)** of the selected object

### Icon legend

| Marker | Meaning |
|--------|---------|
| Red dot (top right) | Tier 0 object (`-MarkTier0`) |
| Red cross (bottom right) | Disabled user or computer account |

Both markers can appear on the same icon.

## Project Information

- Author: Holger Zimmermann
- Module: `ADObjectPicker`
- Public command: `Select-ADObject`
- Project: [Select-ADObject on GitHub](https://github.com/HerrHozi/Select-ADObject)
- License: MIT

## Module Structure

- `ADObjectPicker.psd1`: module metadata and public exports
- `ADObjectPicker.psm1`: loads private helpers and public commands
- `Public/`: exported PowerShell commands
- `Private/`: internal helper functions
- `ChangeLog.md`: local version history

## Requirements

- Windows with a graphical environment
- PowerShell 5.1 or PowerShell 7 (Windows)
- Active Directory module for OU creation and user account actions
- Read access to the forest
- `System.Windows.Forms`, `System.Drawing` and `System.DirectoryServices` (loaded by the function)

## Installation

From the Dev folder, import the module manifest:

```powershell
Import-Module .\ADObjectPicker.psd1
```

## Usage

```powershell
# Browse the forest and select an OU, container or other object
Select-ADObject

# Pick a break glass account, highlight Tier 0 objects
Select-ADObject -MarkTier0 -IncludeUsers -Title "Select Break Glass Account"

# Only users can be selected, OUs are browsable but not selectable
Select-ADObject -IncludeUsers -BlockOUSelection -Title "Select User"

# Local domain only, users and groups included
Select-ADObject -LocalDomainOnly -IncludeUsers -IncludeGroups

# Select a domain
Select-ADObject -DomainSelectionOnly

# Allow creating new OUs via right click > New > Organizational Unit
Select-ADObject -AddOU -Title "Select Target OU"
```

The result is the DN of the selection, or `$null` if the dialog was cancelled:

```powershell
$dn = Select-ADObject -IncludeUsers -BlockOUSelection
if ($dn) { Get-ADUser -Identity $dn }
```

### Enable or disable a user account

Run `Select-ADObject -IncludeUsers`, expand the user's container, and right-click the user. Choose **Disable Account** for an enabled account or **Enable Account** for a disabled account. The action runs immediately when selected. After a successful change, the red cross on the user icon updates.

## Parameters

<details>
<summary><b>Selection Scope</b></summary>

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | String | `Select AD Object` | Text shown in the dialog title bar. |
| `LocalDomainOnly` | Switch | False | Show only the current domain instead of all domains in the forest. |
| `DomainSelectionOnly` | Switch | False | Only domains can be selected. The tree is not expanded below the domain level. |
| `BlockOUSelection` | Switch | False | OUs and containers can be browsed but not selected (OK stays disabled). Use together with `-IncludeUsers`, `-IncludeGroups`, `-IncludeComputers` or `-IncludeGPOs`. |
| `AddOU` | Switch | False | Adds a context menu to create an organizational unit below a domain, OU or container. |
| `ShowAdvanced` | Switch | False | Also show objects flagged with `showInAdvancedViewOnly`. |

</details>

<details>
<summary><b>Object Types</b></summary>

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `IncludeUsers` | Switch | False | Include user objects in the tree. Disabled users are marked with a red cross. |
| `IncludeGroups` | Switch | False | Include group objects in the tree. |
| `IncludeComputers` | Switch | False | Include computer objects in the tree. Disabled computers are marked with a red cross. |
| `IncludeGPOs` | Switch | False | Include GPO objects (`groupPolicyContainer`) in the tree. |
| `IncludeLinkedGPOs` | Switch | False | Show GPOs linked to a domain, OU or container as child entries. |

</details>

<details>
<summary><b>Security / Tier 0 Handling</b></summary>

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `MarkTier0` | Switch | False | Marks Tier 0 objects with a red dot on their icon. |
| `Tier0Regex` | String | `(?i)(^CN=Administrator,\|^OU=Domain Controllers,\|^OU=Tier\s*0\|^OU=T0)` | Regular expression matched against the DN to identify Tier 0 objects. |

</details>

## Output

| Type | Description |
|------|-------------|
| `System.String` | Distinguished name of the selected object, or `$null` if cancelled. |

## Selection rules

- The forest node and domain nodes are not selectable (except domains with `-DomainSelectionOnly`).
- With `-BlockOUSelection`, objects of class `organizationalUnit`, `container` and `builtinDomain` are not selectable.

## Security Considerations

- Browsing requires directory read permissions. Creating OUs and changing user account status require the corresponding write permissions in the target domain.
- Tier 0 detection is regex based and can be customized with `-Tier0Regex`
- Selecting an OU creation or user account action changes Active Directory.
- Stores no credentials
- Intended for administrative use

## Limitations

- Requires a GUI, not headless-compatible
- Performance depends on the size of the forest and the number of child objects per container
- The disabled marker is based on `userAccountControl` and therefore applies to users and computers only

## License

This project is licensed under the [MIT License](LICENSE).

Copyright (c) 2026 Holger Zimmermann
