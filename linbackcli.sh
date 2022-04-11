#!/bin/bash
#
# Mass Copy to Backup
# Copies files located in Pictures, Music, Videos, Downloads, and Desktop into a backup folder.
# Custom Directories can be added, existing ones can be removed.
#

#The intro function.
intro() {
    echo "Type the NAME of the device partion you want to use (Ex. sda1, sda2, sdb5)."
    echo "If you don't know, type 'help'"
    read -r vardev
    if [ "$vardev" = "help" ] #Checks if you need help.
    then
        lsblk -e7 -f -o name,label,size #Pulls up device list.
        echo "Type the NAME of the device partion you want to use (Ex. sda1, sda2, sdb5)."
        read -r vardev #vardev is the name variable.
    fi
    #Prompts User to Enter Device Label
    echo "Type the LABEL of the device partion you want to use (Ex. SanDisk, USB Drive, SD Card)."
    #echo "If you don't know, type 'help'"
    read -r varlab #varlab is the label variable.
    echo "NAME: ""$vardev"" LABEL: ""$varlab""."
    {
        #cd "$directory" || exit
        echo "label=" "$varlab" >> settings.txt
        echo "name=" "$vardev" >> settings.txt
    } &> /dev/null #Hides writing of files.
}


#Gets Username
{ 
whoami #Gets username.
directory=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) #Gets directory of this file and stores it in a variable.
} &> /dev/null #Hide Username
user=$(whoami) #Sets username to variable, "user".
echo ""
echo "Hello," "$user""!"
echo "Welcome to CLI Linux Backup Tool 2.0!"
echo ""

#Makes Settings File. UNFINISHED! SETTINGS WILL BE A NEW FEATURE SOON!
echo ""
cd "$directory" || exit
if [ -f "settings.txt" ] # Checks if settings file exists.
then
    #Skips intro if settings exists. UNFINISHED! SKIP INTRO WILL BE A NEW FEATURE SOON!
    echo "Start process without changing settings? [y/n]"
    read -r skipintro
    if [ "$skipintro" = "no" ] || [ "$skipintro" = "n" ] 
    then
        intro
    #else
    #    while IFS= read -r line; do
    #        echo "Text read from file: $line"
    #    done < settings.txt
    fi
else
    #cd "$directory" || exit
    touch settings.txt # Makes settings file if it doesn't exist.
    intro
fi
echo ""

# MOUNTING
cd /
echo "Mounting device..."
if [ -f /run/media/"$user"/"$varlab" ];
    then
        cd /run/media/"$user" || exit
        { sudo mkdir -p "$vardev" #Makes folder if a mount folder by this name isn't here.
        } &> /dev/null #Hide
    fi
{ sudo mount /dev/"$vardev" /run/media/"$user"/"$varlab" 
} &> /dev/null #Hide

dircount=0 #Sets counter for each directory chosen.
cd / #Goes to Root of Linux Filesystem

#UPDATE BACKUP FOR DOCUMENTS
let "dircount++"
echo ""
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Documents /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."
echo ""

#UPDATE BACKUP FOR PICTURES
let "dircount++"
echo ""
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Pictures /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."
echo ""

#UPDATE BACKUP FOR DESKTOP
let "dircount++"
echo ""
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Desktop /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."
echo ""

#UPDATE BACKUP FOR DOWNLOADS
let "dircount++"
echo ""
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Downloads /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."
echo ""

#UPDATE BACKUP FOR MUSIC
let "dircount++"
echo ""
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Music /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."
echo ""

#UPDATE BACKUP FOR VIDEOS
let "dircount++"
echo ""
echo "Directory ""$dircount"": Copying files, this may take a while. CTRL+C to cancel."
sudo cp -n -R ~/Videos /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
echo "Copying for Directory ""$dircount"" done."
echo ""

#Finishing Message
echo "If there are no errors above, all your files copied successfully."

#UPDATE BACKUP TEMPLATE
#let "dircount++"
#echo "DIR Copying files, this may take a while. CTRL+C to cancel."
#sudo cp -n -R [DIRECTORY OF YOUR CHOICE] /run/media/"$user"/"$vardev"/ #Copies to Backup Drive
#echo "Copying for Directory ""$dircount"" done."

#Do not use the template from below the line above. The following is not finished.
#sudo cp -n -R /run/media/"$user"/"$vardev" ~/Documents #Update Backup UNFINISHED (BUGGY AT THE MOMENT)
