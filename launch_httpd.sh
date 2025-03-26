#!/bin/bash

echo "*** Installing Busybox ***"
sudo apt update -y
sudo apt install -y busybox

mkdir web

# pub_ip=$(curl ifconfig.me)

cat > web/index.html << EOL
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>AWS ASG</title>
    </head>
    <body style="background-color: rgb(255, 250, 240);">
	    <h1><center>Welcome To Terraform IaC!!!</center></h1>
	    <!--<p><center> Public IPv4:</b> $pub_ip </center></p>-->
	    <h2><center> AWS EC2 Host:</b> $(hostname -f) </center></h2>
    </body>
</html>
EOL

nohup busybox httpd -h web -p 0.0.0.0:${server_port} &
