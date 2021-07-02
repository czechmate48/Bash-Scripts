#!/bin/bash

#Created by Christopher N. Sefcik, 8/21/2020

#INFO: 	This script backs up the specified source folder to the specified source location
#	It is intended to be scheduled via cron.
#USE:	backup.sh <backup_source> <backup_destination> <log_destination> <backup_capacity>

# Backups up a specified directory using the bash shell.
# Maintains a specified number of backups per input (num_backups).
# Designed to be run as a cron job at an interval specified by the user.

# backup.sh [source] [destination] [log_destination] [backup_capacity]

    # source: Must be an existing directory. Program will exit if source does not exist
    # destination: Does not need to be an existing directory. Program will create directory if one does not exist
    # log_destination: Must be an existing location. The log will be named backup_log and will be placed in this directory
    # backup_capacity: Number of backups to retain. Program will delete the oldest backup when the capacity is reached


####################
backup_source=$1 
backup_destination=$2
log_destination=$3
backup_capacity=$4
log_file="backup.log"
####################

write_to_log(){
	local now=$(date)
	echo "$now: $1" >> $log_destination/$log_file
}

####################

display_backup_source_error(){
	echo "Backup source does not exist."
	echo "Please specify a valid directory path"
}

check_backup_source() {
	if [ ! -d $backup_source ]; then { #Does not exist
		write_to_log "$backup_source does not exist"
		display_backup_source_error
		write_to_log "Exiting backup"
		exit	
	}
	fi
}

####################

configure_backup_destination() {
	if [ ! -d $backup_destination ]; then { #Does not exist
		write_to_log "$backup_destination does not exist"
		write_to_log "Creating $backup_destination"
		mkdir -p $backup_destination
		write_to_log "$backup_destination created"
	}
	fi
}

####################

delete_oldest_backup(){
	local oldest_backup=$(ls -t $backup_destination | tail -1)
	write_to_log "Deleting oldest backup: $oldest_backup"
	rm -r $backup_destination/$oldest_backup
	write_to_log "Backup $oldest_backup successfully deleted"
}

copy_backup(){
	write_to_log "Creating backup in $backup_destination"
	local backup_name=$(date +%m-%d-%Y_{%H-%M})
	cp -r $backup_source $backup_destination/$backup_name
	write_to_log "Backup $backup_name created"
}

create_backup(){
	local num_backups=$(ls $backup_destination | wc -l)
	if [ $num_backups -ge $backup_capacity ]; then {
		write_to_log "Destination directory at backup capacity"
		delete_oldest_backup
	} else {
		write_to_log "$num_backups backups in file"
	}
	fi
	copy_backup
}

#####################
write_to_log "Backup started"
check_backup_source
configure_backup_destination
create_backup
write_to_log "Backup complete"
#####################
