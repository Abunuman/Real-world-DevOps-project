# Shell (BASH) scripting

In this project, I am going to write a script to onboard 20 new Linux users onto a server. 

I will create a shell script that reads a csv file that contains the
first name of the users to be onboarded. 
Here is a sneak peek into what to expect


# Onboard new users to a Linux server.
[Bash Script](onboarding.sh) to create multiple users from a list of names in a file.

The script;

- Searches for a file named [new_users.csv](new_users.csv) , where names for users are listed in the current working directory.

- Checks if user group `developers` exists. If not create user group.
- Check if users to be created with usernames listed in [csv-file](new_users.csv) already exists.

 If it does, add user to supplementary group `developers`.
- Create new users with username listed in [csv-file](new_users.csv).
- Creates `.ssh` directory in the home directory of users and assign appropriate user permissions to the directory.
- Generates `SSH` connection authorisation keys for each user in the `.ssh` directory.

## Usage:
Run script with user that have root privileges like thus:

```bash
   $ sudo ./onbaording.sh
```

Login to each user using SSH 

```
$ ssh <remote-user>@<ip>
```

OR

```
sudo su < remote-user >
```





