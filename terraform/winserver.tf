provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "winserver2019" {
  ami = "ami-0afb7a78e89642197"
  instance_type = "t3.medium"
  key_name = "badger"
  vpc_security_group_ids = ["sg-0a3ef763d2efa947f",]
  subnet_id = "subnet-0cc8b926702c45c4b"
  user_data = <<-EOF
              <powershell>
              Add-WindowsFeature -Name 'Multipath-IO'
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
              Restart-Computer
              </powershell>
              EOF

  provisioner "remote-exec" {
      connection {
      host        = self.private_ip
      type        = "ssh"
      user        = "administrator"
      private_key = file(var.private_key_path)
    }
  }

  provisioner "local-exec" {

    working_dir = "../ansible/"
    command = "ansible-playbook -i '${self.private_ip},' -i 'cloudblockstore,' --private-key ${var.private_key_path} -e 'cloud_initiator='${self.private_ip}' fa_url='${var.fa_url}' volname=ansibledemowinserver size=1T pure_api_token='${var.pure_api_token}' ansible_user=Administrator os_type=windows' master_playbook.yaml"
  }
}
