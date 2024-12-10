/* Module 1 Assessment - SQL Questions */

-- 1. Write a query to print out all the names of the tables from the 'm1' database
SHOW TABLES
;

-- 2. From the claims table, find the number of unique patients (based on PATIENTID) who have submitted a claim to the insurer
SELECT COUNT(DISTINCT PATIENTID) AS 'unique_patients'
FROM claims
;
      
-- 3. From the encounters table, find the total number of encounters that belong to the emergency encounter class
SELECT COUNT(ENCOUNTERCLASS)
FROM encounters
WHERE ENCOUNTERCLASS = 'emergency'
;

-- 4. From the providers table, find the name and gender of the providers whose speciality is in 'Internal Medicine' and practices in the city of Boston
SELECT NAME, GENDER
FROM providers
WHERE (SPECIALITY = 'Internal Medicine') AND (CITY = 'Boston')
;

-- 5. From the encounters table, find the maximum total claim cost (using appropriate alias like 'max_claim_cost') for each encounter class (using GROUP BY), and ordered by the maximum total claim cost in descending order.
SELECT ENCOUNTERCLASS, MAX(TOTAL_CLAIM_COST) AS max_claim_cost
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY max_claim_cost DESC
;

-- 6. Find the claim ID, provider ID of claims where the total claim cost is greater than or equal to $70000
-- columns: c.ID, p.ID
-- join: encounters e LEFT JOIN claims c ON e.ID = c.ENCOUNTERID LEFT JOIN providers p ON e.PROVIDER = p.ID
-- condition: WHERE e.TOTAL_CLAIM_COST >= 70000
SELECT c.ID AS 'claim_ID', e.PROVIDER AS 'provider_ID', e.TOTAL_CLAIM_COST
FROM encounters e 
LEFT JOIN claims c ON e.ID = c.ENCOUNTERID
-- LEFT JOIN providers p ON e.PROVIDER = p.ID
WHERE e.TOTAL_CLAIM_COST >= 70000
;

-- 7. Find the average total claim cost (rounded to 2 decimal places) for each encounter code and order the result by ascending average total claim cost
-- agg: ROUND(AVG(), 2) GROUP BY CODE
-- order: ORDER BY avg_claim_cost (default ascending)
SELECT CODE, ROUND(AVG(TOTAL_CLAIM_COST), 2) AS avg_claim_cost
FROM encounters 
GROUP BY CODE
ORDER BY avg_claim_cost
;

-- 8. Find the sum of total claim cost (rounded to nearest integer) for encounters in the classes of 'ambulatory' and 'emergency', and with start date in the year 2021
-- agg: ROUND(SUM(), 0)
-- conditions: ENCOUNTERCLASS IN ('ambulatory', 'emergency') AND YEAR(START) = 2021
SELECT ROUND(SUM(TOTAL_CLAIM_COST), 0) AS sum_claim_cost
FROM encounters
WHERE ENCOUNTERCLASS IN ('ambulatory', 'emergency') AND YEAR(START) = 2021
;

-- 9. Find the name and address of the providers, along with the encounter description, of encounters where the total claim cost is less than $60 and the description contains the text 'procedure'. (Hint: Use LIKE and %).
-- columns: p.name, p.address, e.description
-- join: encounters e LEFT JOIN providers p ON e.provider = p.id
-- condition: (e.total_claim_cost < 60) AND (e.description LIKE '%procedure%')
SELECT p.NAME, p.ADDRESS, e.DESCRIPTION
FROM encounters e 
LEFT JOIN providers p ON e.provider = p.id
WHERE (e.TOTAL_CLAIM_COST < 60) AND (e.DESCRIPTION LIKE '%procedure%')
;

-- 10. From the encounters table, find the average encounter duration (in hours, rounded to 1 decimal place) of each encounter class. (HINT: Find hour difference between START and STOP dates using HOUR(TIMEDIFF()) function).
-- agg: ROUND(AVG(encounter duration in hours), 1) GROUP BY ENCOUNTERCLASS
-- duration: HOUR(TIMEDIFF(STOP, START))
SELECT ENCOUNTERCLASS, ROUND(AVG(HOUR(TIMEDIFF(STOP, START))), 1) AS avg_encounter_hrs
FROM encounters
GROUP BY ENCOUNTERCLASS
;

-- 11. Find the organization name and corresponding average total claim cost of the top 3 organizations with the highest average total claim cost.
-- columns: o.name, avg(e.total_claim_cost), group by organization 
-- join: encounters e LEFT JOIN organizations o ON e.organization = o.ID
-- top 3: ORDER BY avg(total_claim_cost) DESC LIMIT 3
SELECT o.NAME, AVG(e.TOTAL_CLAIM_COST) AS avg_claim_cost
FROM encounters e
LEFT JOIN organizations o ON e.ORGANIZATION = o.ID
GROUP BY o.NAME
ORDER BY avg_claim_cost DESC
LIMIT 3
;

-- 12. Find the number of unique non-hispanic male patients with at least a claim where the total claim cost exceeds $11000 (HINT: Use COUNT DISTINCT of patient ID).
-- agg: COUNT(DISCTINCT )
-- conditions: p.RACE NOT hispanic AND p.GENDER = M AND e.total_claim_cost > 11000
SELECT COUNT(DISTINCT p.ID)
FROM encounters e 
LEFT JOIN patients p ON e.PATIENT = p.ID
WHERE p.ethnicity != 'hispanic' AND p.GENDER = 'M' AND e.total_claim_cost > 11000
;

-- 13. Find the encounter ID and total claim cost of encounters from the 'outpatient' class, along with a new column called 'claim_cost_level' that categorizes the total claim cost based on the following logic:
/* 
Very High: >$20000
High: >$15000 and <=$20000
Medium: >$5000 and <=$15000
Low: <=$5000
*/
-- CASE WHEN
-- columns: id, total_claim_cost, (CASE WHEN) AS claim_cost_level
-- condition: ENCOUNTERCLASS = 'outpatient'
SELECT ID, TOTAL_CLAIM_COST,
	(CASE
    WHEN TOTAL_CLAIM_COST > 20000 THEN 'Very High'
    WHEN TOTAL_CLAIM_COST BETWEEN 15001 AND 20000 THEN 'High'
    WHEN TOTAL_CLAIM_COST BETWEEN 5001 AND 15000 THEN 'Medium'
    WHEN TOTAL_CLAIM_COST <= 5000 THEN 'Low'
	END) AS claim_cost_level
FROM encounters
WHERE ENCOUNTERCLASS = 'outpatient'
;