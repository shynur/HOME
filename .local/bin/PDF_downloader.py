#! python3.12
import re
import urllib.request
import urllib.parse

target_addr = "http://222.215.40.229:8888"
target_path = "/newbook/eco/"
target_url = target_addr + target_path
downloads_dir = "D:/Downloads/Tmp/"

with urllib.request.urlopen(target_url) as response:
    target_content: str = response.read().decode(
        response.headers.get_content_charset() or "utf-8"
    )

target_links: list[str] = [
    target_addr + path
    for path in re.findall(r'<A [^>]*HREF=["\']([^"\']+)["\']', target_content)
][1:]

for link in target_links:
    urllib.request.urlretrieve(
        link, downloads_dir + urllib.parse.unquote(link.split("/")[-1])
    )
