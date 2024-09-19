# Enable Remote Desktop
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0

# Allow RDP through the Windows Firewall
New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow

# Optionally, you can also enable Network Level Authentication (NLA)
# Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'UserAuthentication' -Value 1

Write-Host "Remote Desktop has been enabled and firewall rule has been created."
