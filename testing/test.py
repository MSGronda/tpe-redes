import requests
import concurrent
from concurrent.futures import ThreadPoolExecutor
import sys

if len(sys.argv) < 2:
	print("Missing number of threads argument!")
	exit(1)

MAX_REQUESTS = int(sys.argv[1])

def submit_get(url):
    response = requests.get(url)
    if response.status_code == 403:
    	print("Got 403 from request!")

urls = ["http://localhost/rwebapp/" for i in range(MAX_REQUESTS)]

with ThreadPoolExecutor(max_workers=MAX_REQUESTS) as executor:
	executor.map(submit_get, urls)

print("Finished doing requests!")