## 3월에 태어난 여성 회원 목록 출력하기 (Lv.2/SELECT)

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

## 상품 별 오프라인 매출 구하기 (Lv.2/JOIN)

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

## 가격대 별 상품 개수 구하기(Lv.2/GROUP BY)

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