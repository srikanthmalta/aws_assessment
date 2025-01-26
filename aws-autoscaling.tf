# 5.1.5 - Create Auto Scaling Group
resource "aws_launch_template" "webserver_lt" {
  name          = "webserver-lt"
  instance_type = "t2.micro"
  image_id      = "ami-0cdd6d7420844683b" # Amazon Linux 2 AMI
  network_interfaces {
    security_groups = [
      aws_security_group.sg.id
    ]
  }
  user_data = filebase64("${path.module}/userdata.sh")

  lifecycle {
    create_before_destroy = true
  }
  network_interfaces {
    associate_public_ip_address = true
  }
}


resource "aws_autoscaling_group" "webserver_asg" {
  #availability_zones = ["eu-central-1a", "eu-central-1b"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.webserver_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [
    aws_subnet.public_subnets["terraform-test-subnet-a"].id,
    aws_subnet.public_subnets["terraform-test-subnet-b"].id
  ]

}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-cpu-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
}