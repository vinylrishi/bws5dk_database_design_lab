USE ROLE DS5111_DBT;
USE DATABASE "DS5111_SU24";
USE SCHEMA BWS5DK;

USE WAREHOUSE COMPUTE_WH;

-- 1.) Which courses are currently included (active) in the program? Include the course mnemonic and course name for each.
SELECT MNEMONIC, name
FROM DS5111_SU24.BWS5DK.BWS5DK_COURSES_ERD
WHERE ACTIVE = TRUE


-- 2.) Which courses were included in the program, but are no longer active? Include the course mnemonic and course name for each.
SELECT MNEMONIC, name
FROM DS5111_SU24.BWS5DK.BWS5DK_COURSES_ERD
WHERE ACTIVE = FALSE

-- 3.) Which instructors are not current employees?
SELECT *
FROM bws5dk_instructors_erd
WHERE ACTIVE = FALSE

-- 4.) For each course (active and inactive), how many learning outcomes are there?
SELECT MNEMONIC, COUNT(LEARNING_OUTCOME) AS COUNT_OF_OUTCOMES
FROM BWS5DK_LEARNING_OBJECTIVES_ERD
GROUP BY MNEMONIC

-- 5.) Are there any courses with no learning outcomes? If so, provide their mnemonics and names.
-- ds_biz_analytics has a typo in the Mnemonic for the Course table. Need to update table to fix this.
-- UPDATE BWS5DK_COURSES_ERD
-- SET mnemonic = 'ds_biz_analytics'
-- WHERE mnemonic = 'ds_biz_anaytics';

SELECT C.MNEMONIC, COUNT(LO.LEARNING_OUTCOME) AS COUNT_OF_OUTCOMES
FROM BWS5DK_COURSES_ERD C
LEFT JOIN BWS5DK_LEARNING_OBJECTIVES_ERD LO ON LO.MNEMONIC = C.MNEMONIC
GROUP BY C.mnemonic
HAVING COUNT_OF_OUTCOMES = 0

-- 6.) Which courses include SQL as a learning outcome? Include the learning outcome descriptions, course mnemonics, and course names in your solution.
SELECT C.MNEMONIC, C.name, LO.LEARNING_OUTCOME
FROM BWS5DK_COURSES_ERD C
LEFT JOIN BWS5DK_LEARNING_OBJECTIVES_ERD LO ON LO.MNEMONIC = C.MNEMONIC
WHERE LO.LEARNING_OUTCOME LIKE '%SQL%'


-- 7.) Who taught course ds5100 in Summer 2021?
SELECT INSTRUCTOR_ASSIGNMENTS
FROM BWS5DK_ASSIGNMENTS_ERD
WHERE TERM_ID = 'summer2021'

-- 8.) Which instructors taught in Fall 2021? Order their names alphabetically, making sure the names are unique.
SELECT DISTINCT INSTRUCTOR_ASSIGNMENTS
FROM BWS5DK_ASSIGNMENTS_ERD
WHERE TERM_ID = 'fall2021'
ORDER BY INSTRUCTOR_ASSIGNMENTS ASC

-- 9.) How many courses did each instructor teach in each term? Order your results by term and then instructor.
SELECT TERM_ID, INSTRUCTOR_ASSIGNMENTS AS INSTRUCTORS, COUNT(MNEMONIC) AS COURSE_COUNT 
FROM BWS5DK_ASSIGNMENTS_ERD
GROUP BY TERM_ID, INSTRUCTORS
ORDER BY TERM_ID ASC, INSTRUCTOR_ASSIGNMENTS ASC 

-- 10a.) Which courses had more than one instructor for the same term? Provide the mnemonic and term for each. Note this occurs in courses with multiple sections. 
SELECT MNEMONIC, TERM_ID, COUNT(INSTRUCTOR_ASSIGNMENTS) AS INSTRUCTOR_COUNT
FROM BWS5DK_ASSIGNMENTS_ERD
GROUP BY TERM_ID, MNEMONIC
HAVING iNSTRUCTOR_COUNT > 1
ORDER BY TERM_ID ASC, MNEMONIC ASC 

-- 10b.) For courses with multiple sections, provide the term, course mnemonic, and instructor name for each. Hint: You can use your result from 10a in a subquery or WITH clause.

WITH TENA AS (SELECT MNEMONIC, TERM_ID, COUNT(INSTRUCTOR_ASSIGNMENTS) AS INSTRUCTOR_COUNT
FROM BWS5DK_ASSIGNMENTS_ERD
GROUP BY TERM_ID, MNEMONIC
HAVING iNSTRUCTOR_COUNT > 1
ORDER BY TERM_ID ASC, MNEMONIC ASC)

SELECT A.TERM_ID, A.MNEMONIC, A.INSTRUCTOR_ASSIGNMENTS
FROM BWS5DK_ASSIGNMENTS_ERD A
INNER JOIN TENA ON TENA.MNEMONIC = A.MNEMONIC AND TENA.TERM_ID = A.TERM_ID
ORDER BY A.TERM_ID ASC, A.MNEMONIC ASC, A.INSTRUCTOR_ASSIGNMENTS ASC
