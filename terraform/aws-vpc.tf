# 5.1.4 - Create VPC and Subnets
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-test-vpc"
  }
}



resource "aws_subnet" "public_subnets" {
  for_each = { for subnet in var.public_subnets : subnet.name => subnet }

  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch  = true

  tags = merge(
    each.value.tags,
    {
      Name = each.value.name
    }
  )
}

resource "aws_subnet" "private_subnets" {
  for_each = { for subnet in var.private_subnets : subnet.name => subnet }

  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(
    lookup(each.value, "tags", {}),
    {
      Name = each.value.name
    }
  )
}


# 5.1.5 - Create Auto Scaling Group
resource "aws_launch_configuration" "webserver_lc" {
  name          = "webserver-launch-configuration"
  image_id      = "ami-0c5204531f799e0c6" # Amazon Linux 2 AMI for eu-central-1
  instance_type = "t2.micro"

  security_groups = [aws_security_group.sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver_asg" {
  launch_configuration = aws_launch_configuration.webserver_lc.id
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1

  vpc_zone_identifier = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]
}



