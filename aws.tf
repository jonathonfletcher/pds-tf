resource "aws_launch_template" "pds" {
  name = "pds-launch-template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 50
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 2
    threads_per_core = 1
  }

  ebs_optimized = true
  instance_type = "t4g.small"

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/launch.sh")
}

resource "aws_key_pair" "jacob_key_pair" {
  key_name   = var.key_pair_name
  public_key = var.public_key
}

resource "aws_instance" "pds" {
  availability_zone = var.zone
  key_name          = aws_key_pair.jacob_key_pair.key_name
  launch_template {
    version = "$Latest"
    id      = aws_launch_template.pds.id
  }
  instance_type               = "t4g.small"
  subnet_id                   = aws_subnet.pds_subnet.id
  security_groups             = [aws_security_group.pds_sg.id]
  associate_public_ip_address = true
  ami                         = "ami-0c6c29c5125214c77"


  cpu_options {
    core_count       = 2
    threads_per_core = 1
  }

  tags = {
    Name = "pds-instance"
    PDS  = "pds.jaronoff.com"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
      user_data,
    ]
  }
}

resource "aws_lb_target_group" "nlb_target_group_443" {
  name               = "pds-tg-443"
  port               = 443
  protocol           = "TCP"
  preserve_client_ip = "true"
  ip_address_type    = "ipv4"
  vpc_id             = aws_vpc.pds_vpc.id

  depends_on = [aws_lb.pds-nlb]
}

resource "aws_lb_target_group" "nlb_target_group_80" {
  name               = "pds-tg-80"
  port               = 80
  protocol           = "TCP"
  preserve_client_ip = "true"
  ip_address_type    = "ipv4"
  vpc_id             = aws_vpc.pds_vpc.id

  depends_on = [aws_lb.pds-nlb]
}

resource "aws_lb_listener" "pds_nlb_http" {
  load_balancer_arn = aws_lb.pds-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group_80.arn
  }
}

resource "aws_lb_listener" "pds_nlb_https" {
  load_balancer_arn = aws_lb.pds-nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group_443.arn
  }
}


resource "aws_lb_target_group_attachment" "pds_tga_443" {
  target_group_arn = aws_lb_target_group.nlb_target_group_443.arn
  target_id        = aws_instance.pds.id
  port             = 443
}

resource "aws_lb_target_group_attachment" "pds_tga_80" {
  target_group_arn = aws_lb_target_group.nlb_target_group_80.arn
  target_id        = aws_instance.pds.id
  port             = 80
}
