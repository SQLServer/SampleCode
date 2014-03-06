# Number of Days to Retain on the Local Storage
Clear-Host;
$NumberofDaysRetention = 5;

# Location of the Backup Files
$Source = "C:\tmp2\";
$destination="C:\Temp\";
$CutOfDate = (Get-Date).AddDays(-$NumberofDaysRetention);
$Logfile = "c:\Logs\"+(get-Date).ToString("yyyyMMdd")+".log";

Function LogWrite
{
   Param ([string]$logstring)
   $CurrentTime=(get-Date).ToString('yyyy/MM/dd hh:mm:ss');
   Add-content $Logfile -value $CurrentTime`t` $logstring; 
}



# Search and Remove Full Backup Files
if ((Test-Path $Source) -eq "True")  
{  
    $count = (Get-ChildItem $Source -include *.* -recurse | ?{$_.LastWriteTime -lt $CutOfDate -and !$_.PSIsContainer}).Count  
    
    if ($count -eq $null) 
    {
        $count = 0
    }  
          
    Get-ChildItem $Source -Recurse -Include *.* | ?{$_.LastWriteTime -lt $CutOfDate -and !$_.PSIsContainer} |
        Move-Item -Force -Destination {
            $dir = $destination+"{0:yyyy\\MM\\dd}" -f $_.LastWriteTime
            $null = mkdir $dir -Force
            "$dir\$($_.Name)"
        }
    Write-Host "There were" $count "Full Backup files Move To Disk"
    $logmsg="There were   " +$count.ToString()+"   Full Backup files Move To Disk"
    LogWrite $logmsg
}  
else 
{
    Write-Host "There are no Full Backup files to be deleted";
    LogWrite "There are no Full Backup files to be deleted"
}

# Search and Remove Transaction Log Files
if ((Test-Path $Source) -eq "True")  
{  
    $count = (Get-ChildItem $Source -include *.trn -recurse | ?{$_.LastWriteTime -lt $CutOfDate -and !$_.PSIsContainer}).Count  
    
    if ($count -eq $null) 
    {
        $count = 0
    }  
          
    Get-ChildItem $Source -Recurse -Include *.trn | ?{$_.LastWriteTime -lt $CutOfDate -and !$_.PSIsContainer} |
        Move-Item -Force -Destination {
            $dir = $destination+"{0:yyyy\\MM\\dd}" -f $_.LastWriteTime
            $null = mkdir $dir -Force
            "$dir\$($_.Name)"
        }
    $logmsg="There were   " +$count.ToString()+"   Transaction Log Move To Disk"
    LogWrite $logmsg
}  
else 
{
    Write-Host "There are no Transaction Log files to be deleted";
    LogWrite "There are no Transaction Log files to be deleted";
} 
