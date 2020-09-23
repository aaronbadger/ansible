# Specify Below User Data on EC2 Launch in AWS
# These commands can also be run post EC2 Launch to Install Ansible

---
openSUSE Leap 15.2

#!/bin/bash
zypper addrepo https://download.opensuse.org/repositories/openSUSE:Leap:15.2/standard/openSUSE:Leap:15.2.repo
zypper refresh
zypper install ansible

---
Ubuntu 18.04

#!/bin/bash
apt update
apt install software-properties-common -y
apt-add-repository --yes --update ppa:ansible/ansible
apt install ansible -y

---
Windows Server 2019

<powershell>
New-Item -Path "C:\Program Files" -Name "OpenSSH" -ItemType "directory"
Invoke-WebRequest https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.1.0.0p1-Beta/OpenSSH-Win64.zip -OutFile "C:\Program Files\OpenSSH\OpenSSH-Win64_Symbols.zip"
Expand-Archive -Path "C:\Program Files\OpenSSH\OpenSSH-Win64_Symbols.zip" -DestinationPath "C:\Program Files\OpenSSH"
powershell.exe -ExecutionPolicy Bypass -File "C:\Program Files\OpenSSH\OpenSSH-Win64\install-sshd.ps1"
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
net start sshd
Set-Service sshd -StartupType Automatic
net start ssh-agent
Set-Service ssh-agent -StartupType Automatic
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
$sshd_config = Get-Content -Path 'C:\ProgramData\ssh\sshd_config'
$modified_sshd_config = $sshd_config -replace '#PubkeyAuthentication', 'PubkeyAuthentication' -replace 'Match Group administrators', '#Match Group administrators' -replace '        AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', '#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys'
$modified_sshd_config | Set-Content -Path 'C:\ProgramData\ssh\sshd_config'
New-Item -Path "C:\Users\Administrator" -Name ".ssh" -ItemType "directory"
New-Item -Path "C:\Users\Administrator\.ssh" -Name "authorized_keys" -ItemType "file" -Value "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB/HgVDOHPhTJtFE/GQF08o0sGJZ9ZwXzMKAL9c+hobGrVx2Sdg5LGUugDr3OP7ZaiwxcvRcu2JKS2zMn1+RLtkF6UIzK+7Ls9nI7qIfJ1k6+vzWqIcF7sCJIUy9Q+pWirViwqi9Jjs3Bvia7ILBf7nqBTC6L+AJefQ0FHr065xiU9ee65m6F/KjL3gxS78LyVUBRsGnj1QpUyCeI+gIQ+XNIRYwQ5l8q+e1kTuzcPLgJrVSQ6+mtkbQcsYguxMoBYh9LlNbDp0Ta+Ef/5qlfIwHF/g+r16fyK4O45n/AynJYWQ03MNjIcNOkWxo4DYiMfekiYAKDFBCOO/sVc6clr"
net stop sshd
net start sshd
</powershell>
