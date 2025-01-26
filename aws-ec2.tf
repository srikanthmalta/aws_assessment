# 5.1.1 - Create Security Group
resource "aws_security_group" "sg" {
  name        = "WebServer-SG"
  description = "Allow SSH and HTTP access"
  vpc_id = aws_vpc.test_vpc.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}



# 5.1.2 - Launch EC2 Instance

resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "admin-key"
  public_key =  tls_private_key.rsa-4096.public_key_openssh #"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa-4096.private_key_pem
    filename = "admin-key"
}

###########################################

resource "aws_instance" "public_instance" {
  ami           = "ami-0cdd6d7420844683b" # Amazon Linux 2 AMI for eu-central-1 
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.public_subnets["terraform-test-subnet-a"].id
  
  tags = {
    Name = "public-Instance"
  }
  key_name = aws_key_pair.key_pair.key_name
  user_data = file("./userdata.sh")
  #security_groups = [aws_security_group.sg.name]
}




############# Second instance #################


resource "aws_instance" "public_instance-2" {
  ami           = "ami-0cdd6d7420844683b" # Amazon Linux 2 AMI for eu-central-1 
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.public_subnets["terraform-test-subnet-b"].id
  
  tags = {
    Name = "public-Instance-2"
  }
  key_name = aws_key_pair.key_pair.key_name
  user_data = file("./userdata.sh")
  #security_groups = [aws_security_group.ec2_sg.name]
}


