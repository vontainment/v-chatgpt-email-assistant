![Header](./20230619_031337_0000.png)

# v-chatgpt-email-assistant
Easy email rerplies by ChatGPT. Creates an AI Assistant folder that you can move mail to. Once mail has been moved there it'll be processed for a reply, and then the reply will be placed in the draft folder. Prompt and api key is global except in the beta version. The AI Prompt and API keys can we set per user in our beta version. WIP!

## Requierments?
- Dovecot
- Sieve
- Python 3.*
- Pip3 + "pip3 install openai beautifulsoup4 email"

### How does This Work?
- (21-ai-assistant.conf)
This code is a configuration file for the Dovecot that sets up Sieve plugins and specifies various settings related to email filtering. Here's what each section of the code does:

Plugin
The plugin section specifies the Sieve plugins that should be loaded by the server. This script loads two plugins: sieve_imapsieve and sieve_extprograms. The sieve_imapsieve plugin allows the server to use IMAP to access users' Sieve scripts, while the sieve_extprograms plugin enables the use of external programs in Sieve scripts.

imapsieve_url
The imapsieve_url setting specifies the URL of the IMAP server that hosts users' Sieve scripts. In this case, the URL is sieve://127.0.0.1:4190, which means that the server is running on the same machine as the Nginx server and is listening on port 4190.

imapsieve_mailbox3_name
The imapsieve_mailbox3_name setting specifies the name of the mailbox where incoming email messages should be filtered to. In this case, the mailbox is named "Send To AI".

imapsieve_mailbox3_causes
The imapsieve_mailbox3_causes setting specifies the actions that should trigger filtering of incoming email messages to the "Send To AI" mailbox. In this case, the COPY and APPEND actions will cause messages to be copied to the "Send To AI" mailbox.

imapsieve_mailbox3_before
The imapsieve_mailbox3_before setting specifies the location of the Sieve script that should be executed before messages are copied to the "Send To AI" mailbox. In this case, the script is located at /var/mail/sieve/ai_assistant.sieve.

sieve_pipe_bin_dir
The sieve_pipe_bin_dir setting specifies the directory where external programs used in Sieve scripts are located. In this case, the directory is /etc/dovecot/sieve.

sieve_global_extensions
The sieve_global_extensions setting specifies the extensions that should be enabled for all Sieve scripts. In this case, the +vnd.dovecot.pipe and +vnd.dovecot.environment extensions are enabled, which means that Sieve scripts can use external programs and access environment variables.

- (ai_assistant.sieve)
This code is a Sieve script that pipes incoming email messages to an external Python script for processing. Here's what each section of the code does:

Require
The require statement specifies the capabilities required for this script to run. This script requires the vnd.dovecot.pipe, copy, imapsieve, environment, and variables capabilities.

If Statement
The if statement checks if the imap.user environment variable matches any value. If it does, it sets the username variable to the value of the first wildcard capture group (${1}). The imap.user environment variable contains the username of the currently logged-in user.

Pipe
The pipe command specifies that the incoming email message should be piped to an external program called imapsieve_globalreply.py. The :copy modifier ensures that the original email message is not deleted after being processed by the external program. The [ "${username}" ] argument passes the value of the username variable as a command-line argument to the external program.

In summary, this script pipes incoming email messages to an external Python script called imapsieve_globalreply.py and passes the username of the currently logged-in user as a command-line argument to the script. The Python script is responsible for processing the email message and generating a reply.

- (imapsieve_globalreply.py)
This code is a Python script that processes incoming emails, sends them to an AI for processing, and then creates a reply email based on the AI's response. Here's what each section of the code does:

Shebang
The shebang line #!/usr/bin/env python3 specifies the interpreter to be used to run the script.

Imports
The script imports several modules such as os, re, sys, base64, email, openai, time, and BeautifulSoup. These modules provide functionality for reading and writing files, parsing email messages, encoding and decoding data, working with regular expressions, and interacting with OpenAI's API.

Constants
The script sets a constant USER to the first command-line argument passed to the script. It then splits this value into two parts, user_email and domain.

Functions
The script defines several functions:

get_nixuser_from_conf(domain): This function reads the domain's configuration file and extracts the directory name after /home/.
get_config_values(nixuser): This function reads the user's configuration file and extracts the user key and instructions.
decode_mail(email_data): This function decodes an email message and extracts its sender name and email address, recipient email address, subject, and body.
send_to_ai(from_name, subject, body): This function sends the extracted information from the email to OpenAI's API for processing and returns the AI's response.
create_reply(from_email, subject, body, new_msg, to_email): This function creates a reply email message using the extracted information from the original email and the AI's response.
process_email(email_data): This function calls the other functions to process an incoming email message.
Main Script
The script reads the email message from standard input, calls process_email(email_data) to process the message, and then exits.



### To-Dos
- Add Logging
- Add multi user option
- Figure out how not to hardcode in the linux account name
- Figure out a secure way to make the open API key user based
