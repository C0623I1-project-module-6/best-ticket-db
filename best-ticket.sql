#
# drop database best_ticket;
create database best_ticket;
use best_ticket;


# V1_00__Create_Table
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

# V1_01__Alter_Table_Users
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

# V1_02__Alter_Table_Customers
ALTER TABLE customer
    ADD COLUMN user_customer_id binary(36),
    ADD CONSTRAINT user_customer_id FOREIGN KEY (user_customer_id) REFERENCES users (id);

RENAME TABLE customer TO customers;

# V1_03__Alter_Table_Organizers
ALTER TABLE organizer
    ADD COLUMN user_id binary(36),
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES users (id);

RENAME TABLE organizer TO organizers;

# V1_04__Alter_Table_Contracts
ALTER TABLE contracts
    ADD COLUMN customer_id  binary(36),
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES customers (id),
    ADD COLUMN organizer_id binary(36),
    ADD CONSTRAINT organizer_id FOREIGN KEY (organizer_id) REFERENCES organizers (id);

# V1_05__Drop_Role_Id
ALTER TABLE users
    DROP FOREIGN KEY role_id,
    DROP COLUMN role_id;

# V1_06__Change_Column_Full_name_Id_card
ALTER TABLE organizers
    CHANGE COLUMN full_name enterprise_name VARCHAR(50),
    CHANGE COLUMN id_card tax_code VARCHAR(50);

# V1_07__Create_Table_Events
CREATE TABLE event_types
(
    id   BINARY(36) PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE events
(
    id            BINARY(36) PRIMARY KEY,
    name          VARCHAR(50)  NOT NULL,
    address       VARCHAR(255) NOT NULL,
    event_type_id BINARY(36),
    FOREIGN KEY (event_type_id) REFERENCES event_types (id)
);

CREATE TABLE times
(
    id   BINARY(36) PRIMARY KEY,
    time datetime
);

CREATE TABLE event_times
(
    event_id BINARY(36),
    time_id  BINARY(36),
    PRIMARY KEY (event_id, time_id),
    FOREIGN KEY (event_id) REFERENCES events (id),
    FOREIGN KEY (time_id) REFERENCES times (id)
);

# V1_08__Add_Column_Is_delete
ALTER TABLE bank_accounts
    ADD COLUMN is_delete bit default 0;
ALTER TABLE contract_details
    ADD COLUMN is_delete bit default 0;
ALTER TABLE contracts
    ADD COLUMN is_delete bit default 0;
ALTER TABLE customers
    ADD COLUMN is_delete bit default 0;
ALTER TABLE event_times
    ADD COLUMN is_delete bit default 0;
ALTER TABLE event_types
    ADD COLUMN is_delete bit default 0;
ALTER TABLE events
    ADD COLUMN is_delete bit default 0;
ALTER TABLE organizers
    ADD COLUMN is_delete bit default 0;
ALTER TABLE roles
    ADD COLUMN is_delete bit default 0;
ALTER TABLE ticket_types
    ADD COLUMN is_delete bit default 0;
ALTER TABLE tickets
    ADD COLUMN is_delete bit default 0;
ALTER TABLE times
    ADD COLUMN is_delete bit default 0;
ALTER TABLE user_roles
    ADD COLUMN is_delete bit default 0;
ALTER TABLE users
    ADD COLUMN is_delete bit default 0;

# V1_09__Create_Table_Individuals
CREATE TABLE individuals
(
    id                  BINARY(36) PRIMARY KEY,
    name                VARCHAR(50),
    id_card             VARCHAR(50),
    phone_number        VARCHAR(15),
    email               VARCHAR(255),
    is_delete           BIT DEFAULT 0,
    user_individuals_id BINARY(36),
    FOREIGN KEY (user_individuals_id) REFERENCES users (id)
);

# V1_10__Change_Datatypes_Column_Id
SET foreign_key_checks = 0;
ALTER TABLE bank_accounts
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN user_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE contract_details
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN contract_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE contracts
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN customer_id BINARY(16),
    MODIFY COLUMN organizer_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE customers
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN user_customer_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE event_times
    MODIFY COLUMN event_id BINARY(16),
    MODIFY COLUMN time_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE events
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN event_type_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE individuals
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN user_individuals_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE event_types
    MODIFY COLUMN id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE organizers
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN user_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE roles
    MODIFY COLUMN id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE ticket_types
    MODIFY COLUMN id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE tickets
    MODIFY COLUMN id BINARY(16),
    MODIFY COLUMN ticket_type_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE times
    MODIFY COLUMN id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE user_roles
    MODIFY COLUMN user_id BINARY(16),
    MODIFY COLUMN role_id BINARY(16);
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
ALTER TABLE users
    MODIFY COLUMN id BINARY(16);
SET foreign_key_checks = 1;

RENAME TABLE organizers TO enterprises;

# V1_11__Alter_Table_Contracts
ALTER TABLE contracts
    ADD COLUMN individual_id BINARY(16),
    ADD CONSTRAINT individual_id FOREIGN KEY (individual_id) REFERENCES individuals (id);
ALTER TABLE contracts
    CHANGE COLUMN organizer_id enterprise_id BINARY(16);

# V1_12__Add_Column_In_Users
ALTER TABLE users
    ADD COLUMN phone_number varchar(15)  NOT NULL UNIQUE,
    ADD COLUMN email        varchar(255) NOT NULL UNIQUE;

# V1_13__Drop_Column_In_Customers
ALTER TABLE customers
    DROP COLUMN phone_number,
    DROP COLUMN email;

# V1_14__Drop_Column_Users
ALTER TABLE users
    DROP COLUMN username;

# V1_071__Alter_Table_Event
ALTER TABLE events
    ADD COLUMN description TEXT,
    ADD COLUMN image       TEXT,
    ADD COLUMN duration    VARCHAR(255),
    ADD COLUMN is_deleted  BOOLEAN;

# V2_00__Alter_Table_All
ALTER TABLE contracts
    DROP FOREIGN KEY individual_id,
    DROP COLUMN individual_id;
ALTER TABLE contracts
    DROP FOREIGN KEY organizer_id,
    DROP COLUMN enterprise_id;

DROP TABLE individuals;
DROP TABLE enterprises;

CREATE TABLE IF NOT EXISTS organizer_types
(
    id        BINARY(16),
    name      VARCHAR(50),
    is_delete bit default 0
);

CREATE INDEX index_organizer_type_id ON organizer_types (id);

CREATE TABLE IF NOT EXISTS organizers
(
    id                BINARY(16),
    name              VARCHAR(50)  NOT NULL,
    phone_number      VARCHAR(50)  NOT NULL UNIQUE,
    email             VARCHAR(255) NOT NULL UNIQUE,
    id_card           VARCHAR(50) UNIQUE,
    tax_code          VARCHAR(50) UNIQUE,
    organizer_type_id BINARY(16),
    user_id           BINARY(16) UNIQUE,
    is_delete         bit default 0,
    FOREIGN KEY (organizer_type_id) REFERENCES organizer_types (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE INDEX index_organizer_id ON organizers (id);

ALTER TABLE contracts
    ADD COLUMN organizer_id BINARY(16),
    ADD CONSTRAINT FOREIGN KEY (organizer_id) REFERENCES organizers (id);

CREATE INDEX index_event_id ON events (id);
ALTER TABLE contract_details
    ADD COLUMN event_id BINARY(16),
    ADD CONSTRAINT FOREIGN KEY (event_id) REFERENCES events (id);

ALTER TABLE customers
    DROP FOREIGN KEY user_customer_id,
    DROP COLUMN user_customer_id;

ALTER TABLE customers
    ADD COLUMN user_id BINARY(16) UNIQUE,
    ADD CONSTRAINT FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE customers
    MODIFY date_of_birth VARCHAR(20);
