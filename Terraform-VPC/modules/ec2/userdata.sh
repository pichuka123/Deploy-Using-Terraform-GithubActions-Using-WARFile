#!/bin/bash

# Update system
sudo yum update -y

# Apache HTTPD runs on port 80 and acts as a reverse proxy to Tomcat
# End-users just access http://your-server/ without worrying about :8080
# Install httpd
#sudo yum install -y java-1.8.0-openjdk wget unzip
sudo amazon-linux-extras enable corretto 17
sudo yum install java-17-amazon-corretto -y
sudo yum install git maven -y 
#yum install -y httpd mod_proxy mod_proxy_ajp

# Enable and start Apache HTTPD
#systemctl enable httpd
#systemctl start httpd

# Tomcat runs your .war on port 8080
# Install Tomcat (if using WAR deployment)

# Create a tomcat user and directory
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat || true
sudo cd /opt/
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.109/bin/apache-tomcat-9.0.109.tar.gz
sudo tar -xvzf apache-tomcat-9.0.109.tar.gz
sudo mv apache-tomcat-9.0.109 tomcat
sudo cd /opt/tomcat/webapps/manager/META-INF
sudo sed -i 's/"127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1"/".*"/g' context.xml
sudo rm -rf apache-tomcat-9.0.109.tar.gz
sudo cd /opt/tomcat/conf
sudo mv tomcat-users.xml tomcat-users_bkup.xml
sudo touch tomcat-users.xml
sudo echo '<?xml version="1.0" encoding="utf-8"?>
<tomcat-users>
<role rolename="manager-gui"/>
<user username="tomcat" password="tomcat" roles="manager-gui, manager-script, manager-status"/>
</tomcat-users>' > tomcat-users.xml
# below is if Jenkins is also in the same server.
#sudo sed -i 's/Connector port="8080"/Connector port="8081"/g' server.xml


# Fix permissions
chown -R tomcat:tomcat /opt/tomcat
chmod +x /opt/tomcat/bin/*.sh

# Get WAR file from S3
sudo aws s3 cp s3://pichukaartifactbucket/myapp.war /opt/tomcat/webapps/myapp.war

# Start services
sudo sh /opt/tomcat/bin/startup.sh

# Incase of Apache configureation
# Configure Apache as reverse proxy
#cat <<EOF > /etc/httpd/conf.d/myapp.conf
#<VirtualHost *:80>
#    ProxyPreserveHost On
#    ProxyPass / http://127.0.0.1:8080/
#    ProxyPassReverse / http://127.0.0.1:8080/
#</VirtualHost>
#EOF

# Enable proxy modules (Amazon Linux uses LoadModule in config)
#echo "LoadModule proxy_module modules/mod_proxy.so" >> /etc/httpd/conf/httpd.conf
#echo "LoadModule proxy_http_module modules/mod_proxy_http.so" >> /etc/httpd/conf/httpd.conf

# Restart Apache
#systemctl restart httpd
