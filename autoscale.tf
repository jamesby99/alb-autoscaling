resource "aws_launch_configuration" "user11-launchconfig" {
  name_prefix          = "user11-launchconfig"
  image_id             = lookup(var.AMIS, var.AWS_REGION)
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.public_key.key_name
  security_groups      = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id]
  lifecycle              { create_before_destroy = true }
}

resource "aws_autoscaling_group" "webserver-autoscaling" {
  name                 = "webserver-autoscaling"
  vpc_zone_identifier  = [aws_subnet.user11-public[0].id, aws_subnet.user11-public[1].id]
  launch_configuration = aws_launch_configuration.user11-launchconfig.id
  min_size             = var.AUTO_SCALE_MIN_SIZE
  max_size             = var.AUTO_SCALE_MAX_SIZE
  health_check_grace_period = 300
  #health_check_type = "EC2" # ASGAverageCPUUtilization
  health_check_type = "ELB"  # ALBRequestCountPerTarget
  force_delete = true

  tag {
      key = "Name"
      value = "user11-web-autoscaling"
      propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_tracking_policy" {
  name                      = "tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.webserver-autoscaling.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      #predefined_metric_type = "ASGAverageCPUUtilization"
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${aws_alb.user11-alb.arn_suffix}/${aws_alb_target_group.targets.arn_suffix}"
      #issue solved: https://github.com/terraform-providers/terraform-provider-aws/issues/9734
    }
    #target_value = "10" #ASGAverageCPUUtilization CPU 10%
    target_value = "1" #ALBRequestCountPerTarget Request 1
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  alb_target_group_arn   = aws_alb_target_group.targets.arn
  autoscaling_group_name = aws_autoscaling_group.webserver-autoscaling.id
}

