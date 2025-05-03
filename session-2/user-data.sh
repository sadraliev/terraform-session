#!/bin/bash

dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><body><h1>Session-2 homework is complete! </h1></body></html>" > /var/www/html/index.html
