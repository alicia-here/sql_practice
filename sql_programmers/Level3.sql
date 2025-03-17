## 1. 카테고리별 도서 판매량(Lv.3 / GROUP BY) 

WITH BOOK_TOTAL AS (
    SELECT B.BOOK_ID,
        B.CATEGORY,
        BS.SALES
    FROM BOOK_SALES BS 
    LEFT JOIN BOOK B
    ON BS.BOOK_ID = B.BOOK_ID
    WHERE YEAR(SALES_DATE) = 2022
    AND MONTH(SALES_DATE) = 1
)
SELECT CATEGORY, 
       SUM(SALES) AS TOTAL_SALES 
FROM BOOK_TOTAL
GROUP BY CATEGORY
ORDER BY CATEGORY ASC;

------------------------------------------------------------------------------------------------------

## 2. 업그레이드 할 수 없는 아이템 구하기 (Lv.3 / IS NULL)

WITH FIND_NEXT AS (SELECT 
                   II.ITEM_ID,
                   II.ITEM_NAME,
                   II.RARITY,
                   IT.PARENT_ITEM_ID,
                   IT.ITEM_ID AS NEXT
                   FROM ITEM_INFO II
                   LEFT JOIN ITEM_TREE IT
                   ON II.ITEM_ID = IT.PARENT_ITEM_ID)
SELECT 
    ITEM_ID,
    ITEM_NAME,
    RARITY
FROM 
    FIND_NEXT
WHERE
    NEXT IS NULL
ORDER BY
    ITEM_ID DESC;

------------------------------------------------------------------------------------------------------

## 3. 부서별 연봉 조회하기 (Lv.3 / GROUP BY)

WITH CHECK_SALARY AS (SELECT 
                        HE.EMP_NO,
                        HE.DEPT_ID,
                        HD.DEPT_NAME_EN,
                        HE.SAL
                      FROM
                        HR_EMPLOYEES HE
                      LEFT JOIN 
                        HR_DEPARTMENT HD
                      ON 
                        HE.DEPT_ID = HD.DEPT_ID)
SELECT 
    DEPT_ID, 
    DEPT_NAME_EN,
    ROUND(AVG(SAL)) AS AVG_SAL
FROM 
    CHECK_SALARY
GROUP BY
    DEPT_ID
ORDER BY 
    AVG_SAL DESC;

------------------------------------------------------------------------------------------------------

## 4. 대장균의 크기에 따라 분류하기 1(Lv. 3 / SELECT)

-- CASE WHEN은 SELECT, UPDATE, INSERT, WHERE 문에서 사용할 수 있음. 
SELECT 
    ID, 
    CASE WHEN SIZE_OF_COLONY <= 100 THEN 'LOW'
         WHEN (SIZE_OF_COLONY > 100) AND (SIZE_OF_COLONY <= 1000) THEN 'MEDIUM'
         WHEN SIZE_OF_COLONY > 1000 THEN 'HIGH'
    END AS SIZE
FROM 
    ECOLI_DATA
ORDER BY ID ASC;

------------------------------------------------------------------------------------------------------

## 5. 특정 조건을 만족하는 물고기별 수와 최대 길이 구하기 (Lv.3 /GROUP BY)

WITH FISH_NOT_NULL AS (SELECT 
                        FISH_TYPE,
                        CASE WHEN LENGTH IS NULL THEN 10
                        ELSE LENGTH
                        END AS NEW_LENGTH
                        FROM FISH_INFO), 
FISH_AVG AS (SELECT 
                FISH_TYPE,
                AVG(LENGTH) AS AVG_LENGTH
                FROM FISH_INFO
                GROUP BY FISH_TYPE),
FISH_TOTAL_INFO AS (SELECT FNN.FISH_TYPE,
                           FNN.NEW_LENGTH,
                           FA.AVG_LENGTH
                        FROM FISH_NOT_NULL FNN
                        JOIN FISH_AVG FA
                        ON FNN.FISH_TYPE = FA.FISH_TYPE)
SELECT 
    COUNT(*) AS FISH_COUNT,
    MAX(NEW_LENGTH) AS MAX_LENGTH,
    FISH_TYPE
FROM FISH_TOTAL_INFO
WHERE AVG_LENGTH >= 33
GROUP BY FISH_TYPE
ORDER BY FISH_TYPE ASC; 

-- 아래는 리팩토링 코드 (첫 코드가 길어서 COALESCE()를 통한 코드 간소화)

## COALESCE(컬럼명, 대체값) : NULL 값을 다른 값으로 대체할 때 사용하는 함수

WITH FISH_INFO_RENEW AS (
    SELECT 
        FISH_TYPE,
        COALESCE(LENGTH, 10) AS NEW_LENGTH
    FROM FISH_INFO
)
SELECT 
    FISH_TYPE,
    COUNT(*) AS FISH_COUNT,
    MAX(NEW_LENGTH) AS MAX_LENGTH
FROM FISH_INFO_RENEW
GROUP BY FISH_TYPE
HAVING AVG(NEW_LENGTH) >= 33
ORDER BY FISH_TYPE ASC;

