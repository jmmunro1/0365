install-module -name MicrosoftTeams
import-module -name MicrosoftTeams

connect-microsoftteams 

$team = "Managers"

$group = new-team -mailnickname $team -displayname "$team" -visibility Private

Connect-ExchangeOnline

$members = get-distributiongroupmember -identity $team@lbscares.com | select primarysmtpaddress
$members | foreach {add-teamuser -groupid $group.groupid -user $_.primarysmtpaddress}