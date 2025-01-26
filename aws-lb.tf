resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_lb" "application_lb" {
  name               = "test-application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
}

resource "aws_lb_target_group" "tg" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.test_vpc.id
  target_type = "instance"
  deregistration_delay = 1000
  slow_start = 30
  health_check {
    port                = "80"
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}
resource "aws_lb_target_group_attachment" "instance_1_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.public_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance_2_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.public_instance-2.id
  port             = 80
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 443
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}