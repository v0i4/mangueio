import cloudscraper
import sys

query = sys.argv[1]

scraper = cloudscraper.create_scraper()

url_string = 'https://www.olx.com.br/estado-sc/florianopolis-e-regiao?q=' + '' + query
res = scraper.get(url_string)

for page in range(1, 5):
    url_string = 'https://www.olx.com.br/estado-sc/florianopolis-e-regiao?q=' + '' + query + '&o=' + str(page)
    res = scraper.get(url_string)
    print (res.text)

