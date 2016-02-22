#!/bin/bash

#Defined functions for slackcm


#Install server_type packages
slackcm_server_type_installs()
{
    echo -e "\nInstall $server_type packages: $service_pkgs"
    /usr/bin/apt-get install $service_pkgs -qq -y
    echo -e "$server_type packages installed."
}

#slackcm sync function
slackcm_sync_files()
{
    if [[ $service_files = 1 ]]; then
    	echo -e "\nCopying $server_type files:"
        /usr/bin/rsync -a --no-perms $slackcm_root/server_type/$server_type/files/* /.
        echo -e "$server_type files copy complete."
    else
        echo -e "\nservice_files var isn't defined in $slackcm_root/server_type/$server_type/$server_type.bash. If you would like to copy files for $server_type, add \"server_files=1\" in $server_type.bash.\n"    
    fi 
}


slackcm_sync_config()
{
    if [[ $service_config = 1 ]]; then
        
        #Check if the config exists on the server
        if [[ -f $slackcm_root/server_type/$server_type/config/$server_type_config ]]; then
            
            #Config exists. Now do check if the config is the same
            if [[ `md5sum < $slackcm_root/server_type/$server_type/config/$server_type_config` = `md5sum < $server_type_config_dir/$server_type_config` ]]; then
                echo -e "\nThe config on the server is the same as the config on the repo."
            else 
                echo "The config is different from the repo. Copying $server_type config."
                /usr/bin/rsync -a --no-perms $slackcm_root/server_type/$server_type/config/$server_type_config $server_type_config_dir
                restart_app=1
                echo "$server_type config copy complete."
             fi
        else
                echo "The config doesn't exist on the server. Copying $server_type config."
                /usr/bin/rsync -a --no-perms $slackcm_root/server_type/$server_type/config/$server_type_config $server_type_config_dir
                restart_app=1
                echo "$server_type config copy complete."
        fi 
        if [[ $service_auto_restart = 1 ]] && [[ $restart_app = 1 ]]; then
            #Automatically restart the service
            /usr/sbin/service $service_name restart
        elif [[ $service_auto_restart != 1 ]] && [[ $restart_app = 1 ]]; then
             echo "$service_name wasn't automatically restarted because service_auto_restart var wasn't defined. $service_name needs to be restarted before the new config changes take effect."
        fi
    else
        echo -e "\nservice_config var isn't defined in $slackcm_root/server_type/$server_type/$server_type.bash. If you would like to copy config for $server_type, add \"server_config=1\" in $server_type.bash.\n"    
    fi 
}

slackcm_cron()
{
    #Copy slackcm cron
    /usr/bin/rsync -av -qq --no-perms $slackcm_root/slackcm_files/slackcm-cron $slackcm_cron_file
}
