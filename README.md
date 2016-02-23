slackcm
==========

slackcm is the primitive configuration management system for all slack server classes.


Deploying to slackcm to a server
------

1) Map host to service class in hosts.bash

2) Ensure server class exists in service\_class dir. Use hw_app as a template.

2) Run slackcm on:
    
    a) localhost 
    `./slackcm.sh run`
    
    b) Remote host (host must be added to hosts.bash)
    `./slackcm.sh deploy <hostname>`
