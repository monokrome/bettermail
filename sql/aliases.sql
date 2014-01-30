CREATE TABLE aliases (
        id serial UNIQUE NOT NULL,
        active boolean NOT NULL DEFAULT true,

        name text UNIQUE NOT NULL,

        forward_address text NOT NULL
);
