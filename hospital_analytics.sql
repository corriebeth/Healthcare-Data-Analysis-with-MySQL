-- OBJECTIVE 1 : PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?

SELECT YEAR(start), QUARTER(start), COUNT(DISTINCT patient)
FROM hospital_db.encounters
GROUP BY YEAR(start), QUARTER(start)
ORDER BY YEAR(start), QUARTER(start);

-- b. How many patients were readmitted within 30 days of a previous encounter?
    
SELECT COUNT(DISTINCT e2.id) AS readmission_within_30_days
FROM hospital_db.encounters e1
JOIN hospital_db.encounters e2
  ON e1.PATIENT = e2.PATIENT
  AND e2.START >=  e1.STOP
  AND TIMESTAMPDIFF(DAY, e1.STOP, e2.START) <= 30;

-- c. Which patients had the most readmissions?

SELECT patient, COUNT(patient) AS num_of_admissions
FROM hospital_db.encounters
GROUP BY patient
ORDER BY COUNT(patient) DESC;

-- Objective 2: Insurance Coverage

-- a. What percentage of all encounters were billed to each healthcare payer?

SELECT p.name AS payer,
       ROUND(COUNT(e.id) / (SELECT COUNT(id) FROM hospital_db.encounters) * 100, 2) AS percentage
FROM hospital_db.encounters e
JOIN hospital_db.payers p ON e.payer = p.id
GROUP BY p.name
ORDER BY percentage DESC;

-- b. What was the total percentage of coverage for each health insurance?

SELECT p.name AS payer, ROUND(SUM(payer_coverage)/SUM(total_claim_cost) * 100,2) AS percent_of_coverage
FROM hospital_db.encounters e
JOIN hospital_db.payers p ON p.id = e.payer
GROUP BY p.name
ORDER BY percent_of_coverage DESC;

-- c. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?

SELECT COUNT(payer_coverage) AS count_zero_coverage, 
	COUNT(payer_coverage) / (SELECT COUNT(id) FROM hospital_db.encounters) * 100 AS percent_of_encounters
FROM hospital_db.encounters
WHERE payer_coverage = 0;

-- OBJECTIVE 3: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?
SELECT YEAR(start) AS year, COUNT(Id) AS total_encounters
FROM hospital_db.encounters
GROUP BY year
ORDER BY year;

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?

SELECT YEAR(start) AS year, 
	encounterclass, 
    ROUND(COUNT(id)/ SUM(COUNT(id)) OVER (PARTITION BY YEAR(start)) * 100,2) AS percentage
FROM hospital_db.encounters
GROUP BY year, encounterclass
ORDER BY year, encounterclass;

-- c. What percentage of encounters were over 24 hours versus under 24 hours?

SELECT 'Under 24 Hours' AS duration_category,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hospital_db.encounters),2) AS percentage
FROM hospital_db.encounters
WHERE TIMESTAMPDIFF(HOUR, start, stop) <= 24

UNION ALL

SELECT 'Over 24 Hours' AS duration_category,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hospital_db.encounters),2) AS percentage
FROM hospital_db.encounters
WHERE TIMESTAMPDIFF(HOUR, start, stop) > 24;


-- OBJECTIVE 4: COST INSIGHTS

-- a. What are the top 10 most frequent procedures performed and the average base cost for each?

SELECT DESCRIPTION, COUNT(DESCRIPTION) AS procedure_count, ROUND(AVG(base_cost),2) AS AVG_base_cost
FROM hospital_db.procedures
GROUP BY DESCRIPTION
ORDER BY COUNT(DESCRIPTION) DESC
LIMIT 10;

-- b. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

SELECT description, ROUND(AVG(base_cost),2) AS AVG_base_cost, COUNT(description) procedure_count
FROM hospital_db.procedures
GROUP BY description
ORDER BY AVG_base_cost DESC
LIMIT 10;

-- c. What is the average total claim cost for encounters, broken down by payer?

SELECT p.name, ROUND(AVG(e.total_claim_cost),2) AS AVG_total_claim_cost
FROM hospital_db.encounters e JOIN hospital_db.payers p ON e.payer = p.id
GROUP BY e.payer
ORDER BY AVG_total_claim_cost DESC;
