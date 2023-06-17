#!/bin/bash

# ----------------------------------------------------------------------
# Script Name: ChatGPT Email Assistant
# Author: Vontainment
# Created: 2023-06-16
# Updated: 2023-06-16
#
# Description:
# This script installs necessary Python packages and sets up the
# email environment to use an AI assistant for automatic email responses.
# It updates Dovecot's configuration, moves necessary Sieve scripts to
# their respective directories, and sets appropriate permissions.
# ----------------------------------------------------------------------

# Check for Python
if ! command -v python3 &> /dev/null
then
    echo "Python3 could not be found. Installing..."
    sudo apt-get update
    sudo apt-get install -y python3
else
    echo "Python3 is already installed."
fi

# Check for pip
if ! command -v pip3 &> /dev/null
then
    echo "pip3 could not be found. Installing..."
    sudo apt-get update
    sudo apt-get install -y python3-pip
else
    echo "pip3 is already installed."
fi

# Check for openai
pip3 show openai > /dev/null 2>&1
if [ $? -eq 1 ]; then
    echo "openai is not installed. Installing..."
    pip3 install openai
else
    echo "openai is already installed."
fi

# Check for beautifulsoup4
pip3 show beautifulsoup4 > /dev/null 2>&1
if [ $? -eq 1 ]; then
    echo "beautifulsoup4 is not installed. Installing..."
    pip3 install beautifulsoup4
else
    echo "beautifulsoup4 is already installed."
fi

# Check for email
pip3 show email > /dev/null 2>&1
if [ $? -eq 1 ]; then
    echo "email is not installed. Installing..."
    pip3 install email
else
    echo "email is already installed."
fi

# Update dovecot.conf to add a new mailbox called "Send To AI"
echo "Updating dovecot.conf to add a new mailbox called 'Send To AI'..."
sed -i '/mailbox Archive {/,/}/ a \
\
    mailbox "Send To AI" {\
    auto = subscribe\
    special_use = \\AIsend\
    }\

' /etc/dovecot/dovecot.conf

# Create a new sieve directory and copy AI assistant sieve scripts
echo "Creating a new sieve directory and copying AI assistant sieve scripts..."
mkdir -p /var/mail/sieve
mv ./imapsieve_globalreply /etc/dovecot/sieve/
mv ./ai_assistant.sieve /var/mail/sieve/
mv ./21-ai-assistant.conf /etc/dovecot/conf/

# Copy ai.conf file to each user's mailbox directory
echo "Copying ai.conf file to each user's mailbox directory..."
for dir in /home/*/mail; do
    cp ./ai.conf "$dir"
done

# Set file permissions
echo "Setting file permissions..."
chmod 644 /etc/dovecot/conf/21-ai-assistant.conf
chown root:root /etc/dovecot/conf/21-ai-assistant.conf
chmod 777 /var/mail/sieve
chown mail:mail /var/mail/sieve
chmod 644 /var/mail/sieve/ai_assistant.sieve
chown mail:mail /var/mail/sieve/ai_assistant.sieve
chmod 755 /etc/dovecot/sieve/imapsieve_globalreply
chown dovecot:mail /etc/dovecot/sieve/imapsieve_globalreply

# Update the ownership of ai.conf files
echo "Updating the ownership of ai.conf files..."
for dir in /home/*/mail; do
    cp ./ai.conf "$dir"
    chmod 664 "$dir"/ai.conf
    owner=$(basename $(dirname "$dir"))
    chown "$owner":mail "$dir"/ai.conf
done
