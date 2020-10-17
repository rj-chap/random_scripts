# Create a file, timestomp it, create a new file, and clone the previously timestomped info

$clone_me = '.\test_file11.txt'
cmd.exe /c type nul > $clone_me
$current_times = Get-ItemProperty -Path $clone_me -Name CreationTime, LastWriteTime, LastAccessTime
Write-Host "`nNew File 1:`nOriginal timestamp:" (Get-Date -Date $current_times.CreationTime -Format "MMM dd, yyyy HH:mm:ss.fffff")
Set-ItemProperty -Path $clone_me -Name CreationTime -Value "2123-04-02 12:12:12.12345"
Set-ItemProperty -Path $clone_me -Name LastWriteTime -Value "2123-04-02 12:12:12.12345"
Set-ItemProperty -Path $clone_me -Name LastAccessTime -Value "2123-04-02 12:12:12.12345"
$new_times = Get-ItemProperty -Path $clone_me -Name CreationTime, LastWriteTime, LastAccessTime
Write-Host "Timestomped:" (Get-Date -Date $new_times.CreationTime -Format "MMM dd, yyyy HH:mm:ss.fffff")

Start-Sleep -s 2

$cloned = '.\test_file22.txt'
cmd.exe /c type nul > $cloned
$before_copy_times = Get-ItemProperty -Path $cloned -Name CreationTime, LastWriteTime, LastAccessTime
Write-Host "`nNew File 2:`nPre-clone timestamp:" (Get-Date -Date $before_copy_times.CreationTime -Format "MMM dd, yyyy HH:mm:ss.fffff")
Set-ItemProperty -Path $cloned -Name CreationTime -Value (Get-ItemProperty -Path $clone_me -Name CreationTime).CreationTime
Set-ItemProperty -Path $cloned -Name LastWriteTime -Value (Get-ItemProperty -Path $clone_me -Name LastWriteTime).LastWriteTime
Set-ItemProperty -Path $cloned -Name LastAccessTime -Value (Get-ItemProperty -Path $clone_me -Name LastAccessTime).LastAccessTime
$after_copy_times = Get-ItemProperty -Path $cloned -Name CreationTime, LastWriteTime, LastAccessTime
Write-Host "Post-clone timestamp:" (Get-Date -Date $after_copy_times.CreationTime -Format "MMM dd, yyyy HH:mm:ss.fffff")

# Create a file and timestomp its CreationTime to the time when the C:\Windows dir was created

$timestomp_me = '.\clone_precision_test_file.txt'
cmd.exe /c type nul > $timestomp_me
$new_file_times = Get-ItemProperty -Path $timestomp_me -Name CreationTime, LastWriteTime, LastAccessTime
$windows_install_datetime = Get-ItemProperty -Path C:\Windows -Name CreationTime
Set-ItemProperty -Path $timestomp_me -Name CreationTime -Value $windows_install_datetime.CreationTime
$cloned_times = Get-ItemProperty -Path $timestomp_me -Name CreationTime, LastWriteTime, LastAccessTime
Write-Host "`nWindows directory creation date:" (Get-Date -Date $windows_install_datetime.CreationTime -Format "MMM dd, yyyy HH:mm:ss.fffff")
Write-Host "`nBrand New File:`nOriginal timestamp:" (Get-Date -Date $new_file_times.CreationTime -Format "MMM dd, yyyy HH:mm:ss.fffff")
Write-Host "Timestomped to system install date: " (Get-Date -Date $cloned_times.CreationTime -Format "MMM dd, yyyy HH:mm:ss.fffff")

