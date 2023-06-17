# ----------------------------------------------------------------------
# Script Name: ChatGPT Email Assistant
# Author: Vontainment
# Created: 2023-06-16
# Updated: 2023-06-16
#
# Description:
# This Sieve script is part of a project to automate email responses
# using OpenAI's GPT-3 model. It applies various filtering rules to
# incoming emails and routes them appropriately.
# ----------------------------------------------------------------------

require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "variables"];

if environment :matches "imap.user" "*" {
    set "username" "${1}";
}

pipe :copy "imapsieve_chatgpt.py" [ "${username}" ];
