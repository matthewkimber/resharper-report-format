Function Find-Code-Inspection-Items {
    <#
    .SYNOPSIS

    Runs JetBrains' InspectCode command line tool on a specified solution or project.

    .DESCRIPTION

    Runs JetBrains' InspectCode command line tool on a specified solution or project 
    file assuming certain conventions. If a configuration file is desired to tweak 
    the default behavior of the duplicate finder you should provide a file 
    alongside your solution or project file named {MySolution}.DotSettings where
    {MySolution} matches that of the actual solution file. An example of this would
    be if my solution file was named SomeProduct.sln I would have my settings
    described in SomeProduct.DotSettings. The resulting report will be saved in
    XML and HTML with the name InspectCodeReport.xml and InspectCodeReport.html.

    .PARAMETER input

    The solution or project file to be used when inspecting code quality.

    .PARAMETER outputPath

    If you do not want the resulting report to be written in the same directory
    as your solution file you can specify that here.

    .EXAMPLE

    Perform a code inspection using all the default artifact locations.

    Find-Code-Inspection-Items c:\MySolution.sln

    .NOTES

    You must have the ReSharper Command Line Tools and XML Starlet installed in a globally
    accessible location.

    #>
    param (
        [Parameter(Mandatory=$true,Position=1)]
        [string] $input,

        [string] $outputPath = ".\"
    )

    # 1. Validate that prerequisites are there.
    # 2. Validate that the input file is there.
    # 3. Run dupFinder against the input file with the configuration file and outputPath taken into account.
}