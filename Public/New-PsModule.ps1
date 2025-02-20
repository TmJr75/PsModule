# Create a module using PowerShell

# New-Module -Name "PSModule" 
Function New-PsModule {



  <#
    .SYNOPSIS
    Create a new PowerShell module with a manifest file.

    .DESCRIPTION
    This function will create a new PowerShell module with a manifest file. The module will be created in the specified folder.

    .PARAMETER moduleName
    The name of the module to create.

    .PARAMETER Author
    The author of the module.

    .PARAMETER CompanyName
    The name of the company that owns the module.

    .PARAMETER PowerShellVersion
    The version of PowerShell that the module is compatible with.

    .PARAMETER PowerShellHostVersion
    The version of the PowerShell host that the module is compatible with.

    .PARAMETER FunctionsToExport
    The functions to export from the module.

    .PARAMETER CmdletsToExport
    The cmdlets to export from the module.

    .PARAMETER VariablesToExport
    The variables to export from the module.

    .PARAMETER AliasesToExport
    The aliases to export from the module.

    .PARAMETER ModuleVersion
    The version of the module.

    .PARAMETER sourceFolder
    The folder where the module will be created.

    .EXAMPLE
    New-PsModule -moduleName "MyModule" -Author "John Doe" -CompanyName "Acme Corp" -PowerShellVersion "5.1" -PowerShellHostVersion "5.1" -FunctionsToExport "*" -CmdletsToExport "*" -VariablesToExport "*" -AliasesToExport "*" -ModuleVersion 1.0.0.0 -sourceFolder "C:\Temp\"
    This example creates a new module named "MyModule" in the "C:\Temp\" folder.

    .NOTES
    File Name      : New-PsModule.ps1
    Author         : Tore Melberg
    
  #>

    [CmdletBinding()]
    Param(
        [string]$moduleName,
        [string]$Author,
        [string]$CompanyName,
        [string]$PowerShellVersion = "5.1,7.4",
        [string]$PowerShellHostVersion = "",
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




    New-Item -Path "$sourcefolder\$moduleName" -Name "$moduleName.psm1" -ItemType File -Value 'Get-ChildItem -Path $PSScriptRoot\*.ps1 -Exclude *.tests.ps1, *profile.ps1 -Recurse | 
        ForEach-Object {
	    . $_.FullName
    }' -Force

New-ModuleManifest -Path "$sourcefolder\$moduleName\$moduleName.psd1" `
    -Guid (New-Guid).guid `
    -Author $Author `
    -CompanyName $CompanyName `
    -PowerShellVersion $PowerShellVersion `
    -PowerShellHostVersion $PowerShellHostVersion `
    -FunctionsToExport $FunctionsToExport `
    -CmdletsToExport $CmdletsToExport `
    -VariablesToExport $VariablesToExport `
    -AliasesToExport $AliasesToExport `
    -RootModule ("$moduleName" + ".psm1")
}

