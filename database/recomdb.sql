DROP DATABASE IF EXISTS `recomdb` ;

CREATE DATABASE IF NOT EXISTS `recomdb` 
  DEFAULT CHARACTER SET utf8 
  DEFAULT COLLATE utf8_general_ci;

USE `recomdb`;

DROP TABLE `user`;
CREATE TABLE `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
`uid` VARCHAR(200) NOT NULL,
  `email` VARCHAR(2053) NOT NULL,
  PRIMARY KEY (id, uid)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8 
  DEFAULT COLLATE utf8_general_ci;


 drop table `reviews`;
 CREATE TABLE `reviews` ( 
     postId int PRIMARY KEY AUTO_INCREMENT, 
     time_ TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
     content varchar(5000) NOT NULL, 
     uid varchar(200) NOT NULL,
     weather varchar(10) NOT NULL,
     place varchar(100) NOT NULL,
     image text

 )ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8 
  DEFAULT COLLATE utf8_general_ci;


CREATE TABLE `tag` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8 
  DEFAULT COLLATE utf8_general_ci;
  
CREATE TABLE `place` ( 
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` varchar(500) NOT NULL,
    `address` varchar(500),
    `tag` varchar(100),
    `x` float,
    `y` float,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8 
  DEFAULT COLLATE utf8_general_ci;

DROP TABLE `review_place`;
CREATE TABLE `review_place` (
    `title` varchar(500) NOT NULL,
    `address` varchar(500),
    `tag`varchar(100),
    `x` float,
    `y` float,
    `cnt` int,
    PRIMARY KEY (`title`,`address`)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8 
  DEFAULT COLLATE utf8_general_ci;

drop table `rate`;
CREATE TABLE `rate` (
    `user_id` INT NOT NULL,
    `tag_id` INT NOT NULL,
    `weather` INT NOT NULL,
    `rating` INT NULL,
    PRIMARY KEY (`user_id`,`tag_id`,`weather`)
) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8 
  DEFAULT COLLATE utf8_general_ci;
  
 
  

###############################################

INSERT INTO `user` (id, uid, email) VALUES
 (null, "8sUGFJGwICb0Ro7tCRnOIpSV7hv1",'qpal@naver.com'),
 (null, "fiiMHf2Et2PZ1A9fkOg28k9tgcg2", "test5@naver.com"),
 (null, "ap2iV8POcLVmQSe1R7LUe2qezvg2","yoon123@naver.com"),
 (null, "lpez9KZfAueDyHqGoIZ7AN7SmjC3", "trsttltosoa@tkels.com"), 
 (null, "Vlg6nengmVbzNndbdZSo8zUBjlr2", "1029test@naver.com"),
 (null, "XwL78gOajzUCXRxK4VhwSeb7dpl1", "test1117@test.com"),
 (null, "lpez9KZfAueDyHqGoIZ7AN7SmjC3", "trsttltosoa@tkels.com");
 
 
 INSERT INTO `tag` (id, title) VALUES
(null,'테마파크'),
(null,'워터파크'),
(null,'컨벤션센터'),
(null,'케이블카'),
(null,'유원지'),
(null,'식물원'),
(null,'테마공원'),
(null,'휴양림'),
(null,'동물원'),
(null,'갤러리카페'),
(null,'전망대'),
(null,'공원'),
(null,'아쿠아리움'),
(null,'과학관'),
(null,'체험마을'),
(null,'문화시설'),
(null,'카페'),
(null,'프로야구장'),
(null,'산'),
(null,'온천'),
(null,'문화재'),
(null,'미술관'),
(null,'문화'),
(null,'종합운동장'),
(null,'호수'),
(null,'사격장'),
(null,'지역명소'),
(null,'박물관'),
(null,'자연'),
(null,'전시관'),
(null,'광장'),
(null,'야구장'),
(null,'눈썰매장'),
(null,'목욕탕'),
(null,'기념물'),
(null,'갤러리'),
(null,'아이스링크'),
(null,'유적지'),
(null,'관람'),
(null,'체험'),
(null,'섬'),
(null,'기념관'),
(null,'체험여행'),
(null,'자연공원'),
(null,'레저'),
(null,'군립'),
(null,'주말농장');
 
INSERT INTO `place` (id, title, address, tag, x, y) VALUES
  (null,'금오산','경북 구미시 남통동 288-2','산', 128.313903, 36.1116316),
  (null, '금오랜드', '경북 구미시 금오산로 341', '테마파크', 128.3165233, 36.1132002),
  (null,'낙동강체육공원', '경북 구미시 낙동제방길 200', '테마공원', 128.367996, 36.1311328),
  (null, '구미낙산리삼층석탑', '경북 구미시 해평면 낙산리 837-1', '기념물', 128.3623275, 36.2516883),
  (null, '구미에코랜드','경북 구미시 산동읍 인덕1길 195', '관람',128.4625126, 36.1771599),
  (null, '옥성자연휴양림', '경북 구미시 옥성면 휴양림길 150','휴양림', 128.2844273, 36.2790723),
  (null, '연의하루', '경북 구미시 해평면 금호연지1길 21', '주말농장', 128.3850707, 36.2102666),
  (null, '농부의정원', '경북 구미시 무을면 수다사길 96 농부의정원', '체험', 128.1654738, 36.2762526),
  (null, '구미과학관', '경북 구미시 3공단1로 219-1', '과학관', 128.4005149, 36.102297),
  (null, '문성생태공원', '경북 구미시 고아읍 들성로 174-8', '자연', 128.3399931, 36.158759),
  (null, '지산샛강생태공원', '경북 구미시 지산동 845-85', '자연', 128.3540961, 36.1328416),
  (null, '형곡전망대', '경북 구미시 형곡동 산32-2', '전망대', 128.3257449, 36.1000236),
  (null, '새마을운동테마공원', '경북 구미시 박정희로 155','테마공원',128.3513722, 36.0936159),
  (null, '금오랜드눈썰매장', '경북 구미시 금오산로 341','눈썰매장',128.3165233, 36.1132002),
  (null, '천생산성 유아숲체험원','경북 구미시 여헌로10길 229 천생산성산림욕장 내', '체험', 128.4480992, 36.1040421),
  (null, '금오서원', '경북 구미시 선산읍 유학길 593-31', '문화', 128.3387558, 36.2277564),
  (null, '봉곡테마공원', '경북 구미시 봉곡로18길 30', '테마공원', 128.313978, 36.1509603),
  (null, '송백자연생태학습원', '경북 구미시 산동읍 송백로 868', '체험여행', 128.4785127, 36.2156751),
  (null, '왕산허위선생기념관', '경북 구미시 왕산로 28-33','기념관',128.3643035,36.0834349),
  (null, '낙동강', '경북 구미시 임수동 낙동강', '강', 0, 0),
  (null, '무을저수지', '경북 구미시 무을면 안곡리 1264-18', '호수', 128.1544415, 36.2669146),
  (null, '구미죽장리오층석탑', '경북 구미시 선산읍 죽장2길 90', '기념물',128.2813359, 36.2484602),
  (null,'이월드','대구 달서구 두류공원로 200','테마파크',128.564821,35.8548554),
  (null,'스파밸리','대구 달성군 가창면 가창로 891','워터파크',128.635313,35.788117),
  (null,'EXCO','대구 북구 엑스코로 10','컨벤션센터',128.6130954,35.907167799999996),
  (null,'팔공산케이블카','대구 동구 팔공산로185길 51 팔공산케이블카','케이블카',128.694838,35.990865899999996),
  (null,'에코테마파크 대구숲','대구 달성군 가창면 가창로 1003','유원지',128.6255711,35.793045899999996),
  (null,'대구수목원','대구 달서구 화암로 342 대구수목원관리사무소','식물원',128.5200044,35.800699),
  (null,'달성공원','대구 중구 달성공원로 35 달성공원','테마공원',128.5759076,35.8733797),
  (null,'비슬산자연휴양림','대구 달성군 유가읍 용리 산10','휴양림',128.5174564,35.6915225),
  (null,'네이처파크','대구 달성군 가창면 가창로 891','동물원',128.635313,35.788117),
  (null,'국채보상운동기념공원','대구 중구 국채보상로 670 국채보상운동기념관','테마공원',128.6034054,35.86889620000001),
  (null,'동제미술관','대구 달성군 가창면 헐티로10길 18 전시관','갤러리카페',128.5934109,35.7894591),
  (null,'두류공원','대구 달서구 공원순환로 36','테마공원',128.5587884,35.850894),
  (null,'83타워','대구 달서구 두류공원로 200','전망대',128.564821,35.8548554),
  (null,'화원유원지','대구 달성군 화원읍 사문진로1길 40-14','유원지',128.4821611,35.813244899999994),
  (null,'봉무공원','대구 동구 봉무동 산135-2','공원',128.6505654,35.9191597),
  (null,'동촌유원지','대구 동구 효목동 1314','유원지',128.6498118,35.8830931),
  (null,'대구아쿠아리움','대구 동구 동부로 149 신세계백화점 대구점 9층','아쿠아리움',128.6291671,35.8777043),
  (null,'국립대구과학관','대구 달성군 유가읍 테크노대로6길 20','과학관',128.4652129,35.6861237),
  (null,'스파크랜드','대구 중구 동성로6길 61','테마파크',128.5987415,35.8687083),
  (null,'월광수변공원','대구 달서구 월곡로 5','공원',128.548306,35.7988018),
  (null,'마비정벽화마을','대구 달성군 화원읍 마비정길 262-5','체험마을',128.5416615,35.7786885),
  (null,'디아크문화관','대구 달성군 다사읍 강정본길 57','문화시설',128.4649375,35.841083000000005),
  (null,'대새목장','대구 달성군 가창면 가창로93길 523','카페',128.6067824,35.74583),
  (null,'앞산공원전망대','대구 남구 대명동 산227-4','전망대',128.5872146,35.8262204),
  (null,'공룡공원','대구 남구 용두2길 43','테마공원',128.6033928,35.8299123),
  (null,'해맞이공원','대구 동구 효목동 212-2','공원',128.6457767,35.884510600000006),
  (null,'대구삼성라이온즈파크','대구 수성구 야구전설로 1 대구삼성라이온즈파크','프로야구장',128.6812364,35.841128999999995),
  (null,'최정산','대구 달성군 가창면','산',128.622825,35.802708),
  (null,'앞산해넘이전망대','대구 남구 대명동 1501-2','전망대',128.5654998,35.8321648),
  (null,'엘리바덴 상인점','대구 달서구 상인서로 8-6','온천',128.5478657,35.812101299999995),
  (null,'앞산','대구 남구 대명동 산227-2','산',128.5775497,35.8216287),
  (null,'아르떼 수성랜드','대구 수성구 무학로 42','테마파크',128.6133741,35.82857),
  (null,'대견사지','대구 달성군 유가읍 용리','문화재',128.4987,35.6854),
  (null,'수성유원지','대구 수성구 두산동 512','유원지',128.6182129,35.8293092),
  (null,'아이니테마파크','대구 수성구 유니버시아드로 140 대구스타디움몰 지하1층','테마파크',128.6873259,35.8316602),
  (null,'사문진 주막촌','대구 달성군 화원읍 성산리 744-11','공원',128.4770889,35.812830600000005),
  (null,'대구미술관','대구 수성구 미술관로 40','미술관',128.6741762,35.827135399999996),
  (null,'대구스타디움','대구 수성구 유니버시아드로 180 대구종합경기장','종합운동장',128.6901563,35.8299377),
  (null,'비슬산','대구 달성군 유가읍 양리 산1','산',128.5153805,35.7228108),
  (null,'달성공원 동물원','대구 중구 달성공원로 35 달성공원','동물원',128.5759076,35.8733797),
  (null,'대명유수지','대구 달서구 대천동 816','호수',128.4904974,35.8225217),
  (null,'율하체육공원','대구 동구 금호강변로 278','공원',128.6928379,35.85992529999999),
  (null,'운암지 수변공원','대구 북구 구암동 349','공원',128.5675231,35.9323191),
  (null,'대구국제사격장','대구 북구 문주길 170 대구사격장','사격장',128.5243266,35.911306200000006),
  (null,'청라언덕','대구 중구 달구벌대로 2029','지역명소',128.5849575,35.866583500000004),
  (null,'남평문씨본리세거지','대구 달성군 화원읍 인흥3길 16','문화',128.5180358,35.792553600000005),
  (null,'국립대구박물관','대구 수성구 청호로 321 국립대구박물관','박물관',128.6379046,35.845893200000006),
  (null,'달성습지 생태학습관','대구 달성군 화원읍 구라1길 88','자연',128.4870559,35.816683700000006),
  (null,'앞산케이블카','대구 남구 앞산순환로 454 앞산케이블카','케이블카',128.5792744,35.822375),
  (null,'향촌문화관','대구 중구 중앙대로 449','전시관',128.5941672,35.873374299999995),
  (null,'강정보디아크광장','대구 달성군 다사읍 강정본길 57','광장',128.4649375,35.841083000000005),
  (null,'화원자연휴양림','대구 달성군 화원읍 화원휴양림길 126 꽃창포동','휴양림',128.5367339,35.771787100000005),
  (null,'신기공원','대구 북구 유통단지로 61','자연',128.6090479,35.9074042),
  (null,'대구방짜유기박물관','대구 동구 도장길 29','박물관',128.701213,35.965585),
  (null,'이월드코코몽눈빛마을','대구 달서구 두류공원로 200','눈썰매장',128.564821,35.8548554),
  (null,'수성패밀리파크','대구 수성구 고모동 20-3','테마공원',128.6743033,35.87004829999999),
  (null,'월곡역사공원','대구 달서구 상인로 134-9 월곡역사공원','공원',128.5451733,35.8191285),
  (null,'망우당공원','대구 동구 효목동 산234-38','공원',128.6563334,35.8773174),
  (null,'옹기종기행복마을','대구 동구 입석동 932-15','지역명소',128.6472645,35.891949700000005),
  (null,'미성온천','대구 달서구 조암남로28길 9','온천',128.5175187,35.8176395),
  (null,'반야월연꽃단지','대구 동구 대림동 378-1','지역명소',128.7438924,35.8668209),
  (null,'엘리바덴 신월성점','대구 달서구 조암로 38','목욕탕',128.5256515,35.824977000000004),
  (null,'도동측백나무숲','대구 동구 도동 산78-1','기념물',128.6641129,35.9165869),
  (null,'수목원생활온천','대구 달서구 상화로 79','온천',128.52262,35.8082315),
  (null,'대백프라자갤러리','대구 중구 명덕로 333 대백프라자 12층','갤러리',128.6063409,35.8557948),
  (null,'이월드 83타워 아이스링크','대구 달서구 두류공원로 200','아이스링크',128.564821,35.8548554),
  (null,'대구근대역사관','대구 중구 경상감영길 67 한국산업은행(대구지점)','박물관',128.5911536,35.8717739),
  (null,'2.28기념중앙공원','대구 중구 동성로2길 80','테마공원',128.5971688,35.8691574),
  (null,'신전뮤지엄','대구 북구 관음로 43','박물관',128.5400484,35.9347791),
  (null,'토이빌리지 대구혁신점','대구 동구 혁신대로 468','테마파크',128.7480345,35.8740405),
  (null,'잭슨나인스 대구점','대구 달성군 유가읍 테크노상업로 120 2층','테마파크',128.4628865,35.6930595),
  (null,'모명재','대구 수성구 달구벌대로525길 14-23','문화',128.6517581,35.858475),
  (null,'국립대구기상과학관','대구 동구 효동로2길 10','과학관',128.6538962,35.8781913),
  (null,'달성 하목정','대구 달성군 하빈면 하산리','문화재',128.4116687,35.885432200000004),
  (null,'대구섬유박물관','대구 동구 팔공로 227','박물관',128.6402119,35.919018799999996),
  (null,'신숭겸장군유적지','대구 동구 신숭겸길 17 신숭겸장군유적지','유적지',128.6409848,35.942071500000004),
  (null,'플라이존','대구 수성구 성동로15길 79-9','체험',128.7195415,35.8407105),
  (null,'근대문화체험관 계산예가','대구 중구 서성로 6-1','체험',128.5878148,35.867166999999995),
  (null,'이웃집수달','대구 중구 명덕로 99 근린생활시설 5층 이웃집수달','동물원',128.5812802,35.857265000000005),
  (null,'리틀소시움','대구 북구 엑스코로 10 엑스코 B1F EBS리틀소시움','체험',128.6130954,35.907167799999996),
  (null,'하중도','대구 북구 노곡동 665','섬',128.5598557,35.9007494),
  (null,'대구교육박물관','대구 북구 대동로1길 40','박물관',128.6118352,35.89734910000001),
  (null,'나비생태원','대구 동구 팔공로50길 66','자연',128.6501798,35.9219592),
  (null,'대구스타디움대구스포츠기념관','대구 수성구 유니버시아드로42길 139','기념관',128.6839031,35.8252432),
  (null,'대구녹색학습원','대구 수성구 달구벌대로 3170 대구농업마이스터고등학교 내 대구녹색학습원','체험여행',128.7014474,35.8329098),
  (null,'구암서원','대구 북구 연암공원로17길 20','문화',128.5990146,35.898444899999994),
  (null,'희움 일본군 위안부 역사관','대구 중구 경상감영길 50','박물관',128.5903045,35.8713535),
  (null,'치킨체험 테마파크 땅땅랜드','대구 동구 팔공로 220-2 치킨체험테마파크 땅땅랜드','체험',128.6416552,35.91753610000001),
  (null,'달성현풍석빙고','대구 달성군 현풍읍 상리 926','문화재',128.4521089,35.6975192),
  (null,'노태우대통령생가','대구 동구 용진길 172',"'기념관,생가'",128.6486125,35.982360899999996),
  (null,'옛 구암서원','대구 중구 국채보상로 492-58 옛 구암서원','체험',128.5849759,35.868646399999996),
  (null,'2.28민주운동기념회관','대구 중구 2·28길 9','기념관',128.590356,35.858374299999994),
  (null,'국채보상운동기념관','대구 중구 국채보상로 670 국채보상운동기념관','기념관',128.6034054,35.86889620000001),
  (null,'중리체육공원','대구 서구 중리동 358-10','공원',128.5459663,35.8655777),
  (null,'대구태왕스파크해피빌런즈테마파크','대구 중구 동성로6길 61','테마파크',128.5987415,35.8687083),
  (null,'한방의료체험타운','대구 중구 중앙대로77길 45','체험',128.5910103,35.868151899999994),
  (null,'화원명곡체육공원','대구 달성군 화원읍 인흥1길 12','자연공원',128.5036013,35.7976896),
  (null,'대구복합스포츠타운야구장','대구 북구 고성로 191','야구장',128.5872781,35.8820326),
  (null,'수성파크랜드','대구 수성구 용학로 35-3','레저',128.6135164,35.826462799999995),
  (null,'계명대학교 성서캠퍼스행소박물관','대구 달서구 달구벌대로 1095','박물관',128.4836385,35.8590028),
  (null,'신매광장','대구 수성구 신매동 567-15','광장',128.7070609,35.8397223),
  (null,'수성구관광정보체험센터','대구 수성구 유니버시아드로 140','체험',128.6873259,35.8316602),
  (null,'화원식염온천','대구 달성군 화원읍 비슬로530길 29-15','온천',128.5068936,35.8053488),
  (null,'율하광장','대구 동구 안심로22길 40','광장',128.6956382,35.8633472),
  (null,'에코한방웰빙체험관','대구 중구 남성로 24','체험',128.5892547,35.8679033),
  (null,'비슬산군립공원','대구 달성군 유가읍 양리 산5','공원',128.5268883,35.7048984),
  (null,'스파밸리온천','대구 달성군 가창면 가창로 891','온천',128.635313,35.788117),
  (null,'계산지구촌박물관','대구 중구 서성로 28','박물관',128.5873341,35.868976399999994),
  (null,'서변온천','대구 북구 호국로 219','온천',128.5988481,35.9213059),
  (null,'화원유원지 워터파크','대구 달성군 화원읍 사문진로1길 40-14','워터파크',128.4821611,35.813244899999994);
 
 INSERT INTO `rate` (user_id, tag_id, weather, rating) VALUES
    (1, 1, 1, 3),
    (1, 5, 1, 5),
    (1, 6, 2, 4),
    (2, 1, 3, 4),
    (2, 5, 2, 4),
    (2, 6, 1, 2),
    (2, 9, 3, 3),
    (3, 1, 1, 5),
    (3, 6, 1, 4),
    (3, 7, 2, 2),
    (3, 22, 2, 3),
    (4, 2, 3, 5),
    (4, 3, 1, 1),
    (4, 5, 3, 3),
    (4, 10, 1, 4),
    (4, 15, 2, 3),
    (4, 20, 3, 4),
    (5, 6, 3, 5),
    (5, 7, 2, 5),
    (5, 8, 1, 4),
    (5, 9, 2, 3),
    (5, 12, 2, 4),
    (6, 1, 1, 4),
    (6, 1, 3, 1),
    (6, 2, 1, 5),
    (6, 2, 2, 3),
    (6, 2, 3, 1),
    (6, 3, 1, null),
    (6, 6, 3, 2),
    (6, 7, 1, 4),
    (6, 9, 2, 4),
    (6, 11, 2, 4),
    (6, 12, 3, 1),
    (6, 14, 1, 3),
    (6, 17, 2, 3),
    (6, 18, 1, 5),
    (6, 18, 3, 3),
    (6, 20, 2, 2),
    (6, 24, 1, 4),
    (6, 24, 2, 4),
    (6, 25, 3, 2),
    (6, 27, 1, 3),
    (8, 1, 1, 5),
    (8, 1, 2, 4),
    (8, 1, 3, 1),
    (8, 2, 1, 5),
    (8, 2, 2, 4),
    (8, 2, 3, 1),
    (8, 5, 1, 5),
    (8, 5, 2, 5),
    (8, 5, 3, 5),
    (8, 6, 1, 5),
    (8, 6, 2, 5),
    (8, 6, 3, 5),
    (8, 8, 1, 5),
    (8, 8, 2, 2),
    (8, 8, 3, 1),
    (8, 9, 1, 5),
    (8, 9, 2, 5),
    (8, 9, 3, 5),
    (8, 10, 1, 4),
    (8, 10, 2, 5),
    (8, 10, 3, 4),
    (8, 11, 1, 5),
    (8, 11, 2, 4),
    (8, 11, 3, 4),
    (8, 13, 1, 5),
    (8, 13, 2, 5),
    (8, 13, 3, 5),
    (8, 16, 1, 5),
    (8, 16, 2, 4),
    (8, 16, 3, 4),
    (8, 17, 1, 4),
    (8, 17, 2, 5),
    (8, 17, 3, 5),
    (8, 19, 1, 5),
    (8, 19, 2, 2),
    (8, 19, 3, 1),
    (8, 20, 1, 5),
    (8, 20, 2, 5),
    (8, 20, 3, 3),
    (8, 21, 1, 3),
    (8, 21, 2, 3),
    (8, 21, 3, 1),
    (8, 22, 1, 4),
    (8, 22, 2, 5),
    (8, 22, 3, 4),
    (8, 24, 1, 5),
    (8, 24, 2, 2),
    (8, 24, 3, 1),
    (8, 25, 1, 5),
    (8, 25, 2, 2),
    (8, 25, 3, 1),
    (8, 26, 1, 5),
    (8, 26, 2, 5),
    (8, 26, 3, 3),
    (8, 27, 1, 5),
    (8, 27, 2, 4),
    (8, 27, 3, 4),
    (8, 28, 1, 4),
    (8, 28, 2, 5),
    (8, 28, 3, 4),
    (8, 30, 1, 4),
    (8, 30, 2, 5),
    (8, 30, 3, 4),
    (8, 31, 1, 5),
    (8, 31, 2, 4),
    (8, 31, 3, 4),
    (8, 32, 1, 5),
    (8, 32, 2, 5),
    (8, 32, 3, 5),
    (8, 33, 1, 5),
    (8, 33, 2, 5),
    (8, 33, 3, 3),
    (8, 35, 1, 3),
    (8, 35, 2, 3),
    (8, 35, 3, 1),
    (8, 37, 1, 5),
    (8, 37, 2, 5),
    (8, 37, 3, 3),
    (8, 38, 1, 3),
    (8, 38, 2, 3),
    (8, 38, 3, 1),
    (8, 42, 1, 4),
    (8, 42, 2, 5),
    (8, 42, 3, 4),
    (8, 46, 1, 3),
    (8, 46, 2, 3),
    (8, 46, 3, 1),
    (8, 47, 1, 5),
    (8, 47, 2, 2),
    (8, 47, 3, 1),
    (8, 48, 1, 5),
    (8, 48, 2, 5),
    (8, 48, 3, 3),
    (8, 51, 1, 5),
    (8, 51, 2, 2),
    (8, 51, 3, 1),
    (8, 52, 1, 5),
    (8, 52, 2, 5),
    (8, 52, 3, 5),
    (8, 53, 1, 5),
    (8, 53, 2, 2),
    (8, 53, 3, 1),
    (8, 56, 1, 3),
    (8, 56, 2, 3),
    (8, 56, 3, 1),
    (8, 59, 1, 5),
    (8, 59, 2, 5),
    (8, 59, 3, 3),
    (8, 61, 1, 3),
    (8, 61, 2, 3),
    (8, 61, 3, 1),
    (8, 62, 1, 4),
    (8, 62, 2, 5),
    (8, 62, 3, 4),
    (8, 65, 1, 5),
    (8, 65, 2, 2),
    (8, 65, 3, 1),
    (8, 66, 1, 5),
    (8, 66, 2, 5),
    (8, 66, 3, 3),
    (8, 67, 1, 5),
    (8, 67, 2, 2),
    (8, 67, 3, 1),
    (8, 68, 1, 5),
    (8, 68, 2, 2),
    (8, 68, 3, 1),
    (8, 69, 1, 5),
    (8, 69, 2, 2),
    (8, 69, 3, 1),
    (8, 70, 1, 5),
    (8, 70, 2, 4),
    (8, 70, 3, 1),
    (8, 71, 1, 4),
    (8, 71, 2, 5),
    (8, 71, 3, 5);