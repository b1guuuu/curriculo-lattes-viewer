CREATE TABLE IF NOT EXISTS instituto (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL UNIQUE,
    acronimo VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS pesquisador (
    id INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    idInstituto INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (idInstituto) REFERENCES instituto(id)
);