#! /bin/bash

sudo apt-get update 
sudo apt-get install apache2 -y 

cat <<EOF > /var/www/html/index.html
<!doctype html>
<html>
  <body>
    <h1>Hello from Google Cloud Yo!</h1>
    <p>The network being used is ${network}
  </body>
</html>
EOF