#Application Security group

resource "aws_security_group" "alb_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from Internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = var.tags
}

#creation ALB target group 

resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = "my-tf-test-bucket"


  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_lb" "alb" {
  name               = "six-figure-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_sn1_id, var.public_sn2_id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    prefix  = "s3-alb"
    enabled = true
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "target_attachment" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_lb.alb.id
  port             = 80
}


