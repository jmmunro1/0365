# Get Admin Credentials
$objCreds = Get-Credential
$sharepointAdminURL = "https://lincolnbehavioral-admin.sharepoint.com"
$sharepointUserURL = "https://lincolnbehavioral-my.sharepoint.com/"
$adminUser = Read-Host "Enter the Admin account to give permissions to. Ex: TomD@lbscares.com"

# Connects a SharePoint Online global administrator to a SharePoint Online connection 
Connect-SPOService -Url $sharepointAdminURL -credential $objCreds
# Returns the SharePoint Online user that match the provided email address criteria.
$colUsers = Get-SPOUser -Site $sharepointUserURL
    

$colUsers = $colUsers.LoginName | ForEach-Object { $_.TrimEnd("lbscares.com") } | ForEach-Object { $_.TrimEnd("@") }

# ForEach OneDrive add the admin tenant as a SharePoint Online site collection administrator
$colUsers | ForEach-Object { 
    Set-SPOUser -Site $sharepointUserUrl/personal/"$_"_lbscares_com/ `
    -LoginName $adminUser -IsSiteCollectionAdmin $true 
}