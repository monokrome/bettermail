CREATE TABLE domain (
        id serial UNIQUE NOT NULL,
        active boolean NOT NULL DEFAULT true,

        name text UNIQUE NOT NULL
);


CREATE TABLE virtual_aliases (
        id serial UNIQUE NOT NULL,
        active boolean NOT NULL DEFAULT true,

        domain int NOT NULL,
        name text NOT NULL,

        forward_address text NOT NULL,

        UNIQUE (domain, name),
        FOREIGN KEY (domain) REFERENCES domain (id)
);
