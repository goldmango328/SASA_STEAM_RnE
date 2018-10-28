"""
Project     과제3|Web Site Parsing
Auth        2513 지명금
Date        2018.10.28
"""
# pip install beautifulsoup4
# pip install requests

import datetime
import requests
from bs4 import BeautifulSoup as bs

LOGIN_INFO = {
    'id': '1786',
    'passwd': 'wlaudrma!328'
}

day_num = 2

def get_DayNum():
    day_num = int(input())
    return day_num
    
now = datetime.date.today()
tmp_date = now + datetime.timedelta(days=-day_num)  
min_date = "%s-%02d-%02d" % (str(tmp_date.year)[2:4], tmp_date.month, tmp_date.day)  # 2일전 기준으로 18-01-01 과 같은 형태 만들기


def get_Category():
    """
    사용자가 보고 싶은 카테고리를 받는 함수
    :return notice: 일반 공지 = 22 or 교과 공지 = 23 or 대회 및 캠프 = 16 or 분실물 = 2
    """
    print("="*11 + " 달빛학사 응용 프로그램 " + "="*11)
    print("일반 공지 | 교과 공지 | 대회 및 캠프 | 분실물")

    notice = -1
    while notice == -1:
        notice = input(">> 어떤 공지를 확인하시겠습니까? ")
        if notice == "일반 공지":
            notice = 22
        elif notice == "교과 공지":
            notice = 23
        elif notice == "대회 및 캠프":
            notice = 16
        elif notice == "분실물":
            notice = 2
        else :
            notice = -1
    return notice
    
with requests.Session() as s:
    first_page = s.get('https://go.sasa.hs.kr')
    html = first_page.text
    soup = bs(html, 'html.parser')

    csrf = soup.find('input', {'name': 'csrf_test_name'})

    LOGIN_INFO.update({'csrf_test_name': csrf['value']})

    login_req = s.post('https://go.sasa.hs.kr/auth/login/', data=LOGIN_INFO)
    if login_req.status_code != 200:
        raise Exception('로그인 되지 않았습니다!')

    # 일반 공지 : 22 (1 ~ 15)
    CATEGORY_NUM = get_Category()
    day_num = get_DayNum()
    PAGE_TOTAL = {"22":16, "23":7,"16":13,"2":26}

    board_list = [[] for i in range(day_num+1)]
    # 일반 공지에 대해서 최근 n일간 올린 자료를 정리 : 한달 안에서만ㅠㅜ
    for page_num in range(1,PAGE_TOTAL[str(CATEGORY_NUM)]):
        section_board_list_data = bs(s.get('https://go.sasa.hs.kr/board/lists/'+str(CATEGORY_NUM)+'/page/'+str(page_num)).text, 'html.parser')
        board_list_data = section_board_list_data.select('div.box-body tbody span.hidden-xs')
        url_list_data = section_board_list_data.select('div.box-body tbody a')
        time_list_data = section_board_list_data.select('div.box-body tbody time')

        url_list = []
        for data in url_list_data:
            if 'board'== data.get('href').split('/')[1]:
                url = "https://go.sasa.hs.kr"+'/'.join(data.get('href').split('/'))
                url_list.append(url)
                

        for i in range(len(time_list_data)):
            data =  time_list_data[i].text
            list_time = datetime.datetime.now()
            months = int(data[3])*10 + int(data[4])
            days = int(data[6])*10 + int(data[7])
            list_time = list_time.replace(month = months,day = days)
            index = -(list_time - datetime.datetime.now()).days
            
            if index <= day_num:
                dataset = (board_list_data[i].text, url_list[i])
                board_list[index].append(dataset)

    day = 0
    for board in board_list:
        cnt_idx = 0
        print(("="*11+" %02d days ago " +"="*11) % day)
        for data in board:
            print("[%d] 제목:%s url:%s" % (cnt_idx, data[0], data[1]))
        if len(board)==0:
            print("NONE")
            
        day += 1
            
