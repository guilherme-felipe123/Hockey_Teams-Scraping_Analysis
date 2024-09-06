from bs4 import BeautifulSoup
from urllib.request import Request, urlopen
import pandas as pd
import pymysql

next_page = '/pages/forms/?page_num=1'
headers = ['team_name', 'year_played', 'wins', 'losses', 'ot_losses', 'win_percentage', 'goals_for', 'goals_against']
rows = []

conn = pymysql.connect(
        host='localhost',
        user='guilherme', 
        passwd='@Linux15243', 
        db='mysql')

cur = conn.cursor()
cur.execute('USE Hockey_Teams')

while next_page:
    req = Request(url=f'https://www.scrapethissite.com{next_page}',headers={'User-Agent': 'Mozilla/5.0'})
    html = urlopen(req).read()
    page = BeautifulSoup(html,'html.parser')
    table = page.find('table')
    query = '''
    INSERT INTO pages (team_name, year_played, wins, losses, ot_losses, win_percentage, goals_for, goals_against)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    '''
    for i, row in enumerate(table.find_all('tr')[1:]):
        data = ([x.get_text().strip() if len(x.get_text().strip()) else '0'  for x in row.find_all('td')][:-1])
        print(data)
        rows.append(data)
        #cur.execute(query, data)
        #cur.connection.commit()

    if page.find_all('a',href=True)[-1]['href'] != next_page:
        next_page = page.find_all('a',href=True)[-1]
        next_page = next_page['href']
    else:
        next_page = None
    
    print(next_page)

dataframe = pd.DataFrame(rows, columns=headers)
dataframe.to_csv('Hockey_Teams.csv')
cur.close()
conn.close()
