provider "aws" {
  region     = "ap-south-1"
  profile    = "terraform"
}

resource "aws_instance" "os1" {
  ami           = "ami-010aff33ed5991201"
  instance_type = "t2.micro"
  key_name = "hadoopkey"
  vpc_security_group_ids = [ "sg-0e818dd7bf77300fb" ]
  tags = {
    Name = "My TF Ins"
  }

}

output "o1" {
  value = aws_instance.os1.public_ip
}

resource "aws_ebs_volume" "st1" {
  availability_zone = aws_instance.os1.availability_zone
  size              = 1

  tags = {
    Name = "myebs-vol1"
  }
}
output "o2" {
  value = aws_ebs_volume.st1.id
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.st1.id
  instance_id = aws_instance.os1.id
  force_detach = true
}

output "o3" {
  value = aws_volume_attachment.ebs_att.device_name
}

resource "null_resource" "remote1" {

    depends_on = [
        aws_instance.os1
    ]

    provisioner "local-exec" {
    command = "echo ${aws_instance.os1.public_ip} > /myinventory/hosts.txt"
  }
}
