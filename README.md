This project explores key healthcare insights using MySQL queries on a synthetic database of 75,500 records across four interconnected tables — Patients, Procedures, Encounters, and Payers. The goal was to analyze patient behavior, insurance coverage, encounter patterns, and cost insights. 


-- OBJECTIVE 1 : PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?
-- b. How many patients were readmitted within 30 days of a previous encounter?
-- c. Which patients had the most readmissions?

-- Objective 2: Insurance Coverage

-- a. What percentage of patients had what healthcare? 
-- b. What was the total percentage of coverage for each health insurance?
-- c. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?

-- OBJECTIVE 3: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?
-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
-- c. What percentage of encounters were over 24 hours versus under 24 hours?


-- OBJECTIVE 4: COST INSIGHTS

-- a. What are the top 10 most frequent procedures performed and the average base cost for each?
-- b. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
-- c.. What is the average total claim cost for encounters, broken down by payer?

