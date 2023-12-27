# drop database best_ticket;
create database best_ticket;
use best_ticket;

create table users
(
    id            binary(36) primary key,
    full_name     varchar(50)  not null,
    gender        varchar(15),
    id_card       varchar(50) not null unique ,
    date_of_birth varchar(15),
    phone_number  varchar(15)  not null unique,
    email         varchar(255) not null unique,
    business_type varchar(50),
    wallet varchar(255)
);

create table roles
(
    id   binary(36) primary key,
    name varchar(50)
);

create table user_roles
(
    user_id binary(36),
    role_id binary(36),
    primary key (user_id, role_id),
    foreign key (user_id) references users (id),
    foreign key (role_id) references roles (id)
);

create table bank_accounts(
    id binary(36) primary key,
    account_name varchar(50),
    account_number varchar(20),
    bank_name varchar(100),
    branch varchar(100),
    user_id binary(36),
    foreign key (user_id)references users(id)
);


