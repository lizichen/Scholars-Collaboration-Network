import requests
import cookielib
import re

url_for_getting_cookies = 'https://www.scopus.com/record/display.uri?eid=2-s2.0-85026394946&origin=resultslist'
r = requests.get(url_for_getting_cookies)
current_cookies = r.cookies

sid_eid_table_json_file = '../SID_EID_Table_except_first_5373.json'

with open(sid_eid_table_json_file, 'r') as sid_eid_file:
	counter = 1
	for line in sid_eid_file:
		sid = line.split(':')[1][1:-7]
		eid = line.split(':')[2][1:-3]

		print('['+str(counter)+'] Getting sid:'+sid+' eid:'+eid+'...')

		current_url = 'https://www.scopus.com/record/display.uri?eid='+eid+'&origin=resultslist'
		res = requests.get(current_url, cookies=current_cookies)
		htmlurl = res.text.encode('utf-8')
		foundAuthorIds = re.findall('authorId=[0-9]*', htmlurl)
		
		target_file = open('sid_'+sid+'_eid_'+eid+'.csv', 'w')
		for authorId in foundAuthorIds:
			target_file.write(sid+','+eid+','+authorId[9:]+'\n')
		target_file.close()

		counter += 1

print('counter='+str(counter))

