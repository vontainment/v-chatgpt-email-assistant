require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "variables"];

if environment :matches "imap.user" "*" {
    set "username" "${1}";
}

pipe :copy "imapsieve_globalreply" [ "${username}" ];
