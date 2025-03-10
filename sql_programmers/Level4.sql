## 1. 5월 식품들의 총매출 조회하기(Lv.4/JOIN)
SELECT 
    fp.PRODUCT_ID, 
    fp.PRODUCT_NAME,
    SUM(fo.AMOUNT* fp.PRICE) AS TOTAL_SALES
FROM FOOD_ORDER fo
LEFT JOIN FOOD_PRODUCT fp
ON fp.PRODUCT_ID = fo.PRODUCT_ID
WHERE YEAR(fo.PRODUCE_DATE) = '2022' AND MONTH(fo.PRODUCE_DATE) = '5'
GROUP BY 
    fp.PRODUCT_ID 
ORDER BY 
    TOTAL_SALES DESC,
    fp.PRODUCT_ID ASC;

-------------------------------------------------------------------------------

## 2. 식품분류별 가장 비싼 식품의 정보 조회하기(Lv.4/GROUP BY)

SELECT 
    CATEGORY, 
    PRICE AS MAX_PRICE, 
    PRODUCT_NAME
FROM FOOD_PRODUCT
WHERE PRICE IN(
    SELECT MAX(PRICE)
    FROM FOOD_PRODUCT
    GROUP BY CATEGORY) 
AND CATEGORY IN ('과자', '국', '김치', '식용유')
ORDER BY MAX_PRICE DESC;

-------------------------------------------------------------------------------

## 3. FRONTEND 개발자 찾기 (Lv.4 / JOIN)

## 다 더해서 비트 마스킹 하는 식으로 풀이함.

SELECT 
    D.ID, 
    D.EMAIL, 
    D.FIRST_NAME, 
    D.LAST_NAME 
FROM 
    DEVELOPERS D
WHERE 
    D.SKILL_CODE & (
        SELECT SUM(SC.CODE) 
        FROM SKILLCODES SC 
        WHERE SC.CATEGORY = 'Front End'
    ) > 0
ORDER BY 
    D.ID ASC;