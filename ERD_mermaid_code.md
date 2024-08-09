```mermaid
ERD
Table Courses {
  mnemonic_id varchar [primary key]
  course_name text
  active bool
}

Table Instructors {
  instructor_id varchar [primary key]
  name text
  active bool
}

Table Terms {
  term_id varchar [primary key]
  term varchar
  year int
  current bool
}


Table Course_Assignments {
  CA_id varchar [primary key]
  mnemonic_id varchar
  term_id varchar
  instructor_id varchar
}

Table Learning_Objectives {
  LO_id varchar [primary key]
  mnemonic_id varchar
  learning_objective text
  active bool 
}

Ref: Course_Assignments.mnemonic_id > Courses.mnemonic_id 

Ref: Course_Assignments.term_id > Terms.term_id 

Ref: Course_Assignments.instructor_id > Instructors.instructor_id 

Ref: Learning_Objectives.mnemonic_id > Courses.mnemonic_id
```
