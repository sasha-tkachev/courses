
$FirstName = Read-Host -Prompt 'Input your first name'
$LastName = Read-Host -Prompt 'Input your last name'
$TazID = Read-Host -Prompt 'Input your TAZ-ID'
"MMN11 By $FirstName $LastName ID $TazID"  | Out-File -FilePath ".\mmn11\README.txt"
Compress-Archive -Path .\mmn11 -DestinationPath .\build\mmn11.zip
Remove-Item ".\mmn11\README.txt"