--Imported data into employee table from csv file using python script
-- Display all employee data
SELECT * FROM employee;

-- Display employee Education with age less than 24
SELECT Age,Education
FROM employee
WHERE Age<24;

-- Display employee count of each gender
SELECT Gender,COUNT(Gender) AS Total
FROM employee
GROUP BY Gender;

-- Display average age of employee of each city
SELECT City,AVG(Age) AS Average_Age
FROM employee
GROUP BY City;

-- Display employees joined each year in decending order
SELECT JoiningYear,COUNT(JoiningYear) AS No_of_Employee_joined
FROM employee
GROUP BY JoiningYear
Order BY No_of_Employee_joined DESC;

-- Display count of employee with joining year after 2015 and experience in current domain greater than equal to 4
SELECT Education,City,ExperienceInCurrentDomain,COUNT(Education) AS Total
FROM employee
GROUP BY Education
HAVING JoiningYear>2015 and ExperienceInCurrentDomain>=4;

-- Display employee data with Payment Tier above average
SELECT *
FROM employee
WHERE PaymentTier>(SELECT Avg(PaymentTier) FROM employee GROUP BY PaymentTier);
