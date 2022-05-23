#!/usr/bin/bash

IP_ADDRESS='127.0.0.10'
LINK_NAME='INTERNET'
JSON_FILE='links.json'
SCRIPT_DIR='/opt/scripts/links/'

##########################################
#                                        #
#      Create a Json with Links Name     #
#                                        #
##########################################

for (( i=1; i<=$#; i++));
do
    # I=param J=variable
    param="${!i}"
    # Next argument
    next=$((i+1))
    argument="${!next}"
    # For each argument do:
    if [[ "$param" == '--help' ]];
    then
        printf "this scripts needs speedtest python file in the same directory to work \n
example:\n $0  --ip 128.168.0.1 --name WAN1 --json links.json --dir /opt/scripts/ \n

        --ip        set the Source IP to execute the scripts
        --name      set the name to Internet Link
        --json      set name to json file (links.json)
        --dir       set the directory that are the scripts (/opt/scripts/links/)
                    remmember to put '/' on end


It's recommended use just --ip and --name, all others already have a default\n"
        exit

    elif [[ "$param" == '--ip' ]];
    then
        #set ip for source
        IP_ADDRESS=$argument

    elif [[ "$param" == '--name' ]]; then
        #set name of internet
        LINK_NAME=$argument

    elif [[ "$param" == '--json' ]]; then
        #output json file
        JSON_FILE=$argument

    elif [[ "$param" == '--dir' ]]; then
        #set name of internet
        SCRIPT_DIR=$argument
    else
        continue
    fi
done

#echo $argument

##########################################
#                                        #
#      Create a Json with Links Name     #
#                                        #
##########################################

# Create a json with variable JSON_FILE and SCRIPT_DIR
echo '{' > $SCRIPT_DIR$JSON_FILE
for link in `ls $SCRIPT_DIR`;
do
    # if file is json, pass
    if [[ $link == $JSON_FILE ]];
    then
        continue
    else
        # add a dict for each link
        echo "{'{#LINKNAME}': $link}," >> $SCRIPT_DIR$JSON_FILE
    fi
done
echo '}' >> $SCRIPT_DIR$JSON_FILE
chown zabbix: $SCRIPT_DIR$JSON_FILE

##########################################
#                                        #
#   Create a File with Links Bandwidth   #
#                                        #
##########################################
$SCRIPT_DIR/speed.py --source $IP_ADDRESS --simple > $SCRIPT_DIR$LINK_NAME
