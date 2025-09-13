
# Data Preparation from RS3 Grand Exchange Database Online
SELECT 
* FROM
(
SELECT * FROM `runescapegeproj.rs3ge.rs3itemnames` 
WHERE NAME LIKE 'Elysian spirit shield' OR NAME
LIKE 'Noxious longbow' OR NAME LIKE 'Third age robe top' OR NAME LIKE 'Zaros godsword'OR NAME LIKE 'Virtus robe top' OR NAME LIKE 'Blue partyhat' OR NAME LIKE 'Ek-ZekKil' OR NAME LIKE 'Elite sirenic hauberk' OR NAME LIKE 'Noxious scythe' LIMIT 1000
) as tenitems 
INNER JOIN `runescapegeproj.rs3ge.rs3itemprices` ON
tenitems.Name_ID = `runescapegeproj.rs3ge.rs3itemprices`.id
;

# we join the names with the ids and filter for the 10 items
# that we need



# Data Cleaning and Preparation Step

# Check and count for Duplicate Rows
SELECT 
  *, COUNT(*) as numdupes 
FROM `runescapegeproj.rs3ge.rs3_filtered_data`
GROUP BY Name_ID, Name, int64_field_0, id, price, volume, date
HAVING COUNT(*) > 1;
#Row	Name_ID	Name	int64_field_0	id	price	volume	date


#Check if there are any empty values in any of the columns
SELECT 
*
FROM `runescapegeproj.rs3ge.rs3_filtered_data`
WHERE Name_ID IS NULL OR Name IS NULL 
OR int64_field_0 IS NULL
OR ID IS NULL 
OR PRICE IS NULL OR DATE IS NULL;


#Detect front and back whitespace of strings
SELECT
 LTRIM(name) as name
FROM `runescapegeproj.rs3ge.rs3_filtered_data`;


SELECT
  RTRIM(name) as name
FROM `runescapegeproj.rs3ge.rs3_filtered_data`;

#Check the length of the int64 field to see if there are any inconsistencies
# must be 6 
SELECT 
  int64_field_0
FROM `runescapegeproj.rs3ge.rs3_filtered_data`
WHERE LENGTH(CAST(int64_field_0 as STRING)) != 6 AND LENGTH(CAST(int64_field_0 as STRING)) != 7;

#Filter out for the last 3 months 
SELECT
  *
FROM `runescapegeproj.rs3ge.rs3_filtered_data`
WHERE EXTRACT(YEAR FROM DATE) = 2024 AND EXTRACT(MONTH FROM DATE) >= 6 and EXTRACT(MONTH FROM DATE) <= 9
ORDER BY date DESC;


# Check for negative prices
SELECT
 COUNT(price) as numnegative
 FROM `runescapegeproj.rs3ge.rs3_filtered_data`
 WHERE price < 0;


# Make sure that there are 9 names in the first place that are associated with this analysis
SELECT 
  Name_ID, Name 
FROM `runescapegeproj.rs3ge.rs3_filtered_data`
GROUP BY Name_ID, Name;




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



#Check if there are any outliers in day return
SELECT
 SUM(CASE WHEN day_return >= 1 THEN 1 ELSE 0 END) as total_return_outliers
FROM temp_returns;

#Check if there are outliers in volume and ID mismatches
SELECT 
  SUM(CASE WHEN VOLUME >= 100 THEN 1 ELSE 0 END) as total_volume_outliers,
  SUM(CASE WHEN Name_ID != ID THEN 1 ELSE 0 END) as total_id_mismatches,

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
 Name, Name_ID, AVG(price) as priceavg, MAX(price) - MIN(price) as max_price_diff
FROM temp_returns 
GROUP BY Name, Name_ID
ORDER BY priceavg DESC;


#Cumulative percent returns 
SELECT 
Name_ID, Name, (EXP(SUM(LOG(1 + day_return))) - 1) * 100 AS cumulative_return 
FROM temp_returns GROUP BY Name, Name_ID;

# Get he number of positive days
#and Get the number of negative days 
SELECT 
  Name_ID,
  SUM(CASE WHEN day_return > 0 THEN 1 ELSE 0 END) AS positive_days,
  SUM(CASE WHEN day_return < 0 THEN 1 ELSE 0 END) AS negative_days
FROM temp_returns
GROUP BY Name_ID;
