


ALTER TABLE events
Add  Event_Date Date ;
UPDATE Events
SET Event_Date = LEFT(Event_Time,10);

ALTER TABLE events
Add Event_New_Time Time(0);
UPDATE Events
SET Event_New_Time = SubString(Event_Time, 12,8);




-- Sum of Sales by Months

SELECT YEAR(Event_Date) AS Year, MONTH(Event_Date) AS Month,
MONTHNAME(Month,Event_Date) AS Month_Name,
COUNT(Event_Time) AS Net_Sales, ROUND(SUM(Price), 2) AS Sum_of_Total_Sales
FROM events
WHERE event_type = 'purchase'
GROUP BY  Year(Event_Date), MONTH(Event_Date), DateName(Month,Event_Date) 
ORDER BY count(Event_Time) DESC, Sum(Price) DESC;


-- Top Hours by Views

  WITH Hour_View AS (
  SELECT Datepart(Hour,Event_New_Time) AS Hour_UTC, Count(*) AS Total_View,
  DENSE_RANK() OVER(ORDER BY Count(*) DESC) AS rn
  FROM Events
  WHERE Event_Type = 'View'
  GROUP BY Datepart(Hour,Event_New_Time)
   )
  SELECT * 
  FROM Hour_View 
  WHERE rn <= 10 ;
  
  
    -- Top Hours by Purchase

  WITH Hour_Purchase AS (
  SELECT Datepart(Hour,Event_New_Time) AS Hour_UTC, Count(*) AS Total_View,
  DENSE_RANK() OVER(ORDER BY Count(*) DESC) AS rn
  FROM Events
  WHERE Event_Type = 'Purchase' 
  GROUP BY Datepart(Hour,Event_New_Time)
   )
  SELECT * 
  FROM Hour_Purchase 
  WHERE rn <= 10 ;
  
  
    -- Most Sold Brand

  WITH Most_Sold_Brand AS (
  SELECT Brand, COUNT(*) AS Total_Sold,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) rn
  FROM events
  WHERE Event_Type = 'Purchase' 
  AND  
  Brand IS NOT NULL
  GROUP BY Brand )
  SELECT * FROM Most_Sold_Brand
  WHERE rn <= 10 ;
  
  
   -- Most View Brand
   
   
  WITH Most_View_Brand AS (
  SELECT Brand, COUNT(*) AS Total_View,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) rn
  FROM events
  WHERE Event_Type = 'View' 
  AND  
  Brand IS NOT NULL
  GROUP BY Brand )
  SELECT * FROM Most_View_Brand
  WHERE rn <= 10 ;
  
  
    -- Most Sold Category

  WITH Most_Sold_Category AS (
  SELECT Category_Code, COUNT(*) AS Total_Sold,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) rn
  FROM events
  WHERE Event_Type = 'Purchase' 
  AND  
  Category_Code IS NOT NULL
  GROUP BY Category_Code )
  SELECT * FROM Most_Sold_Category
  WHERE rn <= 10 ;
  
  
    -- Most View Category

  WITH Most_View_Category AS (
  SELECT Category_Code, COUNT(*) AS Total_View,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) rn
  FROM events
  WHERE Event_Type = 'View' 
  AND  
  Category_Code IS NOT NULL
  GROUP BY Category_Code )
  SELECT * FROM Most_View_Category
  WHERE rn <= 10 ;
  
  
  
   -- Category most sold and view
   
   
   WITH Most_Sold_Category AS (
  SELECT Category_Code, COUNT(*) AS Total_Sold,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) sold_rn
  FROM events
  WHERE Event_Type = 'Purchase' 
  AND  
  Category_Code IS NOT NULL
  GROUP BY Category_Code ),
  
  Most_View_Category AS (
  SELECT Category_Code, COUNT(*) AS Total_View,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) View_rn
  FROM events
  WHERE Event_Type = 'View' 
  AND  
  Category_Code IS NOT NULL
  Group By Category_Code )

  SELECT s.Category_Code, s.Total_Sold,  v.Total_View 
  FROM Most_Sold_Category s 
  INNER JOIN Most_View_Category v 
  ON s.Category_Code = v.Category_Code
  WHERE s.sold_rn <= 10 AND v.View_rn <= 10
  ORDER BY s.sold_rn, v.View_rn ;
  
  
   -- Brand Most View and Most Sold

  WITH Most_Sold_Brand AS (
  SELECT Brand, COUNT(*) AS Total_Sold,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) Sold_rn
  FROM events
  WHERE Event_Type = 'Purchase' 
  AND  
  Brand IS NOT NULL
  GROUP BY Brand ) ,

  Most_View_Brand AS (
  SELECT Brand, COUNT(*) AS Total_View,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) View_rn
  FROM events
  WHERE Event_Type = 'View' 
  AND  
  Brand IS NOT NULL
  GROUP BY Brand )

  SELECT v.Brand, v.Total_View, s.Total_Sold
  FROM Most_View_Brand v 
  INNER JOIN  Most_Sold_Brand s 
  ON v.Brand = s.Brand
  WHERE v.View_rn <= 10 AND s.Sold_rn <= 10
  ORDER BY v.Brand ;
  
  
   -- Frequency of Purchase After Viewing
  
  SELECT COUNT(Event_Type) AS Times_Purchased
  FROM Events E1
  WHERE EXISTS( Select *
  FROM Events E2 
  WHERE E1.User_id=E2.User_id AND E1.Product_id=E2.Product_id 
  AND
  E2.Event_Type = 'View'
  AND
  E1.Event_Type = 'Purchase' );
  
  
  SELECT COUNT(Event_Type) AS Times_Viewed
  FROM Events
  WHERE Event_Type = 'View';
  
  
    -- Frequency of Purchase

  SELECT CAST(User_id AS BIGINT) AS User_id, COUNT(*) AS Total
  FROM events
  WHERE Event_Type = 'Purchase' 
  GROUP BY User_id
  ORDER BY Total Desc;
  
  
  
  
  
  
  
  
  
  

  
  
  













 