#!/usr/bin/python

import requests
import time
s = requests.session()

login_data = {
                'LDAPlogin':'xblask00',
                'LDAPpasswd':'CHANGEME',
                'special_p4_form': '1',
                'login_form': '1',
                'sentTime': str(int(time.time())),
                'sv[fdkey]': 'BR0qqTALg9',
            }
#print login_data
s.post('https://www.vutbr.cz/login/in', login_data)

r2 = s.get('https://www.vutbr.cz/studis/student.phtml?sn=aktuality_predmet')
print r2.content
