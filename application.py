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
URL = "https://weatherable-flask-lhavr.run.goorm.io/"

@app.route("/")
def index():
    query = 'select * from user'
    cur = db.connection.cursor()
    cur.execute(query)
    
    data = cur.fetchall()

    li = []
    for d in data:
        res = {'id': d[0], 'uid': d[1], 'email': d[2]}
        li.append(res)

    res = json.dumps(li)
    return res


@app.route("/rateOK")
def TagRateCheck():
    query = 'select * from rate'
    cur = db.connection.cursor()
    cur.execute(query)
    res = json.dumps(cur.fetchall())

    return res

@app.route("/place", methods=["GET"])
def place():
    query = 'select * from place'
    cur = db.connection.cursor()
    cur.execute(query)
    res = json.dumps(cur.fetchall())

    return res

@app.route("/user_post", methods=["GET", "POST"])
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
        

@app.route("/user", methods=["GET", "POST"])
def user():
    if request.method == 'GET':
        query = 'select * from user'
        cur = db.connection.cursor()
        cur.execute(query)
        res = json.dumps(cur.fetchall())

        return res
        
        
    elif request.method == 'POST':
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

        resp = json.dumps(li)
        return resp

@app.route("/tag", methods=["GET", "POST"])
def tag():
    query = 'select * from tag'
    cur = db.connection.cursor()
    cur.execute(query)
    db.connection.commit()
    res = json.dumps(cur.fetchall())
    
    return res


@app.route("/tag_place", methods=["GET", "POST"])
def tag_place():
    if request.method == 'GET':
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

    elif request.method == 'POST':
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


@app.route("/rate", methods=["GET", "POST"])
def rate():
    if request.method == 'GET':
        query = 'select * from rate'
        cur = db.connection.cursor()
        cur.execute(query)
        res = json.dumps(cur.fetchall())
        
        return res

    elif request.method == 'POST':
        starRate = request.form
        rating = starRate['rating']

        res = json.dumps(rating)
        return res

        
@app.route("/rating", methods=["GET", "POST"])
def rating():
    recom_place = recom_system.main(URL)
    return recom_place


@app.route("/distance", methods=["GET", "POST"])
def distance():
    if request.method == 'POST':
        location = request.form

        x_ = location['x']
        y_ = location['y']
        weatherCode = location['weatherCode']
        uid = location['uid']

        query = '''select id, title, tag, address, x,y, (6371 * acos(cos(radians({})) * cos(radians(y)) * cos(radians(x) - radians({})) + sin(radians({})) * sin(radians(y)))) as distance from place having distance <= 20 order by distance'''.format(y_, x_, y_)

        cur = db.connection.cursor()
        jsn = []
        cur.execute(query)
        dist = json.dumps(cur.fetchall())
        
        result = recom_system.main(URL, recom_system.getDist(dist), weatherCode, int(uid))
        return result

    elif request.method == 'GET':
        pass

@app.route("/send_review", methods=["POST"])
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


@app.route("/reviews_post", methods=["POST"])
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
 
@app.route("/reviews_get", methods=["POST"])
def reviews_get():
    if request.method == 'POST':
        reviews = request.form
        uid_ = reviews['uid']
        
        cur = db.connection.cursor()
        query = '''select *from reviews where uid="{}" '''.format(uid_)
        
        cur.execute(query)
        db.connection.commit()
        
        enco = lambda obj: (
            obj.isoformat()
            if isinstance(obj, datetime.datetime) or isinstance(obj, datetime.date)
            else None
        )

        res = json.dumps(cur.fetchall(), default = enco)
        return recom_system.trans(res)

@app.route("/reviews_get/postId", methods=["GET"])
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
