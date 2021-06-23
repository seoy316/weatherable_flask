import datetime
import json


# review = {}
# reviews = []



# def trans(files):
#     for file in files:
#         review = {"postId" : file[0], "dateTime": file[1], "comment" : file[2], "weatehr" : file[4],
#             "place": file[5], "image" : file[6]}
#         reviews.append(review)
#     return reviews
    
class CJsonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.datetime):
            return obj.strftime('%Y-%m-%d %H:%M:%S')
        else:
            return json.JSONEncoder.default(self, obj)
