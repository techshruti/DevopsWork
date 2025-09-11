#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
echo "<h1>Hello from Terraform Web Server</h1>" > /var/www/html/index.html
