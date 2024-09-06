-- Creating Tables --
CREATE TABLE pages (id BIGINT NOT NULL AUTO_INCREMENT,
team_name VARCHAR(50), year_played INT, wins INT, losses INT, ot_losses INT,
win_percentage FLOAT(5,2), goals_for INT, goals_against INT, PRIMARY KEY(id));


SELECT * FROM pages;

-- Teams --
SELECT DISTINCT team_name
FROM pages;

-- Teams That Played the Most Years --
SELECT team_name, COUNT(DISTINCT year_played) AS years_played
FROM pages
GROUP BY team_name
ORDER BY years_played DESC;

-- Team with most wins in each year --
SELECT p1.team_name, p1.wins, p1.year_played
FROM pages p1
INNER JOIN (
    SELECT year_played, MAX(wins) AS max_wins
    FROM pages
    GROUP BY year_played
) p2
ON p1.year_played = p2.year_played AND p1.wins = p2.max_wins;

-- Team with most losses in each year -- 
SELECT p1.team_name, p1.losses, p1.year_played
FROM pages p1
INNER JOIN (
    SELECT year_played, MAX(losses) AS max_losses
    FROM pages
    GROUP BY year_played
) p2
ON p1.year_played = p2.year_played AND p1.losses = p2.max_losses;

-- Total Wins, Losses, and OT Losses per Team Across All Years -- 
SELECT team_name, SUM(wins) AS total_wins, SUM(losses) AS total_losses, SUM(ot_losses) AS total_ot_losses
FROM pages
GROUP BY team_name
ORDER BY total_wins DESC;

-- Top 5 Teams with the Most Goals Scored in a Single Season -- 
SELECT team_name, goals_for, year_played
FROM pages
ORDER BY goals_for DESC
LIMIT 5;

-- Teams with the Best Goal Difference (Goals For - Goals Against) --
SELECT team_name, SUM(goals_for - goals_against) AS goal_difference
FROM pages
GROUP BY team_name
ORDER BY goal_difference DESC;

-- Teams with More Wins than Losses --
SELECT team_name, SUM(wins) AS total_wins, SUM(losses) AS total_losses
FROM pages
GROUP BY team_name
HAVING total_wins > total_losses;

-- Years with the Highest Total Goals Scored (All Teams Combined) -- 
SELECT year_played, SUM(goals_for) AS total_goals_scored
FROM pages
GROUP BY year_played
ORDER BY total_goals_scored DESC;

--  Average Goals Scored and Conceded by Each Team -- 
SELECT team_name, AVG(goals_for) AS avg_goals_for, AVG(goals_against) AS avg_goals_against
FROM pages
GROUP BY team_name;
 






