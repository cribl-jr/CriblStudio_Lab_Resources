#!/bin/bash

#---ABOUT THIS SCRIPT---

#Name: cribl-leader_install_CentOS10.sh

#What it does: Install a Cribl Stream Leader using Cribl's latest Linux package

#Description: This script will create a user to run Cribl, install cribl, apply permissions, configure systemd to enable cribl, and then start cribl


#---REQUIREMENTS---

## Make sure that ports 9000 and 4200 are open on your network firewall or cloud service provider's security group

## If using NAT, make sure that NAT is forwarding ports 9000 and 4200 to the local IP adress of your host

## Run this script as a priviledged user. If not root, be sure to add sudo to the command

#--- HOW TO CREATE AND RUN THIS SCRIPT ---

### cd /opt

### sudo vi Install-Cribl-Leader_CentOS9.sh
### (Enter into edit mode - you may do this by hitting the "a" key once)
### (Copy this script into VI after entering into edit mode - be sure not to accidentally add any characters to the script)
### (Update the variables in this script) 
### (Hit the escape key to exit out of edit mode - be sure not to accidentally add any characters to the script)
### (Close vi and save by typing ":wq")

### sudo chmod +x cribl-leader_install_CentOS10.sh
### sudo ./cribl-leader_install_CentOS10.sh

#---- ENTER YOUR VARIABLES HERE - THESE ARE NOT OPTIONAL ----

##  --- CUSTOM VARIABLE 1 OF 2 - ENTER YOUR INSTALLATION DIRECTORY HERE. The default is /opt/cribl-stream ---
InstallDir="/opt/cribl-stream"

##  --- CUSTOM VARIABLE 2 OF 2 - ENTER THE USER THAT WILL RUN CRIBL HERE. The default is cribl ---
CriblUser="cribl"


#--- THE ACTUAL SCRIPT ---

# Install the epel-release repos for dependencies
# yes | sudo dnf install epel-release

#Install Cribl Stream dependencies 
sudo dnf install -y git

# Create a user named cribl to run the cribl service and create an .ssh file
sudo adduser $CriblUser
sudo mkdir /home/$CriblUser/.ssh
sudo touch /home/$CriblUser/.ssh/authorized_keys
sudo chmod 600 /home/$CriblUser/.ssh/authorized_keys
sudo touch /home/$CriblUser/.ssh/known_hosts
sudo chmod 600 /home/$CriblUser/.ssh/known_hosts
sudo touch /home/$CriblUser/.ssh/config
sudo chmod 600 /home/$CriblUser/.ssh/config
sudo chown -R $CriblUser:$CriblUser /home/$CriblUser/.ssh

# Download & install the latest version of Cribl Stream
sudo mkdir $InstallDir
sudo curl -Lso - $(curl -s https://cdn.cribl.io/dl/latest) | sudo tar zxvf - -C $InstallDir
sudo chown -R $CriblUser:$CriblUser $InstallDir

# Configure the cribl user’s .bash_profile so that Cribl_Home = your installation directory
echo "CRIBL_HOME=$InstallDir/cribl" | tee -a /home/cribl/.bash_profile

#configure systemd to control cribl
$InstallDir/cribl/bin/cribl boot-start enable -m systemd -u cribl

# Configure the cribl user’s .bash_profile so that Cribl_Home = your installation directory
sudo systemctl enable $CriblUser
sudo systemctl start $CriblUser
