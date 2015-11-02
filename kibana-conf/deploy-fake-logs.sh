#!/bin/bash
# enable script execution: sudo chmod +x *.sh

echo "Load elastic Search with logs exemples"

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "Loading Proxy logs for GeoIP $NOW ... OK"
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 56.42.42.43 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" ""Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 86.217.118.136 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/39.0"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 119.235.235.85 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/39.0"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 86.217.118.136 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/37.0"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 119.235.235.85 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/37.1"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 138.224.0.118 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/37.1"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 149.126.74.176 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/37.2"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 198.240.216.43 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/37.0"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 81.22.38.100 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/37.0"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 56.42.42.43 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" ""Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 185.11.125.49 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" ""Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"'

nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 193.5.110.18 - root [29/Aug/2015:20:54:28 +0000] "GET / HTTP/1.1" 401 596 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36" "-"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 138.224.0.118 - admin [29/Aug/2015:20:54:00 +0000] "GET / HTTP/1.1" 401 194 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" "-"'

nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 198.240.216.43 - admin [29/Aug/2015:20:54:00 +0000] "GET / HTTP/1.1" 401 194 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" "-"'
nc -w0 -u localhost 5000 <<< '<14>'$NOW' vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 193.239.220.79 - admin [29/Aug/2015:20:54:00 +0000] "GET / HTTP/1.1" 401 194 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" "-"'

# nc -w0 -u localhost 5000 <<< '<14>2015-08-31T15:20:00 vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 56.10.10.10 - - [24/Aug/2015:12:11:36 +0000] "GET /api/doc/schema/currency?Authorization=ApiKey%20userame:apikey HTTP/1.1" 301 5 "http://preprod:8000/api/doc/" ""Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"'
# <14>2015-08-31T11:29:11Z vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 172.17.42.1 - ssss [31/Aug/2015:11:29:11 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36" "-"

