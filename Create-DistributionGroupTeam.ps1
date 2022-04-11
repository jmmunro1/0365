# Powershell function to create a microsoft team from an exchange online distribution group.
# Author: Josh Munro

Function Create-DistributionGroupTeam {
    <#
    .Synopsis
        Ceates a new team in Microsoft Teams from an exchange online distribution group.
    .Example
        Create-DistributionGroupTeam -team Accounting -distributionGroup accounting@lbscares.org
        Creates a new team named Accounting and adds all of the users from the accounting@lbscares.org distribution group.
    #>

    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$team,
        [String]$distributionGroup
    )

    connect-microsoftteams 

    $newTeam = new-team -mailnickname $team -displayname "$team" -visibility Private

    Connect-ExchangeOnline

    $members = get-distributiongroupmember -identity $distributionGroup | select primarysmtpaddress
    $members | foreach {
        add-teamuser -groupid $newTeam.groupid -user $_.primarysmtpaddress
    }
}