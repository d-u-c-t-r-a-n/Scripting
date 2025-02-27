Import-Module ActiveDirectory
Import-Module ImportExcel

$filePath = "users.xlsx"

$users = Import-Excel -Path $filePath

foreach ($user in $users){
    Add-ADGroupMember -Identity $user.GroupName -Members $user.UserName
}