# LEMP STACK IMPLEMENTATION

In this section, there will be an implementation of the LEMP stack involving the use of:
- [ ] Linux OS (Ubuntu flavor)
 
- [ ] Nginx webserver

- [ ] MySQL

- [ ] PHP

So all in all, Nginx webserver replaces Apache in this stack.

The Steps are as follows:

## Step 0 – Preparing prerequisites

Follow Step 0 in [LAMP-STACK](../LAMP-STACK/Lampstack.md)


# STEP 1 – INSTALLING THE NGINX WEB SERVER

1. Update server package index

```
sudo apt update
```
2. Install nginx web server

```
sudo apt install nginx
```
3. Check nginx status

```
sudo systemctl status nginx
```

First, I tried checking how we can access it locally in the Ubuntu shell, running:

```
curl http://localhost:80
or
curl http://127.0.0.1:80
```

Then I ran it using the EC2 server
```
http://<Public-IP-Address>:80
```

The nginx default web page is displayed

# STEP 2 — INSTALLING MYSQL

Now that the web server is up and running, we need to install a Database Management System (DBMS) to be able to store and manage data for our site in a relational database. 

MySQL is a popular relational database management system used within PHP environments,
so we will use it in our project.

- Again, use ‘apt’ to acquire and install this software:

a. 

```
$ sudo apt install mysql-server
```

When prompted, confirm installation by typing Y, and then ENTER.

- When the installation is finished, log in to the MySQL console by typing:

b. 

```
$ sudo mysql
```

This will connect to the MySQL server as the administrative database user root, which is inferred by the use of sudo when running this command. We should see output like this:

```
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.32-0ubuntu0.22.04.2 (Ubuntu)

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```



-  Set a password for the root user, using mysql_native_password as default authentication method. Define what you want as password where I put '***'

c. 

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '*****';
```

- Exit the MySQL shell with:

```
mysql> exit
```

It’s recommended that a security script is ran. This comes pre-installed with MySQL.

This script will remove some insecure default settings and lock down access to the database system. 

- Start the interactive script by running:

d. 

```
$ sudo mysql_secure_installation
```

This will ask if we want to configure the VALIDATE PASSWORD PLUGIN.

Note: Enabling this feature is something of a judgment call. If enabled, passwords which don’t match the specified criteria will  be rejected by MySQL with an error. It is safe to leave validation disabled, but we should always use strong, unique passwords for database credentials.

- Answer Y for yes, or anything else to continue without enabling.

```
VALIDATE PASSWORD PLUGIN can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD plugin?

Press y|Y for Yes, any other key for No:
```

If you answer “yes”, you’ll be asked to select a level of password validation. Keep in mind that if you enter 2 for the strongest 
level, you will receive errors when attempting to set any password which does not contain numbers, upper and lowercase letters, and 
special characters, or which is based on common dictionary words e.g PassWord.1.

```
There are three levels of password validation policy:

LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary              file

Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 1
```

Regardless of whether you chose to set up the VALIDATE PASSWORD PLUGIN, your server will next ask you to select and confirm a
password for the MySQL root user. This is not to be confused with the system root. The database root user is an administrative user 
with full privileges over the database system. Even though the default authentication method for the MySQL root user dispenses
the use of a password, even when one is set, you should define a strong password here as an additional safety measure. 
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

- When this is concluded, we test if we’re able to log in to the MySQL console by typing:

e. 

```
$ sudo mysql -p
```
The -p flag in this command will prompt us for the password used after changing the root user password.

- To exit the MySQL console, type:

f. 

```
mysql> exit
```

Notice that we need to provide a password to connect as the root user.

For increased security, it’s best to have dedicated user accounts with less expansive privileges set up for every database, especially if we plan on having multiple databases hosted on your server.

Our MySQL server is now installed and secured. 

**Next, we will install PHP, the final component in the LEMP stack.**

# STEP 3 – INSTALLING PHP

We have Nginx installed to serve our content and MySQL installed to store and manage our data. 

Now we can install PHP to process code and generate dynamic content for the web server.

While Apache embeds the PHP interpreter in each request, Nginx requires an external program to handle PHP processing and act as a bridge between the PHP interpreter itself and the web server. This allows for a better overall performance in most PHP-based websites, but it requires additional configuration. 

We’ll need to install `php-fpm`, which stands for `“PHP fastCGI process manager”`,
and tell Nginx to pass PHP requests to this software for processing. 

Additionally, we’ll need `php-mysql`, a PHP module that allows 
PHP to communicate with MySQL-based databases. Core PHP packages will automatically be installed as dependencies.

- To install these 2 packages at once, run:

```
sudo apt install php-fpm php-mysql
```

When prompted, type Y and press ENTER to confirm installation.

We now have your PHP components installed. Next, you will configure Nginx to use them.

# STEP 4 — CONFIGURING NGINX TO USE PHP PROCESSOR

When using the Nginx web server, we can create **server blocks** `(similar to virtual hosts in Apache) to encapsulate configuration ` details and host more than one domain on a single server. Here,I will use maxxim.tech as my domain name.

On Ubuntu 22.04, Nginx has one server block enabled by default and is configured to serve documents out of a directory at /var/www/html.
While this works well for a single site, it can become difficult to manage if we are hosting multiple sites. Instead of modifying /var/www/html, we’ll create a directory structure within /var/www for the your_domain website, leaving /var/www/html in
place as the default directory to be served if a client request does not match any other sites.

Create the root web directory for your_domain as follows:

```
sudo mkdir /var/www/nerdrxlemp
```

Next, assign ownership of the directory with the $USER environment variable, which will reference your current system user:

```
sudo chown -R $USER:$USER /var/www/nerdrxlemp
```

Then, open a new configuration file in Nginx’s sites-available directory using your preferred command-line editor. Here,
we’ll use nano:


```
sudo nano /etc/nginx/sites-available/nerdrxlemp
```

This will create a new blank file. Paste in the following bare-bones configuration:


```
#/etc/nginx/sites-available/nerdrxlemp

server {
    listen 80;
    server_name maxxim.tech nerdrxlemp.maxxim.tech;
    root /var/www/nerdrxlemp;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}
```

Here’s what each of these directives and location blocks do:

- listen — Defines what port Nginx will listen on. In this case, it will listen on port 80, the default port for HTTP.

- root — Defines the document root where the files served by this website are stored.

- index — Defines in which order Nginx will prioritize index files for this website. It is a common practice to list index.html 
files with a higher precedence than index.php files to allow for quickly setting up a maintenance landing page in PHP applications. 
You can adjust these settings to better suit your application needs.

- server_name — Defines which domain names and/or IP addresses this server block should respond for. Point this directive to
 your server’s domain name or public IP address.
 
- location / — The first location block includes a try_files directive, which checks for the existence of files or directories 
matching a URI request. If Nginx cannot find the appropriate resource, it will return a 404 error.

- location ~ \.php$ — This location block handles the actual PHP processing by pointing Nginx to the fastcgi-php.conf configuration 
file and the php8.1-fpm.sock file, which declares what socket is associated with php-fpm.

- location ~ /\.ht — The last location block deals with .htaccess files, which Nginx does not process. By adding the deny all 
directive, if any .htaccess files happen to find their way into the document root ,they will not be served to visitors.


When done editing, we save and close the file.

- We activate our configuration by linking to the config file from Nginx’s sites-enabled directory:

```
sudo ln -s /etc/nginx/sites-available/nerdrxlemp /etc/nginx/sites-enabled/
```

This will tell Nginx to use the configuration next time it is reloaded. 

- We can test our configuration for syntax errors by typing:


```
sudo nginx -t
```

- You shall see following message:

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

If any errors are reported, we go back to our configuration file to review its contents before continuing.

- We also need to disable default Nginx host that is currently configured to listen on port 80, for this run:

```
sudo unlink /etc/nginx/sites-enabled/default
```

- When are ready, we reload Nginx to apply the changes:


```
sudo systemctl reload nginx
```

Our new website is now active, but the web root /var/www/nerdrxlemp is still empty. 

We create an index.html file in that location so that we can test that your new server block works as expected:

```
sudo echo 'Hello LEMP from hostname' $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP'
$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/nerdrxlemp/index.html
```

- Now we go to our browser and try to open our website URL using IP address or domain name:

```
http://<Public-IP-Address>:80
```
```
http://<Public-DNS-Name>:80
```

**With or without :80, it works, since it listens on port 80 which is HTTP port.**

N.B: If you see the text from ‘echo’ command you wrote to index.html file, then it means your Nginx site is working as expected.
In the output you will see your server’s public hostname (DNS name) and public IP address.


We can leave this file in place as a temporary landing page for our application until we set up an index.php file to replace it. 
Once we do that, remember to remove or rename the index.html file from your document root, as it would take precedence over an index.php file by default.

The LEMP stack is now fully configured. 

In the next step, we’ll create a PHP script to test that Nginx is in fact able to handle php files within the newly configured website.

# STEP 5 – TESTING PHP WITH NGINX

Your LEMP stack should now be completely set up.

At this point, our LEMP stack is completely installed and fully operational.

We can test it to validate that Nginx can correctly hand .php files off to the PHP processor.

We can do this by creating a test PHP file in our document root, opening a new file called info.php within our document root.

```
sudo nano /var/www/nerdrxlemp/info.php
```

- Type or paste the following lines into the new file. This is a valid PHP code that will return information about our server:


```
<?php
phpinfo();
```

We can now access this page in your web browser by visiting the domain name or public IP address we’ve set up in our Nginx configuration file, followed by /info.php:

```
http://`server_domain_or_IP`/info.php
```

A web page containing detailed information about our server is displayed:

![projject1-step5](https://user-images.githubusercontent.com/85270361/210117729-d93d8aad-b131-40c2-b28d-ca0289327906.PNG)


After checking the relevant information about our PHP server through that page, it’s best to remove the file created as it contains sensitive information about our PHP environment and our Ubuntu server.

```
sudo rm /var/www/our_domain/info.php
```

You can always regenerate this file if you need it later.


# STEP 6 – RETRIEVING DATA FROM MYSQL DATABASE WITH PHP (CONTINUED)

In this step you will create a test database (DB) with simple "To do list" and configure access to it, so the Nginx website would be
able to query data from the DB and display it.

We’ll need to create a new user with the `mysql_native_password authentication method` in order to be able to connect to the MySQL database from PHP.

We will create a database named nerdrx_database and a user named nerdrx.

First, connect to the MySQL console using the root account:

```
sudo mysql
```

To create a new database, run the following command from your MySQL console:

```
mysql> CREATE DATABASE `nerdrx_database`;
```

Now we can create a new user and grant him full privileges on the database we've just created.

The following command creates a new user named nerdrx, using mysql_native_password as default authentication method. One can define this user’s password with whatever one wishes by replacing the *** with an actual password

```
mysql>  CREATE USER 'nerdrx'@'%' IDENTIFIED WITH mysql_native_password BY '******';
```

Now we need to give this user permission over the example_database database:

```
mysql> GRANT ALL ON nerdrx_database.* TO 'nerdrx'@'%';
```

This will give 'nerdrx' full privileges over the nerdrx_database database, while preventing this user from creating 
or modifying other databases on your server.

Now exit the MySQL shell with:

```
mysql> exit
```

You can test if the new user has the proper permissions by logging in to the MySQL console again, this time using the custom user
credentials:

```
mysql -u nerdrx -p
```

The -u specifies the user and the -p flag in this command will prompt us for the password used when creating the nerdrx user. After logging in to the MySQL console, confirm that you have access to the nerdrx_database database:

```
mysql> SHOW DATABASES;
```

This will give us the following output:


```
Output
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nerdrx_database    |
| performance_schema |
+--------------------+
2 rows in set (0.000 sec)
```

Next, we’ll create a test table named todo_list. From the MySQL console, we run the following statement:

```
CREATE TABLE nerdrx_database.todo_list (
mysql>     item_id INT AUTO_INCREMENT,
mysql>     content VARCHAR(255),
mysql>     PRIMARY KEY(item_id)
mysql> );
```

And insert a few rows of content in the test table. We might want to repeat the next command a few times, using different VALUES:

```
mysql> INSERT INTO nerdrx_database.todo_list (content) VALUES ("GitOps with FluxCD");
```

```
mysql> INSERT INTO nerdrx_database.todo_list (content) VALUES ("Python for Entry-Level (PCP-302)");
```

```
mysql> INSERT INTO nerdrx_database.todo_list (content) VALUES ("Helm-Chart for Kubernetes ");
```

```
mysql> INSERT INTO nerdrx_database.todo_list (content) VALUES ("GitOps with ArgoCD");
```

```
mysql> INSERT INTO nerdrx_database.todo_list (content) VALUES ("CI/CD with Gitlab");
```

To confirm that the data was successfully saved to our table, we run:

```
mysql>  SELECT * FROM nerdrx_database.todo_list;mysql>  SELECT * FROM nerdrx_database.todo_list;
```

We’ll see the following output:

```
Output
+---------+----------------------------------+
| item_id | content                          |
+---------+----------------------------------+
|       1 | GitOps with FluxCD               |
|       2 | Python for Entry-Level (PCP-302) |
|       3 | Helm-Chart for Kubernetes        |
|       4 | GitOps with ArgoCD               |
|       5 | CI/CD with Gitlab                |
+---------+----------------------------------+

5 rows in set (0.000 sec)
```

After confirming that we have valid data in our test table, we then exit the MySQL console:

```
mysql> exit
```

Now we can create a PHP script that will connect to MySQL and query for our content. 

```
nano /var/www/nerdrxlemp/todo_list.php
```

The following PHP script connects to the MySQL database and queries for the content of the todo_list table, displays the results in a list. If there is a problem with the database connection, it will throw an exception.

- We copy this content into the todo_list.php script:

```
<?php
$user = "nerdrx";
$password = "password";
$database = "nerdrx_database";
$table = "todo_list";

try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  echo "<h2>TODO</h2><ol>";
  foreach($db->query("SELECT content FROM $table") as $row) {
    echo "<li>" . $row['content'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
```


Then save and close the file when done editing.

We can now access this page in our web browser by visiting the domain name or public IP address configured for your website, 
followed by /todo_list.php:


```
http://<Public_domain_or_IP>/todo_list.php
```

You should see a page like this, showing the content you’ve inserted in your test table:

![To-Do-List](../../images/Screenshot%202023-05-06%20at%2012.28.49.png)


That means our PHP environment is ready to connect and interact with the MySQL server.

Congratulations nerdrx! Project 2 completed



