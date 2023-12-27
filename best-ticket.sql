#
# drop database best_ticket;
create database best_ticket;
use best_ticket;

create table users
(
    id            binary(36) primary key,
    full_name     varchar(50)  not null,
    gender        varchar(15),
    id_card       varchar(50)  not null unique,
    date_of_birth varchar(15),
    phone_number  varchar(15)  not null unique,
    email         varchar(255) not null unique,
    wallet        varchar(255)
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

create table bank_accounts
(
    id             binary(36) primary key,
    account_name   varchar(50),
    account_number varchar(20),
    bank_name      varchar(100),
    branch         varchar(100),
    user_id        binary(36),
    foreign key (user_id) references users (id)
);

CREATE TABLE ticket_types
(
    id     binary(36) PRIMARY KEY,
    `name` VARCHAR(20),
    price  FLOAT
);

CREATE TABLE tickets
(
    id             binary(36) PRIMARY KEY,
    ticket_code    VARCHAR(55) UNIQUE NOT NULL,
    seat           VARCHAR(10),
    `time`         DATETIME,
    location       VARCHAR(30),
    promotion      VARCHAR(5),
    barcode        VARCHAR(20),
    is_delete      varchar(10),
    ticket_type_id binary(36),
    FOREIGN KEY (ticket_type_id)
        REFERENCES ticket_types (id)
);

CREATE TABLE contracts
(
    id         BINARY(36) PRIMARY KEY,
    `date`     DATETIME       NOT NULL,
    amount     DECIMAL(10, 2) NOT NULL,
    `status`   VARCHAR(30)    NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE contract_details
(
    id           binary(36) PRIMARY KEY,
    contract_id  binary(36),
    ticket_id    binary(36),
    quantity     INT            NOT NULL,
    ticket_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (contract_id)
        REFERENCES contracts (id),
    FOREIGN KEY (ticket_id)
        REFERENCES tickets (id)
);

create table customer
(
    id            binary(36) primary key,
    full_name     varchar(50)  not null,
    gender        varchar(15),
    id_card       varchar(50)  not null unique,
    date_of_birth varchar(15),
    phone_number  varchar(15)  not null unique,
    email         varchar(255) not null unique
);

create table organizer
(
    id           binary(36) primary key,
    full_name    varchar(50)  not null,
    id_card      varchar(50)  not null unique,
    phone_number varchar(15)  not null unique,
    email        varchar(255) not null unique
);

ALTER TABLE users
    DROP COLUMN full_name,
    DROP COLUMN gender,
    DROP COLUMN date_of_birth,
    DROP COLUMN phone_number,
    DROP COLUMN email,
    DROP COLUMN wallet;

ALTER TABLE users
    ADD COLUMN username     varchar(50),
    ADD COLUMN password     varchar(50),
    ADD COLUMN role_id      binary(36),
    ADD COLUMN customer_id  binary(36),
    ADD COLUMN organizer_id binary(36)
;

ALTER TABLE users
    ADD CONSTRAINT role_id FOREIGN KEY (role_id) REFERENCES roles (id),
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES customer (id),
    ADD CONSTRAINT organizer_id FOREIGN KEY (organizer_id) REFERENCES organizer (id)
;

ALTER TABLE users
    DROP FOREIGN KEY customer_id,
    DROP FOREIGN KEY organizer_id,
    DROP COLUMN customer_id,
    DROP COLUMN organizer_id;

ALTER TABLE users
    DROP COLUMN id_card;

ALTER TABLE customer
ADD COLUMN user_customer_id binary(36),
    ADD CONSTRAINT  user_customer_id FOREIGN KEY (user_customer_id) REFERENCES users (id);

ALTER TABLE customer
    DROP FOREIGN KEY user_customer_id,
    DROP COLUMN user_customer_id;

ALTER TABLE organizer
ADD COLUMN user_id binary(36),
 ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES users (id);


RENAME TABLE customer TO customers;

RENAME TABLE organizer TO organizers;
# V2__Alter Table contracts
ALTER TABLE contracts
ADD COLUMN customer_id binary(36),
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES customers(id),
ADD COLUMN organizer_id binary(36),
ADD CONSTRAINT organizer_id FOREIGN KEY (organizer_id) REFERENCES organizers (id);

# V3__Alter Table users
ALTER TABLE users
DROP FOREIGN KEY role_id,
    DROP COLUMN role_id;

ALTER TABLE organizers
CHANGE COLUMN full_name enterprise_name VARCHAR(50),
CHANGE COLUMN id_card tax_code VARCHAR(50);



