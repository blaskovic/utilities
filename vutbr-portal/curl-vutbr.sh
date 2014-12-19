#!/bin/bash

login=$1
pass=$2

data="LDAPlogin=$login&LDAPpasswd=$pass&login_form=1"

> cookies.txt

# Gather XSRF data
curl -s -L -b cookies.txt -c cookies.txt -d "$data" https://vutbr.cz/login > login.html

data2=""

# special_p4_form
special_p4_form=$( grep 'name="special_p4_form"' login.html | awk -F'"' '{print $(NF-1);}' )
data2="$data2&special_p4_form=$special_p4_form"

# sentTime
sentTime=$( grep 'name="sentTime"' login.html | awk -F'"' '{print $(NF-1);}' )
data2="$data2&sentTime=$sentTime"

# sv[fdkey]
fdkey=$( grep 'sv\[fdkey\]' login.html | awk -F'"' '{print $(NF-1);}' )
data2="$data2&sv[fdkey]=$fdkey"

echo $data2

curl -s -L -b cookies.txt -c cookies.txt -d "${data}${data2}" https://vutbr.cz/login/in > login2.html

curl -s -L -b cookies.txt -c cookies.txt https://www.vutbr.cz/studis/student.phtml?lang=0 > intra.html
