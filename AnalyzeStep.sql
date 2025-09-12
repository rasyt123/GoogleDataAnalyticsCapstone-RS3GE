
# Process + Analyze Steps

# We first need to check how many dates are in each we have 
# to take this into consideration in the analysis 

SELECT 
 Name, Name_ID, COUNT(date) as numdates
 FROM `runescapegeproj.rs3ge.rs3_filtered_data`
 GROUP by Name_ID, Name;


# We first make calculations to find the quanity sold 
# We create a temporary table to find the daily return rates 
# Goal is to find the standard deviation 
CREATE TEMP TABLE temp_returns AS
SELECT
    Name_ID, Name,
    date,
    price,
    (price - LAG(price) OVER (PARTITION BY Name ORDER BY date))
      / LAG(price) OVER (PARTITION BY Name ORDER BY date) AS day_return
FROM `runescapegeproj.rs3ge.rs3_filtered_data`;


# This is to calculate the STANDARD DEVIATION OF PERCENTAGE RETURNS
SELECT
  dev.Name_ID, SQRT(AVG(dev.ddiff)) as sd
FROM (
  SELECT 
    temp_returns.Name_ID, (day_return - dailyaverage) * (day_return - dailyaverage) as ddiff
  FROM (
    SELECT 
      Name_ID, AVG(day_return) as dailyaverage
    FROM temp_returns
    GROUP BY Name_ID
  ) as avgreturns
  INNER JOIN temp_returns 
    ON avgreturns.Name_ID = temp_returns.Name_ID
) as dev
GROUP BY dev.Name_ID;


# This is to compare the amount of QUANTITY SOLD 
SELECT 
   Name_ID, Name, SUM(volume) as totalquantity
FROM `runescapegeproj.rs3ge.rs3_filtered_data`
GROUP by Name_ID, Name
ORDER BY totalquantity DESC;


#Average percentage change
SELECT 
 Name, Name_ID, AVG(day_return) as avgdatareturns, MAX(day_return) as returnmax, MIN(day_return) as returnmin
FROM temp_returns 
GROUP BY Name, Name_ID
ORDER BY avgdatareturns DESC;


#Rank by most expensive to least expensive based on average pricing 
SELECT 
 Name, Name_ID, AVG(price) as priceavg
FROM temp_returns 
GROUP BY Name, Name_ID
ORDER BY priceavg DESC;












