getname =: ('-' ; '') rxrplc 0 pick  ('^[a-z-]+-')&rxmatch rxfrom ]
getscid =: [: ". 0 pick  ('\d+')&rxmatch rxfrom ]
getcsum =: ('[\[\]]' ; '') rxrplc 0 pick  ('\[.*\]')&rxmatch rxfrom ]
