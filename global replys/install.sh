#!/bin/bash

pip3 install openai beautifulsoup4 email

sed -i '/mailbox Archive {/,/}/ a \
\
    mailbox "Send To AI" {\
    auto = subscribe\
    special_use = \\AIsend\
    }\

' /etc/dovecot/dovecot.conf

sudo mkdir -p /var/mail/sieve

mv ./imapsieve_chatgpt.py /etc/dovecot/sieve/
mv ./ai_assistant.sieve /var/mail/sieve/
mv ./21-ai-assistant.conf /etc/dovecot/conf/


sudo chmod 644 /etc/dovecot/conf/21-ai-assistant.conf
sudo chown root:root /etc/dovecot/conf/21-ai-assistant.conf

sudo chmod 777 /var/mail/sieve
sudo chown mail:mail /var/mail/sieve

sudo chmod 644 /var/mail/sieve/ai_assistant.sieve
sudo chown mail:mail /var/mail/sieve/ai_assistant.sieve

sudo chmod 755 /etc/dovecot/sieve/imapsieve_chatgpt.py
sudo chown dovecot:mail /etc/dovecot/sieve/imapsieve_chatgpt.py
