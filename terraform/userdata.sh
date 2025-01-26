sudo su
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
hostname > /var/www/html/index.html