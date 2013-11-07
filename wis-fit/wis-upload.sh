#!/bin/bash

#
# WIS Upload script
# Usage: ./script <login> <cid> <item> <filename>
# Author: Branislav Blaskovic
#

# Invalid data == help
if [ $# -ne 4 ]
then
    echo "WIS Upload script"
    echo "Author: Branislav Blaskovic"
    echo "Usage:"
    echo -e "\t$0 <login> <cid> <item> <filename>"
    echo -e "\t$0 <login> <cid> <item> <filename> <<< \"password\" # without password prompt"
    exit 1
fi

# Some values
LOGIN=$1
CID=$2
ITEM=$3
FILENAME=$4
URL_UPLOAD="wis.fit.vutbr.cz/FIT/st/course-sf.php"

# Ask for password
read -s -p "Password for $LOGIN: " PASS
echo

# Prepare URL
CURL="curl --insecure  --header \"Accept-Language: cs\" https://$LOGIN:$PASS@"

# Upload it
${CURL}$URL_UPLOAD -F "file=/ci/$CID/$ITEM/$LOGIN" -F "cid=$CID" -F "item=$ITEM" -F "MAX_FILE_SIZE=500000" -F "uploadbutton=uploadbutton" -F "upload_1=@$FILENAME" >/dev/null 2>/dev/null

# Check it
${CURL}${URL_UPLOAD}?cid=$CID\&item=$ITEM 2>/dev/null | grep "$FILENAME" >/dev/null

# Check it
if [ $? -eq 0 ]
then
    echo "Successful"
    exit 0
else
    echo "Some error"
    exit 1
fi


