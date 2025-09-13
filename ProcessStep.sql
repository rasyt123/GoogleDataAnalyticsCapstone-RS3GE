
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

