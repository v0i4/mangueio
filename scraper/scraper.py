import cloudscraper
import sys

query = sys.argv[1]

scraper = cloudscraper.create_scraper()

url_string = 'https://www.olx.com.br/estado-sc?q=' + '' + query
res = scraper.get(url_string)
print (res.text)

