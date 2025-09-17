--start project
drop table if exists BI;
create table BI (
fNAME varchar(100),
lNAME varchar(100),
Age	int,
gender varchar(100),
country varchar(100),
residence varchar(100),
entryEXAM int,
prevEducation varchar(100),
studyHOURS int,
Python int,
DB int
)

select * from BI

--1.Show all student names and ages.

SELECT
	CONCAT(FNAME, ' ', LNAME) AS FULL_NAME,
	AGE
FROM	BI

--update some wrong genders names
UPDATE BI
SET
	GENDER = CASE
		WHEN GENDER = 'M' THEN 'Male'
		WHEN GENDER = 'F' THEN 'Female'
		WHEN GENDER = 'male' THEN 'Male'
		ELSE GENDER
	END;
	
--2. Find all students who are Male.
select* from BI
SELECT
	CONCAT(FNAME, ' ', LNAME) AS NAME,
	GENDER
FROM
	BI
WHERE
	GENDER ='Male'

--3.List students who are from Kenya.
select * from BI
SELECT
	CONCAT(FNAME, ' ', LNAME) AS NAME,
	COUNTRY
FROM
	BI
WHERE
	COUNTRY ='Kenya'

--4.Display students with Age less than 25.
select * from BI
SELECT
	CONCAT(FNAME, ' ', LNAME) AS NAME,
	AGE
FROM
	BI
WHERE
	AGE < 25
 --5.Show the fNAME, lNAME, and studyHOURS of all students.
 select * from BI
SELECT
	CONCAT(FNAME, ' ', LNAME) AS NAME,
	FNAME,
	LNAME,
	STUDYHOURS FROM
	BI

--Medium
--6.Show the average Python score for each country, but only include countries with more than 3 students.
select * from BI 
select round(avg(python),2) as avg_python,
  country
 from BI
 group by country
 having count(*)>3

--7.Find the students who have the maximum DB score in each country.
select * from BI
select CONCAT(FNAME, ' ', LNAME) AS NAME,
max(db) as max_DB,
 country
from BI
group by country,name
order by max_db desc

SELECT fNAME, lNAME, country, DB
FROM BI as  s1
WHERE DB = (
    SELECT MAX(DB)
    FROM BI as s2
    WHERE s1.country = s2.country
);


--8.Display students with their Grade based on Python score:

/*≥ 85 → 'A'

70–84 → 'B'

50–69 → 'C'

Else → 'D'*/

select * from  BI
select CONCAT(FNAME, ' ', LNAME) AS NAME,
   python ,
   case 
     when python >=85 then 'A'
	 when python >= 70 then 'B'
	 when python >= 50 then 'C'
	 else 'D'
	end as Grade
from BI

--9.Find all students whose studyHOURS is greater than the average studyHOURS for their country.

select * from BI
select CONCAT(FNAME, ' ', LNAME) AS NAME, 
  studyhours,
  country
 from BI
 where studyhours > (
 select 
   avg(studyhours) as avg_study_hours
   from BI
 )
 group by 1,2,3

--10.Count how many students have the same prevEducation (Diploma, Bachelors, etc.), sorted in descending order.
select * from BI
select count(*),
preveducation
from BI
group by 2
order by 1 desc

--11.Use a window function to rank students by Python score within each country.
select * from BI
select CONCAT(FNAME, ' ', LNAME) AS NAME, 
       country,
	   python,
	   rank()over(partition by country order by python desc ) as rank_student
	from BI

--12.Write a query to show the top 2 students from each country based on DB score.
select * from BI

SELECT CONCAT(fname, ' ', lname) AS ranked_name,
       country,
       db
FROM (
    SELECT fname,
           lname,
           country,
           db,
           RANK() OVER (PARTITION BY country ORDER BY db DESC) AS rnk
    FROM bi
) AS ranked
WHERE rnk <=2;

--13.Find the student(s) who have the second highest studyHOUi overall.
select * from BI
select CONCAT(fname, ' ', lname) AS name,
       studyhours
	from BI
where studyhours =(
     select max(studyhours) as max_hours
	 from BI
where studyhours<( select max(studyhours) as max_hours
	 from BI)
)

--14.Using a CTE, calculate the average Python and DB scores, then list students who scored higher than both averages.
select *from BI

with avg_scores as (
 select 
 avg(python) as avg_python,
 avg(db) as avg_db
from BI
)
select CONCAT(b.fname, ' ', b.lname) AS name,
       b.python,
	   b.db
from BI as b
 cross join avg_scores as a
where b.python > a.avg_python
and b.db > a.avg_db

--15.Show the difference between each student’s studyHOUi and their country’s average studyHOUi (use window function).

SELECT CONCAT(fname, ' ', lname) AS name, country, studyHOURS,
       studyHOURS - round(AVG(studyHOURS) OVER (PARTITION BY country),2) AS diff_from_avg
FROM BI;

--16.Find the youngest student(s) in each residence type.
select * from BI
select CONCAT(b.fname, ' ',b.lname) AS name,
       b.residence,
	   b.age
from BI as b
where age =(
   select 
      min(age) as youngest_age
	  from BI as b2
	  where b.residence=b2.residence
)

--17.Use a subquery in SELECT to display each student’s Python score along with the average Python score of all students.
select CONCAT(fname, ' ',lname) AS name,
       python,
	   (
       select round (avg(python),2)
	   from BI
	   ) as avg_python
       
from BI
group by 1,2

--18.Show the percentage contribution of each student’s DB score to the total DB scores (use window function).
select * from BI
SELECT fNAME, lNAME, DB,
       (DB * 100.0 / SUM(DB) OVER()) AS db_percentage
FROM BI;

--19.List students who are in the top 10% of Python scores (use window function + NTILE or percentile).
SELECT fNAME, lNAME, Python
FROM (
    SELECT fNAME, lNAME, Python,
           NTILE(10) OVER (ORDER BY Python DESC) AS decile_rank
    FROM BI
) ranked
WHERE decile_rank = 1;

--20.10.Create a query that shows for each student:

--.fNAME, lNAME, Python, DB

--.A column that says 'Better in Python' if Python > DB, else 'Better in DB'.

SELECT fNAME, lNAME, Python, DB,
       CASE 
         WHEN Python > DB THEN 'Better in Python'
         ELSE 'Better in DB'
       END AS Comparison
FROM BI;












