# Database Design Lab Answers  

## Part 1  
Below are the questions and answers for Part 1 of the assignment:  

**1.) What tables should you build?**  

At present, I am leaning towards building 4 tables: courses, instructors, learning outcomes for each course, and course assignments. Depending on the database structure, I may add a 5th table for terms because courses are repeated for terms but with possibly different instructor assignments.   

**2.) For each table, what field(s) will you use for primary key?**  
- Courses: Primary key should be a course_id. For example, for "Practice and Application of Data Science", it would be **ds_6001**
- Instructors: Primary key should be an instructor_id. Assuming multiple instructors do not have the same name, this could simply just be a superkey of their first and last name.
- Learning_Outcomes: The primary key here can be a superkey of learning outcome number and course_id. We can call it LO_id.
- Course_Assignments: The primary key here will be a superkey of instructor_id and course_id. We can call it CA_id. Given that a key goal of the database is to house historical assignments of intructors, this table will contain many foreign keys.
- Terms (if needed): The primary key here will just be the semester term_id (i.e. **fall_2021**).

**3.) For each table, what foreign keys will you use?**   
- Courses: This table won't have any foreign keys. Just information on the course at a high-level and whether it is still active.  
- Instructors: This table won't have any foreign keys. Just instructor name and whether or not they are still active faculty at the school.
- Learning_Outcomes: This table will need a foreign key of course_id to indicate with which course the outcome is associated. It also may play a role in creating the superkey LO_id.
- Course_Assigments: As mentioned in the previous question, we need a few foreign keys here to track historical assignments. These include course_id and intructor_id. It is also becoming clearer now that we indeed do need the term table as the term_id will be important if a teacher has had multiple assignments across multiple semesters.
- Terms: This table won't have any foreign keys. Just a term_id and possibly the term names.

**4.) Learning outcomes, courses, and instructors need a flag to indicate if they are currently active or not. How will your database support this feature? In particular:**    

**If a course will be taught again, it will be flagged as active. If the course won’t be taught again, it will be flagged as inactive.  
It is important to track if an instructor is a current employee or not.  
Learning outcomes for a course can change. You’ll want to track if a learning outcome is currently active or not.**

This can be done by adding a field to each of the impacted tables. This field can be named "active", and can be a simple TRUE or FALSE value. Courses, Instructors, and Learning_Outcomes will each have a field called "acitive" to indicate whether the course, instructor, or learning outcome is currently active, respectively.    

As a side note: It may be helpful in the future to also indicate which term is the current one. It may also be helpful to build out a course_term_active table that indicates if a course was inactive one semester and active in another, although that can be done by simply searching the Course_Assignment table.   

**5.) Is there anything to normalize in the database, and if so, how will you normalize it? Recall the desire to eliminate redundancy.**   

- There is non-atomic data that will need to be addressed in the data. For example, if there are multiple instructors for a course, the Course_Assignments table will need each of them as a separate entry/assignment.
- Fields that are not keys need to be dependent on the primary key, meaning any fields in the table that are not dependent on the primary key should be foreign keys. This will be important for the Course_Assignments and Learning_Outcomes tables.

**6.) Are there indexes that you should build? Explain your reasoning.**  

There will likely be joins between the tables on the primary and foreign keys, so having indexes for these keys would serve well in merging queries. Likewise, we will likely be filtering data in these tables a lot, so having indexes on ID and active-status fields will be useful.  

**7.) Are there constraints to enforce? Explain your answer and strategy.**  
**For example, these actions should not be allowed:**  
**- Entering learning objectives for a course not offered by the School of Data Science**  
**- Assigning an invalid instructor to a course**   

- As stated above, every learning objective should be associated with an existing course. If this is not seen through, there
- Likewise, an instructor should exist in the Instructors table to be in the Courses_Assigned table.
- Foreign keys should match the correct primary key of another table.
- Primary keys are unique, otherwise the tables will have duplicate entries when searching for records. 
- When adding new courses/instructors/terms, we must abide by the same naming convention for the keys created. This is to ensure any repurposed queries are easier to update and run.

**8.) Draw and submit a Relational Model for your project. For an example, see Beginning Database Design Solutions page 115 Figure 5-28.**  

Below is a link to the current EDR for the project. There is also a PNG copy in the repo.  

https://dbdiagram.io/d/UVA-SDS-Online-MSDS-Program-Database-2021-66ad93668b4bb5230e1abc3e   

![ERD](https://github.com/vinylrishi/bws5dk_database_design_lab/blob/main/UVA%20SDS%20Online%20MSDS%20Program%20Database%202021.png)

**9.) Suppose you were asked if your database could also support the UVA SDS Residential MSDS Program. Explain any issues that might arise, changes to the database structure (schema), and new data that might be needed. Note you won’t actually need to support this use case for the project.**  

- Residential instructors will overlap with online ones within the same term in the same course, meaning we will need to distiguish the course_id's of online and residential courses.
- Similarly, a course that was originally residential only being added to the online program means that one or both course_id's will need to be adjusted.
- An alternative method for adapting to residential support would be to add a field in Courses, Course_Assignments, and Learning_Objectives that indicates the learning format of the course: residential or online.
- In the case where the residential and online teacher differ for a given course in a given term, it should not confuse any queries. This shouldn't occurr if any of the above methods are used to distinguish the residential and online courses.
- Timelines will differ between the cohorts, so learning objectives may differ as well. This shouldn't cause an issue if the Learning_Objectives table has a means to distinguish the course type (either through adjsuted course_id's, or an added learning format field).

  
## Part 2
- There is now a "data" folder in the repo that contains all the CSVs and the notebook that created them. The raw excel data was slighly adjusted manually to be more reaedable for pandas. The data frames imported from the sheets were slightly manipulated within the notebook before being exported as CSVs. 
- The final ERD based CSVs containing the 5 major tables descirbed in Part 1 were uploaded to Snowflake and queries to answer the 11 questions in Part 2.
- See here a link to the Snowflake SQL workbook: https://app.snowflake.com/adilksi/fqa59308/w2MhJpGrX8Sa#query.
- A copy of the SQL code (db_design.sql) is also added to the root of the repo.




