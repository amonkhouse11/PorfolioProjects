SELECT *
FROM ProjectPortfolio..people;

--Number of hats going to each state
SELECT statessql.state_abbrev, people.shirt_or_hat, COUNT(people.shirt_or_hat) AS Amount_of_hats
FROM ProjectPortfolio..people
JOIN statessql ON people.state_code= statessql.state_abbrev
WHERE people.shirt_or_hat= 'hat'
GROUP BY statessql.state_abbrev, people.shirt_or_hat;

--How many members of each team are in each geograpic division
SELECT statessql.division, people.team, COUNT(people.team) AS Count_of_Members
FROM ProjectPortfolio..people
JOIN statessql ON people.state_code= statessql.state_abbrev
GROUP BY people.team, statessql.division;

---Sort by Max, Min and average quiz_points per state
SELECT state_code, MAX(quiz_points) AS Maxpoints, AVG(quiz_points) AS MeanPoints
FROM ProjectPortfolio..People
GROUP BY state_code
ORDER BY MeanPoints DESC;

--Updating Table
INSERT INTO ProjectPortfolio..people(first_name, last_name, quiz_points, team, city, state_code, shirt_or_hat)
VALUES
	('Walter', 'St.John', '93', 'Baffled Badgers', 'Buffalo', 'NY', 'Hat'),
	('Emerald', 'Chou', '92', 'Angry Ants', 'Topeka', 'KS', 'Shirt');
UPDATE ProjectPortfolio..people
SET shirt_or_hat= 'Shirt'
WHERE id_number=12;

SELECT * 
FROM ProjectPortfolio..people
WHERE first_name= 'Lois' AND last_name= 'Hart';

DELETE FROM ProjectPortfolio..people
WHERE first_name= 'Lois' AND last_name= 'Hart';




