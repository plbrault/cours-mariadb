DROP DATABASE IF EXISTS librairie;

CREATE DATABASE librairie;

USE librairie;

CREATE TABLE IF NOT EXISTS editeur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS livre (
    isbn CHAR(13) PRIMARY KEY,
    titre VARCHAR(50) NOT NULL,
    id_editeur INT,
    annee_publication CHAR(4) NOT NULL,
    description TEXT,
    CONSTRAINT fk_livre_editeur
        FOREIGN KEY (id_editeur) REFERENCES editeur(id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS pays (
    code CHAR(2) PRIMARY KEY,
    nom VARCHAR(50) NOT NULL    
);

CREATE TABLE IF NOT EXISTS auteur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    code_pays CHAR(2) NOT NULL,
    FOREIGN KEY (code_pays) REFERENCES pays(code)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS auteur_livre (
    id_auteur INT NOT NULL,
    isbn_livre CHAR(13) NOT NULL,
    PRIMARY KEY (id_auteur, isbn_livre),
    FOREIGN KEY (id_auteur) REFERENCES auteur(id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (isbn_livre) REFERENCES livre(isbn)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

ALTER TABLE livre
    ADD COLUMN langue VARCHAR(20);

ALTER TABLE livre
    DROP FOREIGN KEY fk_livre_editeur;

ALTER TABLE livre
    ADD FOREIGN KEY (id_editeur) REFERENCES editeur(id);

ALTER TABLE livre
    MODIFY COLUMN langue CHAR(2) NOT NULL DEFAULT 'FR';

ALTER TABLE livre 
    DROP COLUMN langue;
