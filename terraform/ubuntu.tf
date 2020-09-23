resource "aws_instance" "ubuntu20" {
  ami = "ami-0ba60995c1589da9d"
  instance_type = "t2.micro"
  key_name = "badger"
  vpc_security_group_ids = ["sg-0a3ef763d2efa947f",]
  subnet_id = "subnet-0cc8b926702c45c4b"
  user_data = <<-EOF
              #! /bin/bash
              apt update
              apt install software-properties-common -y
              apt-add-repository --yes --update ppa:ansible/ansible
              apt install ansible -y
              EOF

  provisioner "remote-exec" {
      connection {
      host        = self.private_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }
  }
  
  provisioner "local-exec" {

    working_dir = "../ansible/"
    command = "ansible-playbook -i '${self.private_ip},' -i 'cloudblockstore,' --private-key ${var.private_key_path} -e 'os_type=linux cloud_initiator='${self.private_ip}' fa_url='${var.fa_url}' volname=ansiblevol20 size=1T pure_api_token='${var.pure_api_token}' ansible_python_interpreter=/usr/bin/python3' master_playbook.yaml"
  }
}
