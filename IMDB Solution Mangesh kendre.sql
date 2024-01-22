USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM director_mapping; -- 3867
SELECT COUNT(*) FROM genre; -- 14662
SELECT COUNT(*) FROM movie; -- 7997
SELECT COUNT(*) FROM names; -- 25735
SELECT COUNT(*) FROM ratings; -- 7997
SELECT COUNT(*) FROM role_mapping; -- 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

  SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie; 
-- COLUMNS WITH NULL VALUES ARE COUNTRY , WORLDWIDE_GROSS_INCOME, LANGUAGES, PROCUTION_COMPANY


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  YEAR, COUNT(TITLE) AS NUMBER_OF_MOVIES
FROM MOVIE
GROUP BY YEAR;

SELECT MONTH(DATE_PUBLISHED) AS MONTH_NUM, COUNT(TITLE) AS NUMBER_OF_MOVIES
FROM MOVIE
GROUP BY MONTH_NUM
ORDER BY MONTH_NUM;
/*
MONTH_NUM, NUMBER_OF_MOVIES
1, 804
2, 640
3, 824
4, 680
5, 625
6, 580
7, 493
8, 678
9, 809
10, 801
11, 625
12, 438
*/
-- Highest no of movies in the month of March and lowest in december


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(DISTINCT ID),
 YEAR FROM MOVIE  
 WHERE( COUNTRY LIKE '%INDIA%' OR COUNTRY LIKE '%USA%') AND YEAR = 2019; -- 1059 MOVIES IN 2019 PRODUCED IN INDIA OR USA


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT COUNT(distinct GENRE) 
FROM GENRE; -- 13 UNIQUE GENRES


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT GENRE, count(M.ID) AS NO_OF_MOVIES
FROM MOVIE AS M
INNER JOIN GENRE AS G
ON G.MOVIE_ID = M.ID
GROUP BY GENRE
ORDER BY NO_OF_MOVIES DESC;
-- DRAMA HAS THE HIGHEST NO OF MOVIES PRODUCED - 4285


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre  AS (SELECT movie_id  FROM   genre
GROUP  BY movie_id
HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre;

-- 3289 MOVIES HAVE ONLY ONE GENRE


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT GENRE , ROUND(AVG(DURATION),2) AS AVG_DURATION
FROM MOVIE AS M
INNER JOIN GENRE AS G
ON M.ID = G.MOVIE_ID
GROUP BY GENRE
ORDER BY AVG_DURATION DESC;
/* 
GENRE, AVG_DURATION
Action	112.88
Romance	109.53
Crime	107.05
Drama	106.77
Fantasy	105.14
Comedy	102.62
Adventure	101.87
Mystery	101.80
Thriller	101.58
Family	100.97
Others	100.16
Sci-Fi	97.94
Horror	92.72
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH GENRE_DETAILS AS (SELECT GENRE, COUNT(MOVIE_ID) AS MOVIE_COUNT, RANK()OVER  (ORDER BY COUNT(MOVIE_ID) DESC) AS GENRE_RANK
FROM GENRE
GROUP BY GENRE)
SELECT * FROM GENRE_DETAILS
WHERE GENRE = 'THRILLER';
-- The genre Thriller has a movie count of 1484 and rank of 3

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1		|			10		|	       100		  |	   725138    		 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(AVG_RATING) AS MIN_AVG_RATING, 
MAX(AVG_RATING) AS MAX_AVG_RATING,
 MIN(TOTAL_VOTES) AS MIN_TOTAL_VOTES, 
 MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
 MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING,
 MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING
 
 FROM RATINGS;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT TITLE, AVG_RATING, RANK() OVER (ORDER BY AVG_RATING DESC) AS MOVIE_RANK
FROM MOVIE AS M
INNER JOIN
RATINGS AS R
ON R.MOVIE_ID = M.ID LIMIT 10;

/*
TITLE   						AVG_RATING  MOVIE_RANK
Kirket							10.0			1
Love in Kilnerry				10.0			1
Gini Helida Kathe				9.8				3
Runam							9.7				4
Fan								9.6				5
Android Kunjappan Version5.25	9.6				5
Yeh Suhaagraat Impossible		9.5				7
Safe							9.5				7
The Brighton Miracle			9.5				7
Shibu							9.4				10
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT COUNT(MOVIE_ID) AS MOVIE_COUNT, MEDIAN_RATING
FROM RATINGS
GROUP BY MEDIAN_RATING
ORDER BY MOVIE_COUNT DESC;

/*
MOVIE_COUNT MEDIAN_RATING
2257		7
1975		6
1030		8
985			5
479			4
429			9
346			10
283			3
119			2
94			1
*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH HIT_PRODUCTION_COMPANY AS
(SELECT PRODUCTION_COMPANY, COUNT(MOVIE_ID) AS MOVIE_COUNT, 
RANK() OVER( ORDER BY COUNT(MOVIE_ID) DESC) AS PROD_COMPANY_RANK
FROM RATINGS AS R
INNER JOIN 
MOVIE AS M
ON M.ID = R.MOVIE_ID
WHERE AVG_RATING > 8
AND PRODUCTION_COMPANY IS NOT NULL
GROUP BY PRODUCTION_COMPANY)
SELECT * FROM HIT_PRODUCTION_COMPANY
WHERE PROD_COMPANY_RANK = 1;
-- Dream Warrior Pictures AND National Theatre Live	ARE THE PRODUCTION HOUSES WITH MOST HIT PRODUCTIONS


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT GENRE, COUNT(M.ID) AS MOVIE_COUNT
FROM GENRE AS G
INNER JOIN 
MOVIE AS M
ON M.ID = G.MOVIE_ID
INNER JOIN
RATINGS AS R
ON R.MOVIE_ID = M.ID
WHERE M.YEAR = 2017
AND MONTH(DATE_PUBLISHED) = 3
AND TOTAL_VOTES > 1000
AND COUNTRY LIKE '%USA%'
GROUP BY GENRE
ORDER BY MOVIE_COUNT DESC;

/*
GENRE MOVIE_COUNT
Drama	24
Comedy	9
Action	8
Thriller	8
Sci-Fi	7
Crime	6
Horror	6
Mystery	4
Romance	4
Fantasy	3
Adventure	3
Family	1
*/


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
			TITLE, AVG_RATING, GENRE
FROM 		MOVIE AS M
			INNER JOIN
			GENRE AS G
			ON G.MOVIE_ID = M.ID
			INNER JOIN
			RATINGS AS R
			ON M.ID = R.MOVIE_ID
WHERE 	
		AVG_RATING > 8
AND 
		TITLE LIKE 'THE%'
ORDER BY AVG_RATING DESC;


/*
TITLE									AVG_RATING		GENRE
The Brighton Miracle						9.5			Drama
The Colour of Darkness						9.1			Drama
The Blue Elephant 2							8.8			Drama
The Blue Elephant 2							8.8			Horror
The Blue Elephant 2							8.8			Mystery
The Irishman								8.7			Crime
The Irishman								8.7			Drama
The Mystery of Godliness: The Sequel		8.5			Drama
The Gambinos								8.4			Crime
The Gambinos								8.4			Drama
Theeran Adhigaaram Ondru					8.3			Action
Theeran Adhigaaram Ondru					8.3			Crime
Theeran Adhigaaram Ondru					8.3			Thriller
The King and I								8.2			Drama
The King and I								8.2			Romance
*/

-- TRYING THE ABOVE WITH MEDIAN_RATING > 8--

SELECT 
			TITLE, MEDIAN_RATING, GENRE
FROM 		MOVIE AS M
			INNER JOIN
			GENRE AS G
			ON G.MOVIE_ID = M.ID
			INNER JOIN
			RATINGS AS R
			ON M.ID = R.MOVIE_ID
WHERE 	
		MEDIAN_RATING > 8
AND 
		TITLE LIKE 'THE%'
ORDER BY MEDIAN_RATING DESC;

-- AVG RATING ABOVE 8 RETURNED 15 ROWS, HOWEVER MEDIAN RATINGS ABOVE 8 RETURNED 105 ROWS --

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, sum(total_votes) as total_votes
FROM movie AS m
	INNER JOIN ratings as r ON m.id=r.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country;
-- GERMAN MOVIES GET MORE VOTES THEN ITALIAN

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;
-- HEIGHT , DATE OF BIRTH, KNOWN FOR MOVIES HAVE NULL VALUES


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|Anthony Russo	|		3			|
|Soubin Shahir	|		3			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_3_genres AS
(
SELECT     genre,
Count(m.id)  AS movie_count ,
Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
FROM       movie  AS m
INNER JOIN genre  AS g
ON         g.movie_id = m.id
INNER JOIN ratings AS r
ON         r.movie_id = m.id
WHERE      avg_rating > 8
GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Mamooty	|		8			|
|Mohanlal   |		5			|
+---------------+-------------------+ */
-- Type your code below:

SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|		vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| Marvel Studios		|		2656967			|		1  		  |
|Twentieth Century Fox	|		2411163			|		2		  |
|Warner Bros			|		2396057			|		3		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT PRODUCTION_COMPANY, SUM(TOTAL_VOTES) AS VOTE_COUNT, 
Rank() OVER(ORDER BY SUM(TOTAL_VOTES) DESC) AS PROD_COMP_RANK
FROM
MOVIE AS M
INNER JOIN
RATINGS AS R
ON M.ID = R.MOVIE_ID
GROUP BY PRODUCTION_COMPANY LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|Vijay Sethupathi		5					5					8.42					1       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH Actor_Ranks AS (
  SELECT name AS actor_name,
  COUNT(TOTAL_VOTES) AS TOTAL_VOTES, 
         COUNT(m.id) AS movie_count,
         ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
         RANK() OVER (ORDER BY SUM(avg_rating * total_votes) / SUM(total_votes) DESC) AS actor_rank
  FROM movie AS m
  INNER JOIN ratings AS r ON m.id = r.movie_id
  INNER JOIN role_mapping AS rm ON m.id = rm.movie_id
  INNER JOIN names AS nm ON rm.name_id = nm.id
  WHERE category = 'actor' AND country = 'india'
  GROUP BY name
  HAVING COUNT(m.id) >= 5
)
SELECT *
FROM Actor_Ranks
LIMIT 1;

-- Vijay Sethupathi is the answer

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|Taapsee Pannu			18061				3				7.74					1
Kriti Sanon				21967				3				7.05					2
Divya Dutta				8579				3				6.88					3
Shraddha Kapoor			26779				3				6.63					4
Kriti Kharbanda			2549				3				4.80					5
	*/
-- Type your code below:

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      sum(total_votes),
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM movie  AS m
           INNER JOIN ratings AS r
           ON m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON   m.id = rm.movie_id
           INNER JOIN names AS n
           ON   rm.name_id = n.id
           WHERE   category = 'ACTRESS'
           AND    country = "INDIA"
           AND  languages LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     movie_count>=3 )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
WITH thriller_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON R.movie_id = M.id
                INNER JOIN genre AS G using(movie_id)
         WHERE  genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|Action					112.88			112.88					112.880000
Adventure				101.87			214.75					107.375000
Comedy					102.62			317.37					105.790000
Crime					107.05			424.42					106.105000
Drama					106.77			531.19					106.238000
Family					100.97			632.16					105.360000
Fantasy					105.14			737.30					105.328571
Horror					92.72			830.02					103.752500
Mystery					101.80			931.82					103.535556
Others					100.16			1031.98					103.198000
Romance					109.53			1141.51					103.773636
Sci-Fi					97.94			1239.45					102.415455
Thriller				101.58			1341.03					102.389091

*/
-- Type your code below:

SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|
      |
genre	year	movie_name	worlwide_gross_income	movie_rank
Action	2017	Star Wars: Episode VIII - The Last Jedi	1332539889	1
Action	2017	The Fate of the Furious	1236005118	2
Comedy	2017	Despicable Me 3	1034799409	3
Action	2017	Jumanji: Welcome to the Jungle	962102237	4
Comedy	2017	Jumanji: Welcome to the Jungle	962102237	4
Action	2017	Spider-Man: Homecoming	880166924	5
Action	2018	Avengers: Infinity War	2048359754	1
Action	2018	Black Panther	1346913161	2
Action	2018	Jurassic World: Fallen Kingdom	1308467944	3
Action	2018	The Villain	1300000000	4
Action	2018	Incredibles 2	1242805359	5
Drama	2019	Avengers: Endgame	2797800564	1
Action	2019	Avengers: Endgame	2797800564	1
Drama	2019	The Lion King	1655156910	2
Action	2019	Spider-Man: Far from Home	1131845802	3
Action	2019	Captain Marvel	1128274794	4
Comedy	2019	Toy Story 4	1073168585	5


*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genres AS (
  SELECT
    genre,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
  FROM movie AS m
  INNER JOIN genre AS g ON g.movie_id = m.id
  INNER JOIN ratings AS r ON r.movie_id = m.id
  WHERE avg_rating > 8
  GROUP BY genre
  LIMIT 3
),

movie_summary AS (
  SELECT
    g.genre,
    m.year,
    m.title AS movie_name,
    CAST(
      REPLACE(REPLACE(IFNULL(m.worlwide_gross_income, '0'), 'INR', ''), '$', '') AS DECIMAL(10)
    ) AS worlwide_gross_income,
    DENSE_RANK() OVER (PARTITION BY m.year ORDER BY CAST(REPLACE(REPLACE(IFNULL(m.worlwide_gross_income, '0'), 'INR', ''), '$', '') AS DECIMAL(10)) DESC) AS movie_rank
  FROM movie AS m
  INNER JOIN genre AS g ON m.id = g.movie_id
  INNER JOIN top_genres tg ON g.genre = tg.genre
)

SELECT *
FROM movie_summary
WHERE movie_rank <= 5
ORDER BY year;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| Star Cinema			7						1
Twentieth Century Fox	4						2 				 |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
		COUNT(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|Sangeetha Bhat		1010				1					9.60000					1
Fatmire Sahiti		3932				1					9.40000					2
Adriana Matoshi		3932				1					9.40000					2      |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT
  actress_name,
  total_votes,
  movie_count,
  actress_avg_rating,
  DENSE_RANK() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM (
  SELECT
    name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    AVG(r.avg_rating) AS actress_avg_rating
  FROM names AS n
  INNER JOIN role_mapping AS rm ON n.id = rm.name_id
  INNER JOIN ratings AS r ON r.movie_id = rm.movie_id
  INNER JOIN genre AS g ON r.movie_id = g.movie_id
  WHERE category = 'actress' AND r.avg_rating > 8 AND g.genre = 'drama'
  GROUP BY name
) AS subquery
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm2096009	Andrew Jones	5	191	3.02	1989	2.7	3.2	432	1
nm1777967	A.L. Vijay	5	177	5.42	1754	3.7	6.9	613	2
nm6356309	Özgür Bakar	4	112	3.75	1092	3.1	4.9	374	3
nm2691863	Justin Price	4	315	4.50	5343	3.0	5.8	346	4
nm0814469	Sion Sono	4	331	6.03	2972	5.4	6.4	502	5
nm0831321	Chris Stokes	4	198	4.33	3664	4.0	4.6	352	6
nm0425364	Jesse V. Johnson	4	299	5.45	14778	4.2	6.5	383	7
nm0001752	Steven Soderbergh	4	254	6.48	171684	6.2	7.0	401	8
nm0515005	Sam Liu	4	260	6.23	28557	5.8	6.7	312	9------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_date_info AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 final_result AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM final_result
 LIMIT 9;





