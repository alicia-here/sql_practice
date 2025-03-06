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