resource "aws_launch_template" "launch_template" {
  name = "my-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }

  image_id          = "ami-093467ec28ae4fe03"
  instance_type     = "t2.micro"     
  key_name          = file("./ec2/remote-kp.pem")
  vpc_security_group_ids = [aws_security_group.alb_sg.id] 

  
  tag_specifications {
    resource_type = "instance"
    tags = var.tags
}
}

resource "aws_placement_group" "placement_group" {
  name     = "placement_group"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "asg" {
  name                      = "6-figure-autoscaling"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  placement_group           = aws_placement_group.placement_group.id
  #launch_configuration      = aws_launch_configuration.foobar.name
  vpc_zone_identifier       = [var.public_sn2_id, var.public_sn1_id]
  
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  initial_lifecycle_hook {
    name                 = "foobar"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = jsonencode({
      foo = "bar"
    })

    notification_target_arn = "arn:aws:sqs:us-west-2:444455556666:queue1*"
    role_arn                = "arn:aws:iam::123456789012:role/S3Access"
  }

  tag {
    key                 = "6-figure"
    value               = "prod"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "6-figure"
    value               = "prof"
    propagate_at_launch = false
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_lb.alb.id
}
# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_tg" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.alb_tg.arn
}
