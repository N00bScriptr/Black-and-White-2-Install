Start-Process "msg" -ArgumentList "$env:UserName", "Please choose the folder containing Black and White 2 installation files." -Wait
Start-Sleep -Seconds "1"
Function Get-Folder($initialDirectory="$home\Downloads"){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "UserProfile"
    $foldername.SelectedPath = $initialDirectory
    if($foldername.ShowDialog() -eq "OK")    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}
$isoDir = Get-Folder
Set-Location $isoDir
$isoFile = Get-ChildItem | Where Name -like "*.iso"
$isoPath = $isoDir + "\" + $isoFile
$isoMount = Mount-DiskImage $isoPath
$isoDriveLetter = (Get-Volume | Where-Object FileSystemLabel -like "*BW2*").DriveLetter
Start-Process "$isoDriveLetter`:\arun.exe" -Wait
Start-Process "BW2Patch_v11.exe" -Wait
Start-Process "bw2patch_v12.exe" -Wait
Start-Process "B&W2 Fan Patch v1.42 Installer.exe" -Wait
$isoDismount = Dismount-DiskImage $isoPath
Start-Process "msg" -ArgumentList "$env:UserName", "Installation completed. Click OK to exit"
