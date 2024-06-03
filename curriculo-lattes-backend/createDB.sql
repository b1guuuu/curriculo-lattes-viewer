CREATE TABLE IF NOT EXISTS instituto (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL UNIQUE,
    acronimo VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS pesquisador (
    id VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    nomeReferencia VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    idInstituto INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (idInstituto) REFERENCES instituto(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS trabalho (
    id INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    ano INT NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS autor_cadastrado (
    idPesquisador VARCHAR(255) NOT NULL,
    idTrabalho INT NOT NULL,
    ordem INT NOT NULL,
    FOREIGN KEY (idPesquisador) REFERENCES pesquisador(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (idTrabalho) REFERENCES trabalho(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (idPesquisador, idTrabalho, ordem)
);

CREATE TABLE IF NOT EXISTS autor_nao_cadastrado (
    idTrabalho INT NOT NULL,
    ordem INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    nomeReferencia VARCHAR(255) NOT NULL,
    FOREIGN KEY (idTrabalho) REFERENCES trabalho(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (idTrabalho, ordem)
);