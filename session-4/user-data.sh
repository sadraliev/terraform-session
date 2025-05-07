#!/bin/bash

dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

cat <<EOF > /var/www/html/index.html
<html>
  <body>
    <h1> ${environment} Instance is running</h1>
  </body>
</html>
EOF

# $environment  = var.environment