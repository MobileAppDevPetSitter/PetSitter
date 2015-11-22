use crittersitter;

DROP TABLE IF EXISTS user;
create table user (
    user_id int not null auto_increment,
    email varchar(129) not null,
    password varchar(50) not null,
    salt varchar(30) not null,
    verification_code varchar(5) not null,
    status varchar(10) not null,
    primary key(user_id)
) character set 'utf8';

DROP TABLE IF EXISTS owner;
create table owner (
    owner_id int not null,
    user_id int not null,
    pet_id int not null,
    primary key(pet_id, owner_id)
) character set 'utf8';

DROP TABLE IF EXISTS pet;
create table pet (
    pet_id int not null auto_increment,
    name varchar(129) not null,
    bio varchar(255),
    bathroom_instructions varchar(255), 
    exercise_instructions varchar(255),
    primary key(pet_id)
) character set 'utf8';

DROP TABLE IF EXISTS pet_sitting;
create table pet_sitting (
    pet_sitting_id int not null,
    sitter_id int not null,
    pet_id int not null,
    status varchar(10) not null,
    start_date date not null,
    end_date date not null, 
    primary key(sitter_id, pet_sitting_id)
) character set 'utf8';

DROP TABLE IF EXISTS activity;
create table activity (
    activity_id int not null,
    pet_sitting_id int not null,
    description varchar(255) not null,
    status varchar(10) not null,
    photo_path varchar(127),
    completion_date timestamp not null,
    primary key(pet_sitting_id, activity_id)
) character set 'utf8';