data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "tic_tac_toe" {
  key_name   = "tic-tac-toe-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "tic_tac_toe" {
  name        = "tic-tac-toe-sg"
  description = "Allow SSH and app traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port"
    from_port   = var.app_port
    to_port     = var.app_port
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

resource "aws_instance" "tic_tac_toe" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.tic_tac_toe.key_name
  vpc_security_group_ids      = [aws_security_group.tic_tac_toe.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    # Install Node.js 18 via NodeSource
    curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs git
    # Install pm2 globally
    npm install -g pm2
    # Clone the repo
    cd /home/ec2-user
    git clone https://github.com/${var.github_repo}.git app
    cd app
    npm install --production
    # Start with pm2 as ec2-user
    sudo -u ec2-user bash -c "
      cd /home/ec2-user/app
      PORT=${var.app_port} pm2 start server.js --name tic-tac-toe
      pm2 startup systemd -u ec2-user --hp /home/ec2-user
      pm2 save
    "
    # Enable pm2 startup service
    env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user | tail -1 | bash || true
  EOF

  tags = {
    Name    = "tic-tac-toe"
    Project = "tic-tac-toe"
  }

  depends_on = [aws_key_pair.tic_tac_toe]
}
