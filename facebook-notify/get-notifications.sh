URL="http://www.facebook.com$RSS_URL"

file=notify

function get_that_shit()
{
    wget "$URL" -O $1 --user-agent="Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" >/dev/null 2>/dev/null
    grep -e "<title>" -e "<pubDate>" $1 > ${1}-bak 2>/dev/null
    cp ${1}-bak $1
}

get_that_shit $file-old
cp $file-old $file

while :
do
    diff $file ${file}-old > diffko
    if [ $? -eq 1 ]
    then
        message=$( awk -F'[' '{print $3}' diffko | awk -F']' '{print $1}' )
        date=$( awk -F'>' '{print $2}' diffko | awk -F'<' '{print $1}' )
        echo "$date: $message"
    fi

    cp $file ${file}-old
    get_that_shit $file
    sleep 1
done
