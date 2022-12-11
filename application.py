from flask_mysqldb import MySQL

import simplejson as json
import recom_system
import tag_cr
from flask import Flask, jsonify, render_template, request, redirect
import re
import datetime


app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '0976'
app.config['MYSQL_DB'] = 'recomdb'

db = MySQL(app)
URL = "https://weatherable-flask-psgys.run.goorm.io/"

@app.route("/")    
def index():
    return "hello"

 
@app.route("/users", methods=["GET"])    # 사용자 조회
def users():
    query = 'select * from user'
    cur = db.connection.cursor()
    cur.execute(query)
    res = json.dumps(cur.fetchall())

    return res
    
@app.route("/users/sign-in", methods=["GET", "POST"]) # 회원가입
def sign_in():       
    if request.method == 'POST':
        userData = request.form
        uid = userData['uid']
        email = userData['email']
        query = '''insert into user values (null, "{}", "{}")'''.format(uid, email)

        cur = db.connection.cursor()
        cur.execute(query)        
        
        select_query = 'select id from user where "{}"=user.email'.format(email)
        curr = db.connection.cursor()
        curr.execute(select_query)
        
        db.connection.commit()
        
        li = []
        uid = json.dumps(curr.fetchall()).strip('[]')
        res = {'id': uid}
        li.append(res)
        print(email)

        resp = json.dumps(li)
        return resp

@app.route("/users/rate")    # 유저 평가값 조회
def TagRateCheck():
    query = 'select * from rate'
    cur = db.connection.cursor()
    cur.execute(query)
    res = json.dumps(cur.fetchall())

    return res

@app.route("/places", methods=["GET"])    # 장소 조회
def place():
    query = 'select * from place'
    cur = db.connection.cursor()
    cur.execute(query)
    res = json.dumps(cur.fetchall())

    return res

@app.route("/users/uid", methods=["GET", "POST"])    # user email을 비교하여 uid 반환
def user_post():
    if request.method == 'POST':
        userData = request.form['email']
        query = 'select id from user where "{}"=user.email'.format(userData)

        cur = db.connection.cursor()
        cur.execute(query)
        db.connection.commit()

        li = []
        uid = json.dumps(cur.fetchall()).strip('[]')
        res = {'id': uid}
        li.append(res)

        resp = json.dumps(li)
        return resp
        

@app.route("/places/tag", methods=["GET", "POST"])    # 태그 조회
def tag():
    query = 'select * from tag'
    cur = db.connection.cursor()
    cur.execute(query)
    db.connection.commit()
    res = json.dumps(cur.fetchall())
    
    return res


@app.route("/places/tag/rate", methods=["GET", "POST"])    
def tag_place():
    if request.method == 'GET':     #설문조사 태그 랜덤 추출
        query = 'select id, title from tag order by rand() limit 7'
        cur = db.connection.cursor()
        cur.execute(query)
        db.connection.commit()
        data = cur.fetchall()

        li = []
        for d in data:
            res = {'id': d[0], 'title': d[1]}
            li.append(res)

        res = json.dumps(li)

        return res

    elif request.method == 'POST':      # 평가값 insert
        rateData = request.form
    
        uid = rateData['user_id']
        tid = rateData['tag_id']
        weather = rateData['weather']
        rat = rateData['rating']
        
        t = tid[1:len(tid)-1].split(",")
        r = rat[1:len(rat)-1].split(",")
        
        for i in range(7):
            query = '''insert into rate values ({}, {}, {}, {})'''.format(uid, t[i], weather, r[i])
            cur = db.connection.cursor()
            cur.execute(query)
            db.connection.commit()
        
        return TagRateCheck()


@app.route("/users/rate", methods=["GET", "POST"]) 
def rate():
    if request.method == 'GET':     # 평가값 조회 
        query = 'select * from rate'
        cur = db.connection.cursor()
        cur.execute(query)
        res = json.dumps(cur.fetchall())
        
        return res

    elif request.method == 'POST':      # 평가값 등록
        starRate = request.form
        rating = starRate['rating']

        res = json.dumps(rating)
        return res

        
@app.route("/places/req", methods=["GET", "POST"])    # 추천리스트 요청
def distance():
    if request.method == 'POST':
        location = request.form

        x_ = location['x']
        y_ = location['y']
        weatherCode = location['weatherCode']
        uid = location['uid']

        query = '''select id, title, tag, address, x,y, (6371 * acos(cos(radians({})) * cos(radians(y)) * cos(radians(x) - radians({})) + sin(radians({})) * sin(radians(y)))) as distance from place having distance <= 20 order by distance'''.format(y_, x_, y_)
    
        cur = db.connection.cursor()
        cur.execute(query)
        dist = json.dumps(cur.fetchall())
        
        result = recom_system.main(URL, recom_system.getDist(dist), weatherCode, int(uid))
        return result

    elif request.method == 'GET':
        pass

@app.route("/story/post", methods=["POST"]) # 리뷰 작성시 새로운 장소 등록, 사용자 평가, 태그 등록 등
def send_review():
    review = request.form
    
    x_ = review['x']
    y_ = review['y']
    name_ = review['name']
    address_ = review['address']
    weather_ = review['weatherCode']
    rate_ = review['rating']
    tag_ = review['tag']
    uid = review['uid']
    
    cur = db.connection.cursor()

    #tag table에 tag값 집어넣기
    query = '''insert into tag (id, title) select null, "{}" from dual where not exists(select * from tag where title = "{}")'''.format(tag_, tag_)
    cur.execute(query)
    db.connection.commit()
    
    #tag의 id 구하기
    query = '''select id from tag where title = "{}"'''.format(tag_)
    cur.execute(query)
    tid = json.dumps(cur.fetchall()).strip('[]')
    query = '''insert into rate values ({},{},{},{}) on duplicate key update rating = {}'''.format(uid, tid, weather_, rate_, rate_)
    cur.execute(query)
    db.connection.commit()
    
    query = '''select count(*) as count_ from place where address = "{}" and title = "{}"'''.format(address_, name_)
    cur.execute(query)
    p_check = json.dumps(cur.fetchall()).strip('[]')

    if p_check == "0":
        query = '''insert into review_place values ("{}","{}","기타",{},{},1) on duplicate key update cnt = cnt+1'''.format(name_,address_,x_,y_)
        cur.execute(query)
        db.connection.commit()
        
        query = '''select cnt from review_place where address = "{}" and title = "{}"'''.format(address_, name_)
        cur.execute(query)
        c_check = json.dumps(cur.fetchall()).strip('[]')

        if c_check == "100":
                query = '''delete from review_place where address = "{}" and title = "{}"'''.format(address_, name_)
                cur.execute(query)
                db.connection.commit()
 
    return index()


@app.route("/story/insert", methods=["POST"]) # 게시글 insert
def reviews_post():
    
    if request.method == 'POST':
        reviews = request.form

        content = reviews['content']
        uid = reviews['uid']
        weather = reviews['weather']
        place = reviews['place']
        image = reviews['image']

        cur = db.connection.cursor()

        query = '''insert into reviews values ( null, null, "{}", "{}", "{}", "{}", "{}") '''.format(content, uid, weather, place, image)
        cur.execute(query)
        db.connection.commit()
        
        return "업로드 성공"
 
@app.route("/story/read/uid", methods=["GET"]) # 사용자 uid와 일치하는 리뷰만 불러오기
def reviews_get():
    if request.method == 'GET':
        uid = request.args.get('id')

        query = '''select * from reviews where uid="{}"'''.format(uid)
        
        cur = db.connection.cursor()
        cur.execute(query)
   
        enco = lambda obj: (
            obj.isoformat()
            if isinstance(obj, datetime.datetime) or isinstance(obj, datetime.date)
            else None
        )

        res = json.dumps(cur.fetchall(), default = enco)
        print(res)
        return recom_system.trans(res)


@app.route("/story/read/post-id", methods=["GET"]) # 리뷰 상세히 불러오기
def reviews_get_detail():
    if request.method == 'GET':
        reviews = request.args.get('id')
            
        query = '''select * from reviews where postId={}'''.format(reviews)
        cur = db.connection.cursor()
        cur.execute(query)

        enco = lambda obj: (
            obj.isoformat()
            if isinstance(obj, datetime.datetime) or isinstance(obj, datetime.date)
            else None
        )
    
        res = json.dumps(cur.fetchall(), default = enco)
        return recom_system.trans(res)
   

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
