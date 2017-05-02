Function Find-Code-Duplicates {
    <#
    .SYNOPSIS

    Runs JetBrains' dupFinder command line tool on a specified solution or project.

    .DESCRIPTION

    Runs JetBrains' dupFinder command line tool on a specified solution or project 
    file assuming certain conventions. If a configuration file is desired to tweak 
    the default behavior of the duplicate finder you should provide a file 
    alongside your solution or project file named DuplicateFinder.config. The
    resulting report will be saved in XML and HTML with the name
    DuplicateFinderReport.xml and DuplicateFinderReport.html.

    .PARAMETER input

    The solution or project file to be used when finding duplicated code fragments.

    .PARAMETER config

    If you do not want to rely on convention and need to define a configuration
    file to use, you can pass one in.

    .PARAMETER outputPath

    If you do not want the resulting report to be written in the same directory
    as your solution file you can specify that here.

    .EXAMPLE

    Find duplicated code in a solution.

    Find-Code-Duplicates c:\MySolution.sln

    .NOTES

    You must have the ReSharper Command Line Tools installed in a globally
    accessible location.

    #>
    param (
        [Parameter(Mandatory=$true,Position=1)]
        [string] $input,

        [string] $config = "DuplicateFinder.config",

        [string] $outputPath = ".\"
    )

    # 1. Validate that prerequisites are there.
    # 2. Validate that the input file is there.
    # 3. Run dupFinder against the input file with the configuration file and outputPath taken into account.
}