# Powershell function for a simple search and removal of e-mails from all mailboxes in office 365.
# Author: Josh Munro

Function Remove-Message {

# Required paramaters for naming the search, setting the from parameter, and the subject parameter.
[CmdletBinding()]
param(
[String]$Searchname, [String]$from, [String]$Subject)

connect-ippssession

#Starts the search using the input parameters.
$Search=New-ComplianceSearch -Name $SearchName -ExchangeLocation All -ContentMatchQuery "(from:$($from)) and (Subject:$($subject))"
Start-ComplianceSearch -Identity $Search.Identity

$maxRetries = 20; $retrycount = 0; $completed = $false

#Checks whether the search is finished or not. If it is then it displays the results of the search. If not then it retries every 30 seconds.
while (-not $completed) {
    $status = get-compliancesearch -identity $SearchName | select status
    if ($status -match "Completed") {
        $completed = $true
        get-compliancesearch -identity $searchname | select successresults | fl
    }
    else {
        if ($retrycount -ge $maxRetries) {
            throw "Search has not completed after reaching maximum retries"
        } else {
            write-host "Search has not completed, retrying in 30 seconds"
            start-sleep '30'
            $retrycount++
        }
    }
}
$maxRetries = 20; $retrycount = 0; $completed = $false
$delete = read-host "Do you want to delete the e-mails Y/N?"

#If you say yes to delete then it attempts to delete the e-mails from all mailboxes. 
#If the purge is complete it displays the results otherwise it checks the status every 30 seconds.

If ($delete = "Y") {
    New-ComplianceSearchAction -searchname $SearchName -purge -purgetype harddelete
        while (-not $completed) {
            $status = get-compliancesearchaction -identity $SearchName'_purge' | select status
            if ($status -match "Completed") {
                $completed = $true
                get-compliancesearchaction -identity $SearchName'_purge' | select results | fl
            }
            else {
                if ($retrycount -ge $maxRetries) {
                    throw "Search has not completed after reaching maximum retries"
            } else {
                    write-host "Purge has not completed, checking status in 30 seconds"
                    start-sleep '30'
                    $retrycount++
            }
        }
    }
}
}

