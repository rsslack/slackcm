#!/bin/bash

#Hello World Web Application variables

service_copy_files=1
run_service_function=1

#Custom functions for base class
service_function()
{
    echo -e "\nRunning $service_type functions:"
    iptables_config

}

iptables_config()
{
    echo "Configuring iptables"
    /sbin/iptables-restore < $slackcm_root/service_type/$service_type/config/slack-iptables.dump

}
