# Google Data Analytics Capstone-RS3GE
Google Analytics Capstone Project (SQl, Tableau)
By Justin Y

# Introduction

For this project, the business task I assigned for myself consisted of ranking 10 expensive items by volatility after 3 months from June to September 2024 in Runescape 3. Runescape, an old, but long-standing MMORPG, which is one of my favorite games, has an extensive in-game economy. I thought it would be a good idea to analyze highly sought after items, providing business metrics and informing the playerbase to make more informed financial decisions. Here was the first question that I asked myself: how do we measure volatility?



# Ask
To figure out how to come up with an answer to that, I came up with a couple of follow up questions pertaining to this task.

1. When making smart financial decisions, what do we care about the most?
2. Of the 9 items, which of them are generating the most revenue form June to September 2024?
3. What metrics could we pick that would suit volality and be the easiest in allowing for recommendations?

Answers:
1. Generally speaking, when it comes to making purchases, receiving a net profit on prices or stable increases in revenue and finding the amount of items that were sold influence the financial decisions you make. I went with these as the basis for my analysis, and if I weighed all of these metrics together, I would able to see which products to recommend to buy. The first step in obtaining these foundational metrics required I prepare the dataset to work with.


# Prepare
After digging for a while online, I couldn't find a public data set for OSRS (Oldschool Runescape), but I stumbled upon a dataset holding Grand Exchange data for Runescape 3 from Kaggle. To provide some context, the Grand Exchange is a trading hub where you can list items on a marketplace for a certain price and people can buy items off of you. It functions exactly like a real auction house. In order to retrive the specific data I needed, I first went onto the Runescape 3 wiki web and chose 10 expensive items. I knew immediately that I wanted to use BigQuery and SQL to process this data. To filter out the data for those items, I created a query that joined the rs3 item names data set with the item prices data set because the main transactions data set did not have the names of the items, only their ids. The result of this query needed further cleaning before analysis.

<img width="1644" height="243" alt="image" src="https://github.com/user-attachments/assets/800ba1e2-6392-45da-91c4-f4797774e370" />


# Process
There are a few fundamental steps to cleaning and processing the data once you've sorted for the data you actually need. At this point I had gotten all the transaction records of the items that were listed in the query above. For this next step, I filtered the data again to only retrieve the records from June to September 2024. I counted the number of duplicates, checked for empty values in any of the columns, trimmed whitespace to be sure, checked for length differences, negative prices, and if the correct names were shown. The process sql file that I added to this repository carries out these steps. Here's an example: 

<img width="422" height="127" alt="image" src="https://github.com/user-attachments/assets/803b161a-feac-48e9-af4a-883d22566cfc" />



# Analyze
To see which products were worth buying, I created a temporary table holding the calculations of all the daily percent changes of the price as daily_returns. This would allow me to calculate the standard deviation on price returns, which could show us how much products were flucuating, but also basic summary statistics (average, min, max). Being able to know the standard deviation can tell you whether the spread of change was big, small, or even negligible. I also calculated the amount of items that were sold within those 3 items to get an idea of the demand. On top of that,
the total net percentage return on each of the 9 items was something I needed to take into account.



# Share
I created a dashboard in Tableau monitoring the calculations I described earlier. What I found was that over this three month period, almost all of the items were non-volatile. This is due to the fact that the SD in percentages (SD on returns) was actually extremely small over the entire board. Furthermore, the average price change percentage wise on a day-to-day basis was extremely small. However, we found a couple discrepancies in demand for products. The virtus robes were sold the most and had the highest cumulative percentage changes while being non-volatile. Ranked second is the third age robe top. The robe top had one of the lower quantities of sales at around 700 but still was non-volatile with positive price returns. 


![Dashboard preview](https://public.tableau.com/static/images/rs/rs3geexpensiveitems/Dashboard1/1.png)



# Conclusion / Share
I actually recommend the playerbase to purchase the top 3 items from this dashboard in terms of cumulative percentage because all the items actually have low volatility. The virtus robe top gets traded the most. They still have relatively high demand. Even though all the items can be ranked by volatiltiy their differences across all the items is negligible, so looking at quantity sold, net profit, and average percent changes would be a good idea to decide whether or not to purchase them. Overall, this project was fairly difficult due to the amount of time it took to search for the data. It was hard for me to create the dashboard and find the specific tools needed to decorate and outline it. I still had fun though.
