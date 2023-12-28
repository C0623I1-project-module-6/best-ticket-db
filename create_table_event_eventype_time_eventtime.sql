
CREATE TABLE EVENT_TYPE (
    id BINARY(36) PRIMARY KEY ,
    name VARCHAR(255) NOT NULL
);


CREATE TABLE EVENT (
    id BINARY(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    description TEXT,
    image TEXT,
    duration VARCHAR(255) NOT NULL ,
    event_type_id BINARY(36),
    FOREIGN KEY (event_type_id) REFERENCES EVENT_TYPE(id)
);


CREATE TABLE TIME (
    id BINARY(36) PRIMARY KEY,
    time DATETIME NOT NULL
);

CREATE TABLE EVENT_TIME (
    event_id BINARY(36),
    time_id BINARY(36),
    PRIMARY KEY (event_id, time_id),
    FOREIGN KEY (event_id) REFERENCES EVENT(id),
    FOREIGN KEY (time_id) REFERENCES TIME(id)
);

