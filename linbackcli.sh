#!/bin/bash
#
# Mass Copy to Backup
# Copies files located in Pictures, Music, Videos, Downloads, and Desktop into a backup folder.
# Custom Directories can be added, existing ones can be removed.
#

#Makes Settings File. UNFINISHED! SETTINGS WILL BE A NEW FEATURE SOON!
#if [ ! -d "settings.txt" ] # Checks if settings file exists.
#then
    #touch settings.txt # Makes settings file if it doesn't exist.
#fi

#Unfinished Settings File Checker .
# {
#[ -s settings.txt ] #Checks Settings
#echo $?
#read -r settings
#} &> /dev/null #Hide Output

#Gets Username
{ 
whoami
} &> /dev/null #Hide Username
user=$(whoami) #Sets username to variable, "user".
echo ""
echo "Hello," "$user""!"
echo "Welcome to CLI Linux Backup Tool 1.0!"
echo ""

#Skips intro if settings exists. UNFINISHED! SKIP INTRO WILL BE A NEW FEATURE SOON!
#if [ "$settings" = 1 ]
#then
#echo "Start process without changing settings?"
#read -r skipintro
#fi
#if [ "$skipintro" = "no" ] || [ "$skipintro" = "n" ] 
#then

echo "Type the NAME of the device partion you want to use (Ex. sda1, sda2, sdb5)."
echo "If you don't know, type 'help'"
read -r vardev
if [ "$vardev" = "help" ] #Checks if you need help.
then
    lsblk -e7 -f -o name,label,size #Pulls up device list.
    echo "Type the NAME of the device partion you want to use (Ex. sda1, sda2, sdb5)."
    read -r vardev #vardev is the name variable.
fi
#$vardev >> settings.txt #Saves settings to settings file.
#Prompts User to Enter Device Label
echo "Type the LABEL of the device partion you want to use (Ex. SanDisk, USB Drive, SD Card)."
#echo "If you don't know, type 'help'"
read -r varlab #varlab is the label variable.
echo "NAME: ""$vardev"" LABEL: ""$varlab""."
#$varlab >> settings.txt
#else
    #Unfinished Code Goes Here
#fi

# MOUNTING (UNFINISHED & BUGGY)
#cd /
#cd /run/media/"$user" || exit
#if mountpoint -q /mnt/foo 
#then
#   echo "This device is mounted!"
#else
#   sudo mount /dev/"$vardev" /run/media/"$user"/"$vardev" #Mounts Drive
#fi
#if [ ! -d "$vardev" ] 
#then
#    sudo mkdir -p "$vardev" #Makes folder if a mount folder by this name isn't here.
#fi

dircount=0 #Sets counter for each directory chosen.
cd / #Goes to Root of Linux Filesystem

#UPDATE BACKUP FOR DOCUMENTS
let "dircount++"
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Documents /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."

#UPDATE BACKUP FOR PICTURES
let "dircount++"
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Pictures /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."

#UPDATE BACKUP FOR DESKTOP
let "dircount++"
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Desktop /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."

#UPDATE BACKUP FOR DOWNLOADS
let "dircount++"
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Downloads /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."

#UPDATE BACKUP FOR MUSIC
let "dircount++"
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Music /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."

#UPDATE BACKUP FOR VIDEOS
let "dircount++"
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/VIDEOS /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."

#Finishing Message
echo "If there are no errors above, all your files copied successfully."

#UPDATE BACKUP TEMPLATE
#let "dircount++"
#echo "DIR Copying files, this may take a while. CTRL+C to cancel."
#sudo cp -n -R [DIRECTORY OF YOUR CHOICE] /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
#echo "Copying for Directory ""$dircount"" done."

#Do not use the template from below the line above. The following is not finished.
#sudo cp -n -R /run/media/"$user"/"$vardev" ~/Documents #Update Backup UNFINISHED (BUGGY AT THE MOMENT)
