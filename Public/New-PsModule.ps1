# Create a module using PowerShell

# New-Module -Name "PSModule" 
Function New-PsModule {

    [CmdletBinding()]
    Param(
        [string]$moduleName,
        [string]$Author,
        [string]$CompanyName,
        [string]$PowerShellVersion,
        [string]$FunctionsToExport = "*",
        [string]$CmdletsToExport = "*", 
        [string]$VariablesToExport = "*", 
        [string]$AliasesToExport="*",
        [version]$ModuleVersion = 1.0.0.0,
        $sourceFolder
        
    )

    # $sourceFolder = "C:\Temp\$moduleName"

$tempFolders = "Public","Private","SupportCommands"

Foreach ($f in $tempFolders) {
    if (Test-Path -Path $sourceFolder\$moduleName\$f) {
        "Path Exists: $f"
    }
    else {
        "Path does not exist: $f"
        New-Item -Path $sourceFolder\$modulename\$f -ItemType Directory
        New-Item -ItemType File -Path $sourceFolder\$modulename\$f -Name readme.md -Value "This readme is for the $f folder, $f related scripts and tools will be hosted here."
    }
}




    New-Item -Path "$sourcefolder\$moduleName" -Name "$moduleName.ps1" -ItemType File -Value 'Get-ChildItem -Path $PSScriptRoot\*.ps1 -Exclude *.tests.ps1, *profile.ps1 -Recurse | 
        ForEach-Object {
	    . $_.FullName
    }' -Force

New-ModuleManifest -Path "$sourcefolder\$moduleName\$moduleName.psd1" `
    -Guid (New-Guid).guid `
    -Author $Author `
    -CompanyName $CompanyName `
    -PowerShellVersion $PowerShellVersion `
    -FunctionsToExport $FunctionsToExport `
    -CmdletsToExport $CmdletsToExport `
    -VariablesToExport $VariablesToExport `
    -AliasesToExport $AliasesToExport
}

