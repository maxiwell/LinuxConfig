#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import urllib
import gzip
import os
from BeautifulSoup import BeautifulSoup
from StringIO import StringIO




def showsome(searchfor):
    query = urllib.urlencode({'q': searchfor})
    url = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&%s' % query
    search_response = urllib.urlopen(url)
    search_results = search_response.read()
    results = json.loads(search_results)
    data = results['responseData']
    print 'Total results: %s' % data['cursor']['estimatedResultCount']
    hits = data['results']
    print 'Top %d hits:' % len(hits)
  #  for h in hits: print ' ', h['url']
  #  print 'For more results, see %s' % data['cursor']['moreResultsUrl']
  
    html_page = urllib.urlopen(hits[0]['url'])
    if (html_page.headers['content-encoding'] == 'gzip'):
        buf = StringIO(html_page.read())
        f = gzip.GzipFile(fileobj=buf)
        data = f.read()
    else:
        data = html_page.read()

    soup = BeautifulSoup(data)
    for link in soup.findAll('a'):
        sling = link.get('href')
        if sling and link.get('href').find('magnet') == 0:
            magnet = link.get('href')
            print magnet
            break

    os.system("xdg-open %s" % magnet)


showsome('Homeland S03E06 720 Torrent')


