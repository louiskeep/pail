import requests
import requests, zipfile, io
from bs4 import BeautifulSoup

# create session
session = requests.Session()

# The URL you want to post to
login_url = 'https://www.zip-codes.com/account_login.asp'
navigate_url = 'https://www.zip-codes.com/account_dbupdate.asp'  # the URL you want to navigate to

# The data you want to post
payload = {
    'loginUsername': 'telligen',
    'loginPassword': '1776WestLakes!',
    'Action': 'Login',
    'redir': '',
}

# Post the data and get the response
response = session.post(login_url, data=payload)

# Navigate to new page
response = session.get(navigate_url)

# parse the page with BeautifulSoup
soup = BeautifulSoup(response.text, 'html.parser')

# find the download link
download_link = soup.find('a', string='[ Download ]')['href']

# create the full URL by joining the navigate_url and the download_link
download_url = '/'.join(navigate_url.split('/')[:-1]) + '/' + download_link

# download the file
response = session.get(download_url, stream=True)

# check if the download was successful
if response.status_code == 200:
    r = requests.get(download_url)
    with open("/file.zip", "wb") as f:
        f.write(io.BytesIO(r.content))

    #z = zipfile.ZipFile(io.BytesIO(r.content))
    #z.extractall("./")
else:
    print('Download failed with status code:', response.status_code)