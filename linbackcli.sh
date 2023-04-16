#!/bin/bash
#
# Mass Copy to Backup
# Copies files located in Pictures, Music, Videos, Downloads, and Desktop into a backup folder.
# Custom Directories can be added, existing ones can be removed.
#

dirArr=()
#The intro function.
intro() {
    { rm settings.txt
    } &> /dev/null #Clears settings by deleting file if it exists. Also ignores errors.
    touch settings.txt # Makes settings file again.
    echo "Type the ID of the device partition you want to use (Ex. sda1, sda2, sdb5)."
    echo "If you don't know, type 'help' or 'h'."
    read -r vardev
    if [ "$vardev" = "help" ] || [ "$vardev" = "h" ] #Checks if you need help.
    then
        lsblk -e7 -f -o name,label,size #Pulls up device list.
        echo "Type the ID of the device partition you want to use (Ex. sda1, sda2, sdb5)."
        read -r vardev #vardev is the name variable.
    fi
    {
        echo "name:" "$vardev" >> settings.txt
        echo "directories:" >> settings.txt
    } &> /dev/null #Hides writing of files.
    adddir
}

#Adds Directories
adddir(){
    echo "Type each directory you want to have backed up. To stop adding directories, type 'STOP' in all caps."
    while [ "$tempArr" != "STOP" ]
    do    
        read -r tempArr
        if [ "$tempArr" != "STOP" ]
        then
            dirArr=("$tempArr" "${dirArr[@]}")
            echo "$tempArr" >> settings.txt
            echo "Directory ""$tempArr"" added! To stop adding directories, type 'STOP' in all caps."
        fi
    done
}

#Gets Username
{ 
whoami #Gets username.
directory=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) #Gets directory of this file and stores it in a variable.
} &> /dev/null #Hide Username
user=$(whoami) #Sets username to variable, "user".
echo ""
echo "Hello," "$user""!"
echo "Welcome to CLI Linux Backup Tool 3.0!"
echo "Located at ""$directory""."
echo ""

#Makes Settings File.
echo ""
cd "$directory" || exit
if [ -f "settings.txt" ] # Checks if settings file exists.
then
    #Skips intro if settings exists.
    echo "Start process without changing settings or adding new folders? [Y/n]"
    read -r skipintro
    if [ "$skipintro" = "no" ] || [ "$skipintro" = "n" ] 
    then
        intro
    else
        vardev=$(sed -n '1p' settings.txt | awk '{print $2}') #Gets Device Name from Settings File
        #echo "$vardev"
        while IFS= read -r line
        do
            if [ "$line" != "directories:" ] || [ "$line" != "name= ""$vardev" ]
            then
                dirArr=("$line" "${dirArr[@]}")
            fi
        echo "${dirArr[@]}"
        done < <(tail -n 2 settings.txt) #Makes sure it only prints past directories.
    fi
else
    intro
fi
echo ""

#SEARCHES FOR DEVICE MOUNT DIRECTORY
findmountdir(){
    {
        mntdir=$(findmnt -o TARGET,SOURCE /dev/"$vardev" | tail -n 1 | awk '{print $1}') #Searches for Mount and Defines to Variable
    } &> /dev/null #Hide
        echo "Your device is currently mounted at ""$mntdir""."
}

# MOUNTING
cd /
echo "Checking if device is mounted..."
findmountdir
if [ "$mntdir" = "" ];
    then
        cd /mnt/ || exit
        { 
            #sudo rm -r "$vardev" #In case the folder exists.
            sudo mkdir "$vardev" #Makes folder if a mount folder by this name isn't here.
        } &> /dev/null #Hide
        findmountdir
    fi
{ sudo mount /dev/"$vardev" /mnt/"$vardev" #Mounts device.
} &> /dev/null #Hide

# COPYING/SYNCING
cd / #Goes to Root of Linux Filesystem
for i in "${!dirArr[@]}"
do
echo ""
echo "Directory ""${dirArr[$i]}"": Copying files, this may take a while. CTRL+C to cancel."
    if [ -d "$mntdir"/LinBackups/"${dirArr[$i]}" ]
    then
        sudo mkdir -p "$mntdir"/LinBackups
        sudo cp -R "${dirArr[$i]}" "$mntdir"/LinBackups/ #Copies to Backup Drive
    else
        sudo rsync -r "${dirArr[$i]}" "$mntdir"/LinBackups/ #Syncs with Backup Drive
    fi
    echo "Copying for Directory ""${dirArr[$i]}"" done."
    echo ""
done
echo "If there are no errors above, all your files copied successfully."
cd "$directory" || exit
#Finishing Message
