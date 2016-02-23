slackcm
==========

slackcm is the primitive configuration management system for all slack server classes.


Deploying to slackcm to a server
------

1) Map host to service class in hosts.bash

2) Ensure server class exists in service\_class dir and the host has been added to `hosts.bash`. Use hw_app as a template.

3) Run slackcm on:

localhost: `./slackcm.sh run`
    
Remote host: `./slackcm.sh deploy <hostname>`
