data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 8
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e
    dnf install -y python3
    mkdir -p /var/www/myapp
    cat > /var/www/myapp/index.html <<'HTML'
    <!doctype html>
    <html>
      <head><title>Two-Tier Web App</title></head>
      <body>
        <h1>Two-Tier Web Application</h1>
        <p>EC2 web tier is running.</p>
        <p>Next step: connect the Flask application to Amazon RDS.</p>
      </body>
    </html>
    HTML
    nohup python3 -m http.server 80 --directory /var/www/myapp --bind 0.0.0.0 \
      >/var/log/webapp.log 2>&1 &
  EOF

  tags = {
    Name = "${var.project_name}-web-server"
    Tier = "application"
  }
}
