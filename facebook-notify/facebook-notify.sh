#!/bin/bash
odpoved=$(zenity  --list  --text "Choose the action!"  --column " " "Dance for me!" "Facebook notification")

echo $odpoved | grep -i dance >/dev/null 2>/dev/null

if [ $? -eq 0 ]
then
    # Dance for me!
    echo "dance dance!"
else
    # Facebook
    email=$(zenity --entry --text "Facebook e-mail: ")
    pass=$(zenity --entry --hide-text --text "Facebook pass: ")
    wget "https://www.facebook.com/login.php?login_attempt=1" --post-data "email=$email&pass=$pass" --no-check-certificate \
        --keep-session-cookies --save-cookies=piskot -S -U "Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" \
        --load-cookies=piskot -O tajmlajn

    wget "http://www.facebook.com/notifications" --no-check-certificate \
        --keep-session-cookies -S -U "Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" \
        --load-cookies=piskot -O notifikejsen

    RSS_URL=$( sed "s/href/href\n/g" notifikejsen | grep RSS | awk -F\" '{print $2}' | sed "s/\&amp;/\&/g")

    . get-notifications.sh
fi
