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
    
-------------------------------------------------------------------------------

## 4. 주문량이 많은 아이스크림 (Lv.4 / JOIN)
-- UNION : 중복된 값 제외
-- UNION ALL: 중복된 값도 보여줌

WITH ALL_ORDER AS ((SELECT * 
                    FROM JULY)
                    UNION
                    (SELECT * 
                    FROM FIRST_HALF))
SELECT 
    FLAVOR
FROM ALL_ORDER
GROUP BY FLAVOR
ORDER BY SUM(TOTAL_ORDER) DESC
LIMIT 3;

-------------------------------------------------------------------------------

## 5. 언어별 개발자 분류하기 (Lv.4 / GROUP BY)

-- 첫시도. 다소 직관적이지 않은 코드 
WITH CODE_INFO AS (SELECT
                            * 
                         FROM SKILLCODES
                         WHERE (NAME = 'C#') OR
                            (NAME = 'Python') OR 
                            (CATEGORY = 'Front End'))
SELECT 
    CASE 
        WHEN 
            (SKILL_CODE & (SELECT CODE FROM CODE_INFO WHERE NAME = 'Python')) > 0 
            AND (SKILL_CODE & (SELECT SUM(CODE) FROM CODE_INFO WHERE CATEGORY = 'Front End')) > 0 THEN 'A'
        WHEN (SKILL_CODE & (SELECT CODE FROM CODE_INFO WHERE NAME = 'C#')) > 0 THEN 'B'
        WHEN (SKILL_CODE & (SELECT SUM(CODE) FROM CODE_INFO WHERE CATEGORY = 'Front End')) > 0 THEN 'C'    
    END AS GRADE, 
    ID, 
    EMAIL
FROM DEVELOPERS
WHERE (SKILL_CODE & (SELECT CODE FROM CODE_INFO WHERE NAME = 'Python')) > 0 
    OR (SKILL_CODE & (SELECT CODE FROM CODE_INFO WHERE NAME = 'C#')) > 0
    OR (SKILL_CODE & (SELECT SUM(CODE) FROM CODE_INFO WHERE CATEGORY = 'Front End')) > 0
ORDER BY GRADE, ID ASC;

-- 길이는 비교적 길지만 직관적인 코드 (동료 코드 참고)
WITH A_GRADE AS (
    SELECT B.ID, 'A' AS GRADE
    FROM DEVELOPERS B
    WHERE EXISTS (
        SELECT 1 FROM SKILLCODES A
        WHERE (A.CODE & B.SKILL_CODE) != 0 AND A.NAME = 'PYTHON'
    )
    AND EXISTS (
        SELECT 1 FROM SKILLCODES A
        WHERE (A.CODE & B.SKILL_CODE) != 0 AND A.CATEGORY = 'Front End'
    )
),
B_GRADE AS (
    SELECT B.ID, 'B' AS GRADE
    FROM DEVELOPERS B
    WHERE EXISTS (
        SELECT 1 FROM SKILLCODES A
        WHERE (A.CODE & B.SKILL_CODE) != 0 AND A.NAME = 'C#'
    )
),
C_GRADE AS (
    SELECT B.ID, 'C' AS GRADE
    FROM DEVELOPERS B
    WHERE EXISTS (
        SELECT 1 FROM SKILLCODES A
        WHERE (A.CODE & B.SKILL_CODE) != 0 AND A.CATEGORY = 'Front End'
    )
),
ALL_GRADES AS (
    SELECT * FROM A_GRADE
    UNION
    SELECT * FROM B_GRADE
    UNION
    SELECT * FROM C_GRADE
)

SELECT 
    MIN(GRADE) AS GRADE,
    D.ID,
    D.EMAIL
FROM ALL_GRADES G
JOIN DEVELOPERS D ON G.ID = D.ID
GROUP BY D.ID, D.EMAIL
ORDER BY GRADE, D.ID;

-------------------------------------------------------------------------------

## 6. 연간 평가점수에 해당하는 평가 등급 및 성과급 조회하기(LV.4 / GROUP BY)

WITH GRADE_INFO AS (SELECT 
            HE.EMP_NO, 
            HE.EMP_NAME, 
            HE.SAL,
            CASE WHEN (AVG(HG.SCORE) >= 96) THEN 'S'
                 WHEN (AVG(HG.SCORE) >= 90) AND (AVG(HG.SCORE) < 96) THEN 'A'
                 WHEN (AVG(HG.SCORE) >= 80) AND (AVG(HG.SCORE) < 90) THEN 'B'
                 ELSE 'C'
            END AS 'GRADE'   
        FROM 
            HR_EMPLOYEES HE
        LEFT JOIN 
            HR_GRADE HG
        ON HE.EMP_NO = HG.EMP_NO
        GROUP BY HE.EMP_NO)
SELECT 
    EMP_NO, 
    EMP_NAME,
    GRADE,
    CASE WHEN GRADE = 'S' THEN SAL*0.2
         WHEN GRADE = 'A' THEN SAL*0.15
         WHEN GRADE = 'B' THEN SAL*0.1
         WHEN GRADE = 'C' THEN SAL*0
    END AS 'BONUS'
FROM GRADE_INFO
ORDER BY EMP_NO ASC;    