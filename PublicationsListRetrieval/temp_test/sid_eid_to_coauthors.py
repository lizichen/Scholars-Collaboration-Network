import requests
import cookielib
import re

url_for_getting_cookies = 'https://www.scopus.com/record/display.uri?eid=2-s2.0-85026394946&origin=resultslist'
r = requests.get(url_for_getting_cookies)
current_cookies = r.cookies

with open('../SID_EID_Table.json', 'r') as sid_eid_file:
	counter = 1
	for line in sid_eid_file:
		sid = line.split(':')[1][1:-7]
		eid = line.split(':')[2][1:-3]

		print('Getting sid:'+sid+' eid:'+eid+'...')

		current_url = 'https://www.scopus.com/record/display.uri?eid='+eid+'&origin=resultslist'
		res = requests.get(current_url, cookies=current_cookies)
		htmlurl = res.text.encode('utf-8')
		foundAuthorIds = re.findall('authorId=[0-9]*', htmlurl)
		
		target_file = open('sid_'+sid+'eid_'+eid+'.csv', 'w')
		for authorId in foundAuthorIds:
			target_file.write(sid+','+authorId[9:]+'\n')
		target_file.close()

		if counter == 10:
			break
		else:
			counter += 1


'''
url = 'https://www.scopus.com/record/display.uri?eid=2-s2.0-85026394946&origin=resultslist'

r = requests.get(url)

res = requests.get(url,cookies=r.cookies)

htmlurl = res.text.encode('utf-8')

foundauthorIds = re.findall('authorId=[0-9]*', htmlurl)

filehtml = open('test.html', 'w')
filehtml.write(res.text.encode('utf-8')
filehtml.close()

'''
