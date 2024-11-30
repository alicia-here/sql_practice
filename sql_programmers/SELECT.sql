## 1. 평균 일일 대여 요금 구하기 (Lv.1)

## AVG() : 평균 출력 함수 
## ROUND(): 반올림 함수

SELECT ROUND(AVG(DAILY_FEE),0) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = 'SUV';





## 2. 과일로 만든 아이스크림 고르기 (Lv.1)

## JOIN(): 테이블 조인 (MySQL default는 INNER JOIN)
## TIP: AND 조건은 ()로 잘 묶어주기
## ORDER BY: 오름차순 ASC, 내림차순 DESC 

SELECT fh.FLAVOR
FROM FIRST_HALF fh LEFT JOIN ICECREAM_INFO ii
ON fh.FLAVOR = ii.FLAVOR
WHERE (fh.TOTAL_ORDER >= 3000) AND (ii.INGREDIENT_TYPE = 'fruit_based')
ORDER BY fh.TOTAL_ORDER DESC;





## 3. 3월에 태어난 여성 회원 목록 출력하기 (Lv.2)

## DATE_FORMT(날짜, 포맷)
## MONTH(): 월 뽑아내기
## IS NOT NULL : NULL이 아니도록 조건 걸어주기 

SELECT 
    MEMBER_ID, 
    MEMBER_NAME, 
    GENDER, 
    DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE (MONTH(DATE_OF_BIRTH) = 3)
AND GENDER = 'W'
AND(TLNO IS NOT NULL)
ORDER BY MEMBER_ID ASC;





## 4. 서울에 위치한 식당 목록 출력하기 (Lv.4)