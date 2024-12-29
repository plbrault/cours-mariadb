/******************************************
* Mise en place de la base de données     *
******************************************/

DROP DATABASE IF EXISTS librairie;

CREATE DATABASE librairie;

USE librairie;

CREATE TABLE editeur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE langue (
    code CHAR(2) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL UNIQUE -- La contrainte "UNIQUE" interdit d'avoir deux langues avec le même nom,
);

CREATE TABLE livre (
    isbn CHAR(13) PRIMARY KEY,
    titre VARCHAR(50) NOT NULL,
    id_editeur INT,
    date_parution DATE NOT NULL,
    description TEXT,
    code_langue CHAR(2),
    prix DECIMAL(5,2) UNSIGNED, -- Maximum de 5 chiffres dont 2 après la virgule
    FOREIGN KEY (id_editeur) REFERENCES editeur(id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY (code_langue) REFERENCES langue(code)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE auteur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL
);

CREATE TABLE auteur_livre (
    id_auteur INT NOT NULL,
    isbn_livre CHAR(13) NOT NULL,
    PRIMARY KEY (id_auteur, isbn_livre),
    FOREIGN KEY (id_auteur) REFERENCES auteur(id)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY (isbn_livre) REFERENCES livre(isbn)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

/************************************
Requêtes d'insertion de données ****/
/***********************************/

INSERT INTO editeur(nom) VALUES('Gallimard Jeunesse');
INSERT INTO editeur(nom) VALUES('Éditions First');
INSERT INTO editeur(nom) VALUES('Pearson');
INSERT INTO editeur(nom) VALUES('CA, Inc.');

INSERT INTO langue VALUES ('fr', 'Français'), ('en', 'Anglais'), ('es', 'Espagnol');

/*
 * Avant d'insérer des livres, il faut connaître les ID qui ont été générés pour leurs éditeurs.
 * Puisque notre base de données a été recréée à neuf au début du script, ces valeurs seront les suivantes:
 * 
 * 1 -> Gallimard Jeunesse
 * 2 -> Éditions First
 * 3 -> Pearson
 * 4 -> CA, Inc.
 */
INSERT INTO livre(isbn, titre, id_editeur, date_parution, description, code_langue, prix)
    VALUES(
        '0747532699',
        'Harry Potter à l''école des sorciers',
        1,
        '1998-10-09',
        CONCAT( -- Concaténer (coller ensemble) des chaînes de caractères
            'Orphelin vivant chez son oncle et sa tante qui ne l\'aiment guère, '
            'Harry découvre qu\'il est magicien. Il voit son existence bouleversée '
            'par l\'arrivée d''un géant, Hagrid, qui l\'emmène à l\'école pour sorciers de Poudlard.'
        ),
        'fr',
        16.95
    );

INSERT INTO livre(titre, isbn, date_parution)
    VALUES('Harry Potter et la Chambre des secrets', '0747538492', '1998-07-02');
    
INSERT INTO livre
    SET titre = 'WordPress pour les nuls',
        isbn = '9782412090121',
        date_parution = '2023-09-22',
        description = 'Des conseils pour créer et mettre à jour un site ou un blog à l''aide de WordPress.',
        id_editeur = 2,
        prix = 49.95;

INSERT INTO livre(isbn, titre, id_editeur, date_parution, code_langue, prix)
    VALUES  ('9782326002395', 'Réseaux, 6e édition', 3, '2022-04-29', 'fr', 59.00),
            ('9781430225478', 'Technical Support Essentials', 4, '2009-12-30', 'en', 36.48);
       
INSERT INTO auteur(nom, prenom)
    VALUES  ('Rowling', 'J.K.'),
            ('Sabin-Wilson', 'Lisa'),
            ('Tanenbaum', 'Andrew'),
            ('Feamster', 'Nick'),
            ('Wetherall', 'David J.'),
            ('Sanchez', 'Andrew'),
            ('Sleeth', 'Karen');
        
/*
 * Avant d'insérer des entrées dans auteur_livre, il faut connaître les ID qui ont été générés pour les auteurs.
 * Puisque notre base de données a été recréée à neuf au début du script, ces valeurs seront les suivantes:
 * 
 * 1 -> J.K. Rowling
 * 2 -> Lisa Sabin-Wilson
 * 3 -> Andrew Tanenbaum
 * 4 -> Nick Feamster
 * 5 -> David J. Weatherall
 * 6 -> Andrew Sanchez
 * 7 -> Karen Sleeth
 */
INSERT INTO auteur_livre(id_auteur, isbn_livre)
    VALUES  (1, '0747532699'),
            (1, '0747538492'),
            (2, '9782412090121'),
            (3, '9782326002395'),
            (4, '9782326002395'),
            (5, '9782326002395'),
            (6, '9781430225478'),
            (7, '9781430225478');
            
/***************************************
Requêtes de modification de données ****
/***************************************/

-- Changer le titre du livre "WordPress pour les nuls" pour "WordPress pour les nuls 6e édition"
UPDATE livre SET titre = 'WordPress pour les nuls 6e édition' WHERE isbn = '9782412090121';
        
-- Changer le nom de l'éditeur "Person" pour "Pearson Education France"
UPDATE editeur SET nom = 'Pearson Education France' WHERE nom = 'Pearson';

-- Donner la langue "Français" à tous les livres dont la langue est inconnue
UPDATE livre SET code_langue = 'fr' WHERE code_langue IS NULL;

-- Donner le prix 16.95, l'éditeur "Gallimard Jeunesse" ainsi qu'une description au livre "Harry Potter et la Chambre des secrets"
UPDATE livre
    SET id_editeur = 1,
        prix = 16.95,
        description = CONCAT(
            'Une rentrée fracassante en voiture volante, une étrange malédiction qui s\'abat sur les élèves, ',
            'cette deuxième année à l\'école des sorciers ne s\'annonce pas de tout repos ! ',
            'Entre les cours de potions magiques, les matches de Quidditch et les combats de mauvais sorts, ',
            'Harry et ses amis Ron et Hermione trouveront-ils le temps de percer le mystère de la Chambre des Secrets ?'
        )
    WHERE isbn = '0747538492';

-- Changer le prix de tous les livres de l'éditeur #4 pour 10$
UPDATE livre SET prix = 10 WHERE id_editeur = 4;

/***************************************
Requêtes de suppression de données   ****
/***************************************/

-- Supprimer la langue "Espagnol"
DELETE FROM langue WHERE code = 'es';

-- Supprimer les livres dont l'ISBN est 0747532699 ou 0747538492
DELETE FROM livre WHERE isbn = '0747532699' OR isbn = '0747538492';

-- Supprimer les livres en anglais qui coûtent moins de 20$
DELETE FROM livre WHERE code_langue = 'en' AND prix < 20;

        
