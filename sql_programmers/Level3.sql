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
