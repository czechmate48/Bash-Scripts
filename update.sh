#!/bin/bash

LOG_FILE="/var/log/update_log"
echo "##########" >> $LOG_FILE
NOW=$(date)
echo $NOW >> $LOG_FILE
echo "##########" >> $LOG_FILE
sudo apt-get update >> $LOG_FILE
echo "##########" >> $LOG_FILE
sudo apt-get upgrade >> $LOG_FILE
echo "$NOW:	UPDATE.SH COMPLETE" >> /var/log/custom_logs	
