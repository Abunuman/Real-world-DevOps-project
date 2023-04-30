# LAMP STACK IMPLEMENTATION
In DevOps, there are different stack of technologies that make different solutions possible. These stack of technologies are regarded as WEB STACKS. Examples of Web Stacks include LAMP, LEMP, MEAN, and MERN stacks.

## What is a Technology stack (Web Stack)?

A technology stack is a set of frameworks and tools used to develop a software product. This set of frameworks and tools are very 
specifically chosen to work together in creating a well-functioning software. 

They are acronymns for individual technologies used together for a specific technology product. 

Some examples are…

- LAMP (Linux, Apache, MySQL, PHP or Python, or Perl)
- LEMP (Linux, Nginx, MySQL, PHP or Python, or Perl)
- MERN (MongoDB, ExpressJS, ReactJS, NodeJS)
- MEAN (MongoDB, ExpressJS, AngularJS, NodeJS)

In this section, I will be implementing a LAMP stack involving the use of:
- [ ] Linux OS (Ubuntu flavor)
 
- [ ] Apache webserver

- [ ] MySQL

- [ ] PHP

# STEPS INVOLVED

## Step 0 – Preparing prerequisites
- [X] AWS account 

- [X] An EC2 virtual server with Ubuntu Server OS (Ubuntu 22.04-LTS was used).


### Connecting to EC2 terminal
 
 Either through:
  ### The console using Instance Connect:
1. Check the box beside the newly created instance after it has passed all the checks (usually 2/2).
2. Click on connect on top, and it bings forth the connection page with the following options:
 
 EC2 Instance Connect

 Session Manager

 SSH Client...

 Click on EC2 Instance Connect and Click on connect below.

 N.B: 

 a. Make sure you enable an auto-assign public IP while creating Instance so that it gives the instance public IP to connect with.

 b. The Console Connect could bring forth a network(red-colored) error, this is usually an issue with ones Security Group (Firewall) Inbound and Outbound rules. Check the rules and make amends.
 
 OR

  ### The terminal using SSH keys 

- Following the same process as above, instead of clicking on EC2 instance connect, click on SSH Client and follow the following process.

 - Go to the location where your key-pair was downloaded on your local computer (usually in Downloads) and open the key-pair used while launching the EC2 instance using Notepad or VS Code and copy the entire Private SSH key.

- Go to your terminal and navigate to the .ssh directory 

- Using a text editor in nano or vim, create and open a file with a .pem extension with the same name as the key-pair e.g `" nano test.pem"`

- It opens up a new file with that name and then you paste the private key-pair you just copied.

- Then, change the file permission using chmod 400 + name of .pem keypair e.g `"chmod 400 test.pem"`

- Then copy the ssh connectivity format from AWS (that's easier).

  e.g `ssh -i "test.pem" ubuntu@0.0.0.0`

- Then answer the prompt that comes after such, then voila! We are connected to the EC2 ubuntu virtual server.

---

# STEP 1 — INSTALLING APACHE AND UPDATING THE FIREWALL

Apache HTTP Server is the most widely used web server software. Developed and maintained by Apache Software Foundation, Apache is an
open source software available for free. It runs on 67% of all webservers in the world. It is fast, reliable, and secure.

Steps include:

- Install Apache using Ubuntu’s package manager ‘apt’:

```
#update a list of packages in package manager
sudo apt update

#run apache2 package installation
sudo apt install apache2
```

## To verify that apache2 is running as a Service in our OS, use following command

```
sudo systemctl status apache2
```


As we know, we have TCP port 22 open by default on our EC2 machine to access it via SSH, so we need to add a rule to EC2 configuration
to open inbound connection through port 80:
Open inbound port 80


Our server is running and we can access it locally and from the Internet (Source 0.0.0.0/0 means ‘from any IP address’).

First, let us try to check how we can access it locally in our Ubuntu shell, run:

```
curl http://localhost:80
or
 curl http://127.0.0.1:80
```

Now it is time for us to test how our Apache HTTP server can respond to requests from the Internet.
Open a web browser of your choice and try to access following url

```
http://<Public-IP-Address-of-EC2>:80
```

Another way to retrieve your Public IP address, other than to check it in AWS Web console, is to use following command:

```
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```
After doing this, **Apache Ubuntu Default Page** is displayed.

---

# STEP 2 — INSTALLING MYSQL

Now that you a web server is  up and running, there is a need to install a Database Management System (DBMS) to be able to store and manage
data for a site in a relational database. 

MySQL is a popular relational database management system used within PHP environments, 
so I am using it in this project.

The steps followed include:

1. 
```
$ sudo apt install  -y mysql-server
```


When the installation is finished, I logged in to the MySQL console by typing:


```
$ sudo mysql
```

This will connect to the MySQL server as the administrative database user root, which is inferred by the use of sudo when running 
this command. The following output comes up:


```
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.22-0ubuntu0.20.04.3 (Ubuntu)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```


It’s recommended to run a security script that comes pre-installed with MySQL. This script will remove some insecure default 
settings and lock down access to your database system. 

Before running the script I set the password for the root user, using 
mysql_native_password as default authentication method. 

e.g 

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1';
```

Exit the MySQL shell with:

```
mysql> exit
```


I started the interactive script by running:

```
$ sudo mysql_secure_installation
```


This will ask if one wants to configure the VALIDATE PASSWORD PLUGIN.

Note: Enabling this feature is something of a judgment call. If enabled, passwords which don’t match the specified criteria will
be rejected by MySQL with an error. It is safe to leave validation disabled, but you should always use strong, unique passwords 
for database credentials.

Answer Y for yes, or anything else to continue without enabling.


```
VALIDATE PASSWORD PLUGIN can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD plugin?

Press y|Y for Yes, any other key for No:
```


If you answer “yes”, you’ll be asked to select a level of password validation. Keep in mind that if you enter 2 for the strongest
level, you will receive errors when attempting to set any password which does not contain numbers, upper and lowercase letters, 
and special characters, or which is based on common dictionary words e.g PassWord.1.


```
There are three levels of password validation policy:

LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary              file

Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 1
```

Regardless of whether you chose to set up the VALIDATE PASSWORD PLUGIN, your server will next ask you to select and confirm a
password for the MySQL root user. This is not to be confused with the system root. The database root user is an administrative user
with full privileges over the database system. Even though the default authentication method for the MySQL root user dispenses the
use of a password, even when one is set, you should define a strong password here as an additional safety measure. 
We’ll talk about this in a moment.


If you enabled password validation, you’ll be shown the password strength for the root password you just entered and your server
will ask if you want to continue with that password. If you are happy with your current password, enter Y for “yes” at the prompt:


```
Estimated strength of the password: 100 
Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y
```


For the rest of the questions, press Y and hit the ENTER key at each prompt. This will prompt you to change the root password, 
remove some anonymous users and the test database, disable remote root logins, and load these new rules so that MySQL immediately
respects the changes you have made.

When you’re finished, test if you’re able to log in to the MySQL console by typing:


```
$ sudo mysql -p
```


Notice the -p flag in this command, which will prompt you for the password used after changing the root user password.

To exit the MySQL console, type:

```
mysql> exit
```

Notice that you need to provide a password to connect as the root user.

For increased security, it’s best to have dedicated user accounts with less expansive privileges set up for every database,
especially if you plan on having multiple databases hosted on your server.

The MySQL server is now installed and secured. Next, I installed PHP, the final component in the LAMP stack.

---
# STEP 3 — INSTALLING PHP

Apache is installed to serve my content and MySQL installed to store and manage data. 

PHP is the component of the setup
that will process code to display dynamic content to the end user. In addition to the php package, there will be need for php-mysql, a PHP module that allows PHP to communicate with MySQL-based databases. Also, there is a need for libapache2-mod-php to enable Apache to handle PHP files.
Core PHP packages will automatically be installed as dependencies.

To install these 3 packages at once, run:

```
sudo apt install php libapache2-mod-php php-mysql
```

Next, is confirmation of PHP version:

```
php -v
```

it displayed sth of this nature 
```
PHP 8.1.2-1ubuntu2.11 (cli) (built: Feb 22 2023 22:56:18) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.1.2, Copyright (c) Zend Technologies
with Zend OPcache v8.1.2-1ubuntu2.11, Copyright (c), by Zend Technologies
```

At this point, the LAMP stack is completely installed and fully operational.

- Linux (Ubuntu)
- Apache HTTP Server
- MySQL
- PHP

To test the setup with a PHP script, it’s best to set up a proper Apache Virtual Host to hold the website’s files and folders.
Virtual host allows one to have multiple websites located on a single machine and users of the websites will not even notice it.


# STEP 4 — CREATING A VIRTUAL HOST USING APACHE

- I set up a domain called nerdrxlamp.

Apache on Ubuntu 20.04 has one server block enabled by default that is configured to serve documents from the /var/www/html directory.
I left this configuration as it is and will added my own directory next to the default one.

a. 
```
sudo mkdir /var/www/nerdrxlamp
```

Next, I assigned ownership of the directory with my current system user:

b. 
```
sudo chown -R $USER:$USER /var/www/nerdrxlamp
```

Then, I created and opened a new configuration file in Apache’s sites-available directory using your preferred command-line editor. 
Here, I used nano:

c.
```
sudo nano /etc/apache2/sites-available/nerdrxlamp.conf
```

This will create a new blank file where I pasted the following bare-bones configuration:

d. 
```
<VirtualHost *:80>
    ServerName nerdrxlamp
    ServerAlias nerdrxlamp.maxxim 
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/nerdrxlamp
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

I used the ls command to show the new file in the sites-available directory

e. 
```
sudo ls /etc/apache2/sites-available
```

It returns something like this;

```
000-default.conf  default-ssl.conf  nerdrxlamp.conf
```

With this VirtualHost configuration, we’re telling Apache to serve nerdrxlamp using /var/www/nerdrxlamp as its web root directory.

I then used a2ensite command to enable the new virtual host:

f.
```
sudo a2ensite nerdrxlamp
```

One might want to disable the default website that comes installed with Apache. This is required if you’re not using a custom 
domain name, because in this case Apache’s default configuration would overwrite your virtual host. To disable Apache’s default 
website use a2dissite command , type:

g. 
```
sudo a2dissite 000-default
```

Next, I defined the Servername in /etc/apache2/apache2.conf under "Global Configuration" thus:

h.
```
sudo nano /etc/apache2/apache2.conf
```
This prevents this error message after running a configtest

```
"Could not reliably determine the server's fully qualified domain name, using 10.0.1.117. Set the 'ServerName' directive globally to suppress this message"
```
but instead gives a "Syntax Ok" message

To make sure the configuration file doesn’t contain syntax errors, I ran a configtest:

i.
```
sudo apache2ctl configtest
```

This gives 'Syntax Ok' message

Finally, I reloaded Apache so these changes take effect:


```
sudo systemctl reload apache2
```

The new website is now active, but the web root /var/www/nerdrxlamp is still empty. I created an index.html file in that location so as to test that the virtual host works as expected:


```
sudo echo 'Hello LAMP from hostname' $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP' 
$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/nerdrxlamp/index.html
```

I thereafter tried to open thewebsite URL using IP address:


```
http://<Public-IP-Address>:80
```

If you see the text from ‘echo’ command you wrote to index.html file, then it means your Apache virtual host is working as expected.
In the output you will see your server’s public hostname (DNS name) and public IP address. You can also access your website in your
browser by public DNS name, not only by IP – try it out, the result must be the same (port is optional)


OR

```
http://<Public-DNS-Name>:80
```




# STEP 5 — ENABLING PHP ON THE WEBSITE

With the default DirectoryIndex settings on Apache, a file named index.html will always take precedence over an index.php file.
This is useful for setting up maintenance pages in PHP applications, by creating a temporary index.html file containing an
informative message to visitors. Because this page will take precedence over the index.php page, it will then become the landing
page for the application. Once maintenance is over, the index.html is renamed or removed from the document root, bringing back the
regular application page.


In case one wants to change this behavior, you’ll need to edit the /etc/apache2/mods-enabled/dir.conf file and change the order in 
which the index.php file is listed within the DirectoryIndex directive:


```
sudo nano /etc/apache2/mods-enabled/dir.conf
```

```
<IfModule mod_dir.c>
        #Change this:
        #DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
        #To this:
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
```

After saving and closing the file, I reloaded Apache so the changes take effect:


```
sudo systemctl reload apache2
```

Finally, I created a PHP script to test that PHP is correctly installed and configured on the server.

Now that there is  a custom location to host the website’s files and folders, I created a PHP test script to confirm that Apache is able to handle and process requests for PHP files.

I created a new file named index.php inside my custom web root folder:

```
nano /var/www/nerdrxlamp/index.php
```

This opened a blank file, and I added the following text, which is a valid PHP code, inside the file:

```
<?php
phpinfo();
```

I refreshed the webpage and I saw a page similar to this: 


![projject1-step5](https://user-images.githubusercontent.com/85270361/210115357-dfca0250-7e0b-4f3c-8e26-8266be9cc4a6.PNG)


This page provides information about the server from the perspective of PHP. It is useful for debugging and to ensure that the settings are being applied correctly.

If you can see this page in your browser, then your PHP installation is working as expected.

After checking the relevant information about your PHP server through that page, it’s best to remove the file created as it
contains sensitive information about the PHP environment -and the Ubuntu server.


```
sudo rm /var/www/nerdrxlamp/index.php
```

Congrats NerdRx, 

That's Project 1 Done and Dusted !!!!













