## 1. 3월에 태어난 여성 회원 목록 출력하기 (Lv.2/SELECT)

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

------------------------------------------------------------------------------------------------------

## 2. 상품 별 오프라인 매출 구하기 (Lv.2/JOIN)

SELECT 
    P.product_code AS PRODUCT_CODE, 
    SUM(O.sales_amount * P.price) AS SALES
FROM 
    OFFLINE_SALE O
LEFT JOIN 
    PRODUCT P
ON 
    O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY 
    P.product_code
ORDER BY
    SALES DESC,
    P.product_code ASC;

------------------------------------------------------------------------------------------------------

## 3. 가격대 별 상품 개수 구하기(Lv.2/GROUP BY)

## ROUND() : 반올림
## CEIL(): 올림 
## FLOOR(): 내림. 소수점을 버리고 가장 가까운 작거나 같은 정수로 내림. 
## TRUNC(): 버림. 특정 소수점 이하 자리수를 자르는 함수.

## FLOOR()와 TRUNC()의 차이: FLOOR()는 무조건 아래로 내림 / TRUNCATE()는 단순히 자릿수만 유지하고 버림 (음수일 때 방향이 다를 수 있음)


SELECT  
    FLOOR(PRICE/10000)*10000 AS PRICE_GROUP,
    COUNT(*) AS PRODUCTS
FROM 
    PRODUCT
GROUP BY 
    PRICE_GROUP
ORDER BY 
    PRICE_GROUP ASC;


## 덧) CASE WHEN로도 풀 수 있음. BUT, 확장성이 떨어짐
## CASE: 조건문. 아래는 CASE 구문의 예시

CASE WHEN (조건) THEN (값)
        ELSE (값)
END AS (값을 넣을 컬럼명)
FROM TABLE;

------------------------------------------------------------------------------------------------------

## 4. 월별 잡은 물고기 수 구하기(Lv.2/ GROUP BY)

## MONTH(): DATE, DATETIME, TIMESTAMP와 같은 시간 데이터 타입에서 월을 추출해주는 함수

SELECT 
    COUNT(*) AS FISH_COUNT,
    MONTH(TIME) AS MONTH
FROM 
    FISH_INFO
GROUP BY 
    MONTH
ORDER BY 
    MONTH ASC;

------------------------------------------------------------------------------------------------------

## 5. 연도별 평균 미세먼지 농도 조회하기 (Lv2./String, Date)

## 명령어 및 수치와 헷갈릴 수 있는 변수명은 ''로 감싸주기
SELECT 
    YEAR(YM) AS YEAR,
    ROUND(AVG(PM_VAL1),2) AS PM10, 
    ROUND(AVG(PM_VAL2),2) AS 'PM2.5'
FROM 
    AIR_POLLUTION
WHERE 
    LOCATION2 = '수원'
GROUP BY 
    YEAR(YM)
ORDER BY 
    YEAR ASC;

------------------------------------------------------------------------------------------------------

## 6. 루시와 엘라 찾기 (Lv.2 / String, Date)

SELECT 
    ANIMAL_ID,
    NAME,
    SEX_UPON_INTAKE
FROM 
    ANIMAL_INS
WHERE
    NAME IN ('Lucy', 'Ella', 'Pickle', 'Rogan', 'Sabrina', 'Mitty');

------------------------------------------------------------------------------------------------------

## 7. 고양이와 개는 몇 마리 있을까 (Lv.2 / GROUP BY)

SELECT 
    ANIMAL_TYPE,
    COUNT(*) AS count
FROM 
    ANIMAL_INS
GROUP BY 
    ANIMAL_TYPE
ORDER BY 
    ANIMAL_TYPE ASC;

------------------------------------------------------------------------------------------------------

## 8. 조건에 맞는 아이템들의 가격의 총합 구하기(Lv. 2 / SUM, MAX, MIN)

SELECT 
    SUM(PRICE) AS TOTAL_PRICE
FROM 
    ITEM_INFO
WHERE
    RARITY = 'LEGEND';

------------------------------------------------------------------------------------------------------

## 9. 물고기 종류별 잡은 수 구하기(Lv.2 / GROUP BY)

WITH FISH_TOTAL_INFO AS (
    SELECT 
        FISH_NAME, 
        FI.FISH_TYPE
    FROM FISH_INFO FI
    JOIN FISH_NAME_INFO FNI
    ON FI.FISH_TYPE = FNI.FISH_TYPE
)
SELECT 
    COUNT(FISH_TYPE) AS FISH_COUNT,
    FISH_NAME
FROM FISH_TOTAL_INFO
GROUP BY FISH_NAME
ORDER BY FISH_COUNT DESC;

------------------------------------------------------------------------------------------------------

## 10. 성분으로 구분한 아이스크림 총 주문량 (Lv.2 / GROUP BY)

SELECT 
    II.INGREDIENT_TYPE,
    SUM(FH.TOTAL_ORDER) AS TOTAL_ORDER
FROM FIRST_HALF FH
JOIN ICECREAM_INFO II
ON FH.FLAVOR = II.FLAVOR 
GROUP BY II.INGREDIENT_TYPE
ORDER BY TOTAL_ORDER ASC;

------------------------------------------------------------------------------------------------------

## 11. 노선별 평균 역 사이 거리 조회하기 (Lv.2 / GROUP BY) 
SELECT 
    ROUTE,
    CONCAT(ROUND(SUM(D_BETWEEN_DIST),1),'km') AS TOTAL_DISTANCE,
    CONCAT(ROUND(AVG(D_BETWEEN_DIST),2),'km') AS AVERAGE_DISTANCE
FROM SUBWAY_DISTANCE
GROUP BY ROUTE
ORDER BY SUM(D_BETWEEN_DIST) DESC;

------------------------------------------------------------------------------------------------------

## 12. ROOT 아이템 구하기 (IS NULL/Lv.2)
-- ROOT 아이템을 찾아 아이템 ID(ITEM_ID), 아이템 명(ITEM_NAME)을 출력하는 SQL문
-- 결과는 아이템 ID를 기준으로 오름차순

SELECT 
    IT.ITEM_ID,
    II.ITEM_NAME 
FROM ITEM_INFO II
LEFT JOIN ITEM_TREE IT
ON II.ITEM_ID = IT.ITEM_ID
WHERE IT.PARENT_ITEM_ID IS NULL
ORDER BY ITEM_ID ASC;