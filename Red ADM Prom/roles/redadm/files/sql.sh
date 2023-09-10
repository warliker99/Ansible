#!/bin/bash

echo -e "set sql dialect 3;\ncreate database '/db/redadm.fdb' page_size 16384;\ncommit;\nconnect '/db/redadm.fdb';\ncommit;\ncreate user redadm password 'redadm' grant admin role;\ncommit;\ngrant all database to redadm;\ngrant all table to redadm;\ngrant all view to redadm;\n grant all procedure to redadm;\ngrant all function to redadm;\ngrant all package to redadm;\ngrant all generator to redadm;\ngrant all sequence to redadm;\ngrant all domain to redadm;\ngrant all exception to redadm;\ngrant all role to redadm;\ngrant all character set to redadm;\n grant all collation to redadm;\ngrant all filter to redadm;\ncommit;\nquit;
" |isql-fb -user SYSDBA -password QAZxsw123
