## 1. 특정 형질을 가지는 대장균 찾기 (Lv.1/SELECT)

## 비트연산자
## &:대응되는 비트가 모두 1이면 1을 반환함 
## 예) b'1000' & b'1111', -- 첫 번째 비트만이 둘 다 1이므로, 연산 결과는 b'1000'이 됨.
## | 대응되는 비트 중에서 하나라도 1이면 1을 반환함
## 예) b'1000' | b'1111', -- 모든 비트에 하나라도 1이 포함되어 있으므로, 연산 결과는 b'1111'이 됨.
## 출처: https://inpa.tistory.com/entry/MYSQL

SELECT COUNT(*) AS COUNT
FROM ECOLI_DATA
WHERE (GENOTYPE & 2) != 2
AND ((GENOTYPE & 4) = 4 OR (GENOTYPE & 1) = 1);

------------------------------------------------------------------------------------------------------

## 2. 가장 큰 물고기 10마리 구하기 (Lv.1/SELECT)

## ORDER BY는 한번만 쓸 수 있음. 조건이 두 개라면 쉼표로 구분해주기

SELECT ID, LENGTH FROM FISH_INFO
WHERE LENGTH IS NOT NULL 
ORDER BY LENGTH DESC, ID ASC
LIMIT 10;

------------------------------------------------------------------------------------------------------

## 3. 특정 물고기를 잡은 총 수 구하기 (Lv.1/SELECT)

## IN (지정 값 여러개를 쉼표로 구분): 괄호 안에 값 중에 하나라도 일치하는지 확인하는 기능

SELECT COUNT(*) AS FISH_COUNT FROM FISH_INFO fi
LEFT JOIN FISH_NAME_INFO fni
ON fi.FISH_TYPE = fni.FISH_TYPE
WHERE FISH_NAME IN ('BASS', 'SNAPPER');

------------------------------------------------------------------------------------------------------

## 4. 한 해에 잡은 물고기 수 구하기(Lv.1/String,Date)

## YEAR(): 년도 추출 

SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO
WHERE YEAR(TIME) = 2021;

------------------------------------------------------------------------------------------------------

## 5. 분기별 분화된 대장균의 개체 수 구하기 (Lv.1/String, Date)

## QUARTER (): 4분기로 구분하여 값을 내는 함수(3,6,9,12월)
## CONCAT() : 문자열 결합

SELECT CONCAT(QUARTER(DIFFERENTIATION_DATE), 'Q') AS QUARTER,
COUNT(*) AS ECOLI_COUNT
FROM ECOLI_DATA 
GROUP BY QUARTER
ORDER BY QUARTER;

# 오답노트 
## string concat할 때는 꼭 '' 적어주기

------------------------------------------------------------------------------------------------------

## 6. 잡은 물고기 중 가장 큰 물고기의 길이 구하기 (Lv.1/SUM, MAX, MIN)

## MAX(): 최댓값 출력
SELECT CONCAT(MAX(LENGTH), "cm") AS MAX_LENGTH
FROM FISH_INFO;

------------------------------------------------------------------------------------------------------

## 7. 잔챙이 잡은 수 구하기 (Lv.1/ SELECT)

## IS NULL: NULL인 값인지 판단하여 NULL을 찾는 함수

SELECT COUNT(*) AS FISH_COUNT 
FROM FISH_INFO
WHERE LENGTH IS NULL;

------------------------------------------------------------------------------------------------------

## 8. Python 개발자 찾기

## IN (지정 값 여러개를 쉼표로 구분): 괄호 안에 값 중에 하나라도 일치하는지 확인하는 기능

SELECT 
    ID, 
    EMAIL, 
    FIRST_NAME, 
    LAST_NAME 
FROM DEVELOPER_INFOS
WHERE "Python" IN (SKILL_1, SKILL_2, SKILL_3)
ORDER BY ID ASC;

------------------------------------------------------------------------------------------------------

## 9. 잡은 물고기의 평균 길이 구하기 (Lv.1/IS NULL)

##  COALESCE(column_name, default_value):특정 컬럼이 NULL일 경우 기본값을 대신 반환하는 함수

SELECT 
    ROUND(AVG(COALESCE(LENGTH, 10)), 2) AS AVERAGE_LENGTH
FROM 
    FISH_INFO;

------------------------------------------------------------------------------------------------------

## 10. 평균 일일 대여 요금 구하기 (Lv.1/SELECT)

## AVG() : 평균 출력 함수 
## ROUND(): 반올림 함수

SELECT ROUND(AVG(DAILY_FEE),0) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = 'SUV';

------------------------------------------------------------------------------------------------------

## 11. 과일로 만든 아이스크림 고르기 (Lv.1/SELECT)

## JOIN(): 테이블 조인 (MySQL default는 INNER JOIN)
## TIP: AND 조건은 ()로 잘 묶어주기
## ORDER BY: 오름차순 ASC, 내림차순 DESC 

SELECT fh.FLAVOR
FROM FIRST_HALF fh LEFT JOIN ICECREAM_INFO ii
ON fh.FLAVOR = ii.FLAVOR
WHERE (fh.TOTAL_ORDER >= 3000) AND (ii.INGREDIENT_TYPE = 'fruit_based')
ORDER BY fh.TOTAL_ORDER DESC;

------------------------------------------------------------------------------------------------------

## 12. 특정 옵션이 포함된 자동차 리스트 구하기(Lv1./String, Date)

## %: 길이와 상관없이 앞뒤로 0개 이상의 텍스트가 있는 경우, 따라서 '%SQL%'이라면 SQL이 포함된 모든 결과를 반환한다. 

SELECT 
    *
FROM 
    CAR_RENTAL_COMPANY_CAR
WHERE 
     OPTIONS LIKE '%네비게이션%'
ORDER BY 
    CAR_ID DESC;