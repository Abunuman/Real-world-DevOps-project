#!/bin/bash

####################################################

# Script to onboard 20 new Linux users onto a server

####################################################

#Variables

NEW="./new_users.csv"
GROUP="developers"
HOME_DIR="/bin/bash"
PUBLIC_KEY_FILE="/home/ubuntu/.ssh/id_rsa.pub"

# Check if file containing usernames exist

if [ -f $NEW ];
 then
     echo "File exist"
 else
     echo "File doesn't exist"
 fi
# Check if group exists
if [ $(getent group $GROUP) ]; then
  echo "group exists."
else
  echo "group does not exist."
fi
sleep 10


# Add users

# Loop through each line of the CSV file
while read -r username; do
  # Check if the user exists
  if id "$username" >/dev/null 2>&1; then
    echo "User $username already exists."
  else
    # Create the user with /bin/bash shell and home directory
    echo "Creating user $username with /bin/bash shell and home directory"
    sudo useradd -m -s /bin/bash "$username"
    echo "User $username created."
  fi

  # Add the user to the developer group
  if id -nG "$username" | grep -qw "$GROUP"; then
    echo "User $username is already a member of the developer group."
  else
    echo "Adding user $username to the developers group."
    sudo usermod -a -G "$GROUP" "$username"
    echo "User $username added to the developers group."
  fi

  # Check if the .ssh folder exists for the user
  ssh_folder="/home/$username/.ssh"
  if [ ! -d "$ssh_folder" ]; then
    echo "Creating .ssh folder for user $username"
    sudo mkdir "$ssh_folder"
    sudo chown "$username:$username" "$ssh_folder"
    sudo chmod 700 "$ssh_folder"
  fi

  # Create the authorized_keys file and add the public key of the current user
  authorized_keys_file="$ssh_folder/authorized_keys"
  if [ ! -f "$authorized_keys_file" ]; then
    echo "Creating authorized_keys file for user $username"
    touch "$authorized_keys_file"
    sudo chown "$username:$username" "$authorized_keys_file"
    sudo chmod 600 "$authorized_keys_file"
  fi
  echo "Adding public key to authorized_keys file for user $username"
  cat "$PUBLIC_KEY_FILE" >> "$authorized_keys_file"

done < "$NEW"
