$t = get-msoluser | select userprincipalname -expand licenses
$t | select userprincipalname, accountskuid | where {$_.accountskuid -like '*EMS*'} | sort userprincipalname