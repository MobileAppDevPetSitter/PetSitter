use pet_sitter;

DROP TABLE IF EXISTS user;
create table user (
    user_id int not NULL auto_increment,
    email varchar(129) not NULL,
    password varchar(50) not NULL,
    salt varchar(30) not NULL,
    verification_code varchar(5) not NULL,
    status varchar(10) not NULL
    primary key(user_id)
) character set 'utf8';

DROP TABLE IF EXISTS owner;
create table owner (
	owner_id int not NULL,
    user_id int not NULL,
    pet_id int not NULL
    primary key(pet_id, owner_id)
) character set 'utf8';

DROP TABLE IF EXISTS pet;
create table pet (
    pet_id int not NULL auto_increment,
    name varchar(129) not NULL,
    bio varchar(255),
    bathroom_instructions varchar(255), 
    exercise_instructions varchar(255)
    primary key(pet_id)
) character set 'utf8';

DROP TABLE IF EXISTS pet_sitting;
create table pet_sitting (
	pet_sitting_id int not NULL,
    sitter_id int not NULL,
    pet_id int not NULL,
    status varchar(10) not NULL,
    start_date date not NULL,
    end_date date not NULL, 
    primary key(sitter_id, pet_sitting_id)
) character set 'utf8';

DROP TABLE IF EXISTS activity;
create table activity (
	activity_id int not NULL,
    pet_sitting_id int not NULL,
    description varchar(255), not NULL,
    status varchar(10) not NULL,
    photo_path varchar(127),
    completion_date timestamp not NULL
    primary key(pet_sitting_id, activity_id)
) character set 'utf8';