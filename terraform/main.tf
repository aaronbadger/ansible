resource "aws_instance" "ubuntu5" {
  ami = "ami-0ba60995c1589da9d"
  instance_type = "t2.micro"
  key_name = "badger"
  vpc_security_group_ids = ["sg-07286720b994b82d1",]
  subnet_id = "subnet-0bd1b1b83b1bc4dea"
  user_data = <<-EOF
              #! /bin/bash
              apt update
              apt install software-properties-common -y
              apt-add-repository --yes --update ppa:ansible/ansible
              apt install ansible -y
              EOF

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for SSH'",
    ]

    connection {
      host        = self.private_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }
  }

  provisioner "local-exec" {

    working_dir = "../ansible/"
    command = "ansible-playbook -i '${self.private_ip},' -i 'cloudblockstore,' --private-key ${var.private_key_path} -e 'cloud_initiator='${self.private_ip}' fa_url='${var.fa_url}' volname=ansiblevol1 size=1T pure_api_token='${var.pure_api_token}' ansible_python_interpreter=/usr/bin/python3' combined_playbook.yaml"
  }
}
