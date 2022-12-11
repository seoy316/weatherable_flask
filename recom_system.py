import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.model_selection import train_test_split
import pandas as pd
from pandas import Series, DataFrame
import requests, json
import datetime

import json
import numpy as np

class NpEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        elif isinstance(obj, np.floating):
            return float(obj)
        elif isinstance(obj, np.ndarray):
            return obj.tolist()
        else:
            return super(NpEncoder, self).default(obj)


def trans(files):
    f_cols = ['postId', 'time_', 'content', 'uid', 'weather','place', 'image']
    r = []

    data = json.loads(files)
    jsonFile = pd.DataFrame(data, columns=f_cols)
    enco = lambda obj: (
        obj.isoformat()
        if isinstance(obj, datetime.datetime) or isinstance(obj, datetime.date)
            else None
        )
    
    rv = jsonFile[['postId', 'time_', 'content', 'weather','place', 'image']]
    
    cnt =0

    for j in range(len(jsonFile)):
        for i in jsonFile:
            json_data = {'postId':rv['postId'][j], 'time_':rv['time_'][j], 'content':rv['content'][j], 'weather':rv['weather'][j], 'place':rv['place'][j], 'image': rv['image'][j] }
        r.append(json_data)
    d = json.dumps(r, cls=NpEncoder)
    
    return d


def getDist(dist): # 사용자 현재 위치와 장소 거리 비교    
    p_cols = ['place_id', 'title', 'tag', 'address','x', 'y', 'dist']

    data = json.loads(dist)
    place = pd.DataFrame(data, columns=p_cols)
    return place

def main(URL, distList, wCode, uid):

        # 데이터 읽어오기
        u_cols = ['user_id', 'uid', 'email']
        t_cols = ['tag_id', 'title']
        r_cols = ['user_id', 'tag_id', 'weather', 'rating']

        url = URL+"/users"
        result = requests.get(url)
        data = json.loads(result.text)
        users = pd.DataFrame(data, columns=u_cols)

        url = URL+"/places/tag"
        result = requests.get(url)
        data = json.loads(result.text)
        tag = pd.DataFrame(data, columns=t_cols)
        
        url = URL+"/users/rate"
        result = requests.get(url)
        data = json.loads(result.text)
        ratings = pd.DataFrame(data, columns=r_cols)
        

        users = users[['user_id']]
        tags = tag[['tag_id', 'title']]
        places = distList[['title','tag','address', 'x', 'y', 'dist']]


        # train, test set 분리
        x = ratings.copy()
        y = ratings['user_id']
        x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.25, stratify=y)


        ratings = ratings.groupby('weather').get_group(1)
        

        # 정확도 계산 함수
        def RMSE(y_true, y_pred):
            return np.sqrt(np.mean((np.array(y_true) - np.array(y_pred)) ** 2))

        # 모델별 RMSE를 계산하는 함수
        def score(model):
            id_pairs = zip(x_test['user_id'], x_test['tag_id'])
            y_pred = np.array([model(user, tag) for (user, tag) in id_pairs])
            y_true = np.array(x_test['rating'])
            return RMSE(y_true, y_pred)

        # 주어진 사용자에 대해 추천을 받기
        rating_matrix = ratings.pivot_table(values='rating', index='user_id', columns='tag_id')
        matrix_dummy = rating_matrix.copy().fillna(0)
        user_similarity = cosine_similarity(matrix_dummy, matrix_dummy)
        user_similarity = pd.DataFrame(user_similarity, index=rating_matrix.index, columns=rating_matrix.index)
        
        def CF_simple(user_id, tag_id):
            if tag_id in rating_matrix:
                sim_scores = user_similarity[user_id].copy()
                tag_ratings = rating_matrix[tag_id].copy()
                none_rating_idx = tag_ratings[tag_ratings.isnull()].index
                tag_ratings = tag_ratings.dropna()
                sim_scores = sim_scores.drop(none_rating_idx)
                mean_rating = np.dot(sim_scores, tag_ratings / sim_scores.sum())
            else:
                mean_rating = 3.0
            return mean_rating


        def recom_tag(user_id, n_items):
            user_tag = rating_matrix.loc[user_id].copy()
            for tag in rating_matrix:
                if pd.notnull(user_tag.loc[tag]):
                    user_tag.loc[tag] = 0
                else:
                    user_tag.loc[tag] = CF_simple(user_id, tag)
                
                tag_sort = user_tag.sort_values(ascending=False)[:n_items]
                recom_tags = tags.loc[tag_sort.index]
                p_list =[]
                
                for i in recom_tags['title']:
                    for j in range(len(places)):
                        if i in places['tag'][j]:
                            json_data = {'name':places['title'][j], 'address':places['address'][j], 'dist':places['dist'][j], 'x':places['x'][j], 'y':places['y'][j] }
                            p_list.append(json_data)
                            
                recommendations = json.dumps(p_list)
                return recommendations

        recom_place = recom_tag(user_id=uid, n_items=10)
        return recom_place
