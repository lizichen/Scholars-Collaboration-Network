# nl author_publication_urls.txt | xargs -n 2 -P 8 sh -c 'curl -b cookies.txt "$1" > author-$0.csv'

# sample:
# ./get_author_publicationsCsvList.sh ../urls.txt ../cookies.txt

cookiesFile=$2
test=1
while [ $test -lt 5 ]; read URL
do
  echo $URL
  temp="$(cut -d'=' -f8 <<<"$URL")"
  SID="$(cut -d'&' -f1 <<<"$temp")"
  curl -b $cookiesFile "$URL" > $SID.csv
  (( test++ ))
done < $1
echo $test
