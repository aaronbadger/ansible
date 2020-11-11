provider "aws" {
  region = "us-west-2"
}
resource "aws_instance" "Amazon_Linux_2" {
  ami = "ami-0528a5175983e7f28"
  instance_type = "t2.micro"
  key_name = "badger"
  vpc_security_group_ids = ["sg-0a3ef763d2efa947f",]
  subnet_id = "subnet-0cc8b926702c45c4b"
  user_data = <<-EOF
              #!/bin/bash
              sudo amazon-linux-extras install ansible2 -y
              EOF

  provisioner "remote-exec" {
      connection {
      host        = self.private_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
    }
  }
  
  provisioner "local-exec" {

    working_dir = "../ansible/"
    command = "ansible-playbook -i '${self.private_ip},' -i 'cloudblockstore,' --private-key ${var.private_key_path} -e 'cloud_initiator='${self.private_ip}' fa_url='${var.fa_url}' volname=amazonlnx5 size=1T pure_api_token='${var.pure_api_token}' ansible_user=ec2-user os_type=linux' master_playbook.yaml"
  }
}
