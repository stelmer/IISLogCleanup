[CmdletBinding()]
param (
	[string]$Logpath='C:\inetpub\logs'
	)

$maxDaystoKeep = -30 

$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputPath = "$myDir\IISLogsCleanup_$env:COMPUTERNAME.log"
  
If (!(Test-path -Path $LogPath)) {
    Add-Content $outputPath -Value "Log directory does not exist, exiting." 
    Write-Output "Log directory does not exist, exiting." 
    Return
    }

$itemsToDelete = dir $LogPath -Recurse -File *.log | Where LastWriteTime -lt ((get-date).AddDays($maxDaystoKeep)) 

cd $LogPath

if ($itemsToDelete.Count -gt 0){ 
    ForEach ($item in $itemsToDelete){ 
        "$($item.BaseName) is older than $((get-date).AddDays($maxDaystoKeep)) and will be deleted" | Add-Content $outputPath 
        Get-item $item.Fullname | Remove-Item -Verbose 
    } 
} ELSE { 
    "No items to be deleted today $($(Get-Date).DateTime)"  | Add-Content $outputPath 
} 

Add-Content $outputPath -Value "Clean up of log files older than $((get-date).AddDays($maxDaystoKeep)) completed..." 	
Write-Output "Clean up of log files older than $((get-date).AddDays($maxDaystoKeep)) completed..." 
