resource "aws_launch_template" "pds" {
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
      Name = var.pds_hostname
    }
  }

  metadata_options {
    http_tokens = "required"
    http_put_response_hop_limit = "1"
  }

  user_data = base64encode(templatefile("${path.module}/launch.sh", {
    pds_hostname : var.pds_hostname,
    pds_admin_email : var.pds_admin_email,
  }))
}

resource "aws_key_pair" "pds_ssh_key" {
  key_name   = var.ssh_key_name
  public_key = var.public_key
}

data "aws_ami" "ubuntu22" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "pds" {
  availability_zone = var.az
  key_name          = aws_key_pair.pds_ssh_key.key_name
  launch_template {
    version = "$Latest"
    id      = aws_launch_template.pds.id
  }
  subnet_id                   = aws_subnet.pds_subnet.id
  vpc_security_group_ids      = [aws_security_group.pds_sg.id]
  associate_public_ip_address = true
  ipv6_address_count          = 1
  ami                         = data.aws_ami.ubuntu22.id

  tags = {
    Name = var.pds_hostname
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
    prevent_destroy = true
  }
}

resource "aws_ebs_volume" "pds_datastore" {
  availability_zone = var.az
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  final_snapshot    = true
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Snapshot = true
  }
}

resource "aws_volume_attachment" "pds" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.pds_datastore.id
  instance_id = aws_instance.pds.id
}
