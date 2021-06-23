import time
from selenium import webdriver
from bs4 import BeautifulSoup
from urllib3 import util

def main(place_):
   
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    driver = webdriver.Chrome(options=options)
    
    #place_ = "전주 한옥마을"
    URL_ = "https://m.search.naver.com/search.naver?sm=mtp_sly.hst&where=m&query="+place_+"&acr=1"
    #URL_ = "https://pcmap.place.naver.com/place/list?query="+title_
    driver.get(URL_)

    response = driver.page_source
    soup = BeautifulSoup(response,"html.parser")
    
    tag_title = ""
    
    tag1 = soup.find("span", attrs={"class": "_3ocDE"})#1
    tag2 = soup.find("span", attrs={"class": "kAdc3"})#2
    tag3 = soup.find("span", attrs={"class": "_3Qp1c"})#3
    
    if tag1 == None:
        if tag2 == None:
            if tag3 == None:
                tag_title = "기타"
            else:
                tag_title = tag3.text
        else:
            tag_title = tag2.text
    else:
        tag_title = tag1.text
    
    tag_ = tag_title.split(",")
    
    if tag_[0] == "보물":
        tag_title = "문화재"
    
    elif tag_[0] == "도시":
        tag_title = "공원"
    
    driver.quit()
    
    return tag_title