-- INITIALISATION DU SCRIPT
SHOW DATABASES;
DROP USER IF EXISTS "afpa"@"localhost";
DROP USER IF EXISTS "cda"@"localhost";
DROP DATABASE IF EXISTS immobilier;

-- EXERCICE 1 : CREATION DE LA BASE ET DES TABLES
-- CREATION BDD IMMOBILIER
CREATE DATABASE IF NOT EXISTS immobilier;
USE immobilier;

-- CREATION TABLE AGENCES 
DROP TABLE IF EXISTS agences;
CREATE TABLE IF NOT EXISTS agences (
	id INT(6) ZEROFILL PRIMARY KEY AUTO_INCREMENT,
	nom VARCHAR(255),
    adresse VARCHAR(255)
);

-- CREATION TABLE LOGEMENTS 
DROP TABLE IF EXISTS logements;
CREATE TABLE IF NOT EXISTS logements (
	id INT(5) ZEROFILL PRIMARY KEY AUTO_INCREMENT,
	type VARCHAR(255),
	ville VARCHAR(255),
	prix INT,
	superficie INT,
	categorie VARCHAR(255)
);

-- CREATION TABLE LOGEMENT_AGENCE 
DROP TABLE IF EXISTS logement_agence;
CREATE TABLE IF NOT EXISTS logement_agence (
	id INT PRIMARY KEY AUTO_INCREMENT,
	id_agence INT(6) ZEROFILL,
	id_logement INT(5) ZEROFILL,
    frais INT
);

-- CREATION TABLE PERSONNES 
DROP TABLE IF EXISTS personnes;
CREATE TABLE IF NOT EXISTS personnes (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nom varchar(255),
	prenom varchar(255),
	email varchar(255) UNIQUE
);

-- CREATION TABLE LOGEMENT_PERSONNE 
DROP TABLE IF EXISTS logement_personne;
CREATE TABLE IF NOT EXISTS logement_personne (
	id INT PRIMARY KEY AUTO_INCREMENT,
	id_personne INT,
    id_logement INT(5) ZEROFILL
);

-- CREATION TABLE DEMANDES 
DROP TABLE IF EXISTS demandes;
CREATE TABLE IF NOT EXISTS demandes (
	id INT PRIMARY KEY AUTO_INCREMENT,
	id_personne INT,
    type VARCHAR(255),
    ville VARCHAR(255),
    budget INT,
    superficie INT,
    categorie VARCHAR(255)
);

-- AJOUT DES FOREIGN KEYS
ALTER TABLE logement_agence ADD FOREIGN KEY (id_agence) REFERENCES agences(id);
ALTER TABLE logement_agence ADD FOREIGN KEY (id_logement) REFERENCES logements(id);
ALTER TABLE logement_personne ADD FOREIGN KEY (id_logement) REFERENCES logements(id);
ALTER TABLE logement_personne ADD FOREIGN KEY (id_personne) REFERENCES personnes(id);
ALTER TABLE demandes ADD FOREIGN KEY (id_personne) REFERENCES personnes(id);

-- EXERCICE 2 : CREATION DU TRIGGER POUR EMAIL
DELIMITER //
CREATE OR REPLACE TRIGGER checkEmail
	BEFORE INSERT ON personnes
	FOR EACH ROW
	BEGIN
		IF NEW.email NOT REGEXP "^[A-Za-z0-9][A-Za-z0-9\.\-\_]+[A-Za-z0-9][@][A-Za-z0-9][A-Za-z0-9\.\-\_]+[A-Za-z0-9]?[\.][A-Za-z0-9]{2,3}$" THEN
		-- ou plus simple : IF NEW.email NOT LIKE "%@%.%" THEN
			SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "L'adresse email n'a pas le bon format";
		END IF;
	END //
DELIMITER ;

-- EXERCICE 3 : PROCEDURES STOCKEES

-- >>> 2.1: PREPARATION DES PROCEDURES STOCKEES
-- >>> 2.2: HYDRATATION VIA UTILISATION DES PS
-- AJOUT D'AGENCES
DELIMITER //
CREATE OR REPLACE PROCEDURE newAgence(IN nomAgence VARCHAR(255), adresseAgence VARCHAR(255))
BEGIN
	INSERT INTO agences (nom, adresse) VALUES (nomAgence, adresseAgence);
END//
DELIMITER ;

call newAgence("logic-immo","www.logic-immo.com");
call newAgence("century21","rue Century");
call newAgence("laforet","rue La Forêt");
call newAgence("fnaim","rue Fnaim");
call newAgence("orpi","rue Orpi");
call newAgence("foncia","rue Foncia");
call newAgence("guy-hoquet","rue Guy-Hoquet");
call newAgence("seloger","www.seloger.com");
call newAgence("bouygues immobilier","www.bouygues-immobilier.net");

-- AJOUT DE LOGEMENTS
DELIMITER //
CREATE OR REPLACE PROCEDURE newLogement(IN typeLogement VARCHAR(255), villeLogement VARCHAR(255), prixLogement INT, superficieLogement INT, categorieLogement VARCHAR(255))
BEGIN
	INSERT INTO logements (type, ville, prix, superficie, categorie) VALUES (typeLogement, villeLogement, prixLogement, superficieLogement, categorieLogement);
END//
DELIMITER ;

call newLogement("appartement", "paris", 185000, 61, "vente");
call newLogement("appartement", "paris", 115000, 15, "vente");
call newLogement("maison", "paris", 510000, 130, "vente");
call newLogement("appartement", "bordeaux", 550, 17, "location");
call newLogement("appartement", "lyon", 420, 14, "location");
call newLogement("appartement", "paris", 160000, 40, "vente");
call newLogement("appartement", "paris", 670, 35, "location");
call newLogement("appartement", "lyon", 110000, 16, "vente");
call newLogement("appartement", "bordeaux", 161500, 33, "vente");
call newLogement("appartement", "paris", 202000, 90, "vente");

-- AJOUT DE PERSONNES
DELIMITER //
CREATE OR REPLACE PROCEDURE newPersonne(IN nomPersonne VARCHAR(255), prenomPersonne VARCHAR(255), emailPersonne VARCHAR(255))
BEGIN
	INSERT INTO personnes (nom, prenom, email) VALUES (nomPersonne, prenomPersonne, emailPersonne);
END//
DELIMITER ;

call newPersonne('Steffan', 'Linnie', 'lsteffan0@usda.gov');
call newPersonne('Delf', 'Cirstoforo', 'cdelf1@ycombinator.com');
call newPersonne('Braunton', 'Happy', 'hbraunton2@mozilla.org');
call newPersonne('Hutcheson', 'Cathlene', 'chutcheson3@netvibes.com');
call newPersonne('Ottam', 'Rachael', 'rottam4@taobao.com');
call newPersonne('Willshaw', 'Allison', 'awillshaw5@godaddy.com');
call newPersonne('Worner', 'Emelda', 'eworner6@blinklist.com');
call newPersonne('Douthwaite', 'Holt', 'hdouthwaite7@vinaora.com');
call newPersonne('Willder', 'Liesa', 'lwillder8@examiner.com');
call newPersonne('Casol', 'Glendon', 'gcasol9@time.com');
call newPersonne('Rowly', 'Clair', 'crowlya@gov.uk');
call newPersonne('Heindrick', 'Norrie', 'nheindrickb@theguardian.com');
call newPersonne('Lechelle', 'Martha', 'mlechellec@spiegel.de');
call newPersonne('Probets', 'Kane', 'kprobetsd@reference.com');
call newPersonne('Gorry', 'Kaitlin', 'kgorrye@un.org');
call newPersonne('Riatt', 'Marcella', 'mriattf@independent.co.uk');
call newPersonne('Paulin', 'Killian', 'kpauling@foxnews.com');
call newPersonne('Abad', 'Herbert', 'habadh@histats.com');
call newPersonne('Ilyasov', 'Lauralee', 'lilyasovi@telegraph.co.uk');
call newPersonne('Twitty', 'Hortensia', 'htwittyj@google.com');
call newPersonne('Davoren', 'Izak', 'idavorenk@cnet.com');
call newPersonne('Gillard', 'Wendall', 'wgillardl@friendfeed.com');
call newPersonne('Hustler', 'Beilul', 'bhustlerm@zimbio.com');
call newPersonne('Snelgrove', 'Nickey', 'nsnelgroven@jalbum.net');
call newPersonne('Dumbar', 'Webster', 'wdumbaro@amazon.co.jp');
call newPersonne('Brik', 'Gabi', 'gbrikp@timesonline.co.uk');
call newPersonne('Shambrook', 'Anette', 'ashambrookq@tripod.com');
call newPersonne('Aplin', 'Orlando', 'oaplinr@biglobe.ne.jp');
call newPersonne('Gaylard', 'Thedrick', 'tgaylards@alexa.com');
call newPersonne('Bonin', 'Zeke', 'zbonint@wikipedia.org');
call newPersonne('Burtt', 'Abba', 'aburttu@nature.com');
call newPersonne('Francescuccio', 'Zonda', 'zfrancescucciov@google.it');
call newPersonne('Rodear', 'Joletta', 'jrodearw@etsy.com');
call newPersonne('McCaughan', 'Artie', 'amccaughanx@blogger.com');
call newPersonne('O''Shesnan', 'Clayborn', 'coshesnany@jugem.jp');
call newPersonne('Mattheissen', 'Dana', 'dmattheissenz@imdb.com');
call newPersonne('Beades', 'Giffer', 'gbeades10@jalbum.net');
call newPersonne('Meneer', 'Billye', 'bmeneer11@berkeley.edu');
call newPersonne('Daniellot', 'Gasper', 'gdaniellot12@yolasite.com');
call newPersonne('Braisher', 'Pooh', 'pbraisher13@usa.gov');
call newPersonne('Aldwich', 'Emelita', 'ealdwich14@devhub.com');
call newPersonne('Horsey', 'Jonis', 'jhorsey15@foxnews.com');
call newPersonne('Spatari', 'Jaquelin', 'jspatari16@altervista.org');
call newPersonne('Devenport', 'Maurizio', 'mdevenport17@examiner.com');
call newPersonne('Hammer', 'Bernice', 'bhammer18@bloglines.com');
call newPersonne('Hammett', 'Shandra', 'shammett19@pen.io');
call newPersonne('Claringbold', 'Munmro', 'mclaringbold1a@utexas.edu');
call newPersonne('Boatman', 'Lindy', 'lboatman1b@businessweek.com');
call newPersonne('Smithers', 'Sheffie', 'ssmithers1c@instagram.com');
call newPersonne('Pavolillo', 'Marysa', 'mpavolillo1d@zimbio.com');

-- AJOUT DE DEMANDES
DELIMITER //
CREATE OR REPLACE PROCEDURE newDemande(IN personneDemande INT, typeDemande VARCHAR(255), villeDemande VARCHAR(255), budgetDemande INT, superficieDemande INT, categorie VARCHAR(255))
BEGIN
	INSERT INTO demandes (id_personne, type, ville, budget, superficie, categorie) VALUES (personneDemande, typeDemande, villeDemande, budgetDemande, superficieDemande, categorie);
END//
DELIMITER ;
call newDemande(1, "appartement", "paris", 530000, 120, "vente");
call newDemande(3, "appartement", "bordeaux", 120000, 18, "vente");
call newDemande(4, "appartement", "bordeaux", 145000, 21, "vente");
call newDemande(5, "appartement", "bordeaux", 152000, 26, "vente");
call newDemande(6, "appartement", "lyon", 200000, 55, "vente");
call newDemande(9, "appartement", "paris", 171000, 40, "vente");
call newDemande(13, "appartement", "paris", 163000, 25, "vente");
call newDemande(16, "appartement", "paris", 132000, 15, "vente");
call newDemande(19, "appartement", "paris", 350000, 80, "vente");
call newDemande(22, "appartement", "lyon", 600, 20, "location");
call newDemande(25, "appartement", "lyon", 188000, 65, "vente");
call newDemande(27, "appartement", "paris", 400, 15, "location");
call newDemande(28, "appartement", "paris", 330500, 100, "vente");
call newDemande(31, "appartement", "paris", 90000, 15, "vente");
call newDemande(32, "appartement", "lyon", 123800, 21, "vente");
call newDemande(35, "appartement", "lyon", 1200, 70, "vente");
call newDemande(37, "appartement", "lyon", 1500, 100, "vente");
call newDemande(43, "appartement", "paris", 600, 20, "location");
call newDemande(44, "appartement", "paris", 750, 30, "location");
call newDemande(45, "appartement", "bordeaux", 680, 30, "location");
call newDemande(46, "appartement", "bordeaux", 213000, 40, "vente");

-- AJOUT DE RELATIONS LOGEMENT_PERSONNE
DELIMITER //
CREATE OR REPLACE PROCEDURE newRelLogPer(IN personneRel INT, logementRel INT(5) ZEROFILL)
BEGIN
	INSERT INTO logement_personne (id_personne, id_logement) VALUES (personneRel, logementRel);
END//
DELIMITER ;

-- LES ACHETEURS-VENDEURS
call newRelLogPer(1,1);
call newRelLogPer(3,2);
call newRelLogPer(4,3);
call newRelLogPer(5,4);
call newRelLogPer(6,5);
call newRelLogPer(9,6);

-- LES VENDEURS SEULS
call newRelLogPer(2,7);
call newRelLogPer(7,8);
call newRelLogPer(8,9);
call newRelLogPer(10,10);


-- AJOUT DE RELATIONS LOGEMENT_AGENCE
DELIMITER //
CREATE OR REPLACE PROCEDURE newRelLogAgen(IN agenceRel INT(6) ZEROFILL, logementRel INT(5) ZEROFILL, fraisRel INT)
BEGIN
	INSERT INTO logement_agence (id_agence, id_logement, frais) VALUES (agenceRel, logementRel, fraisRel);
END//
DELIMITER ;

call newRelLogAgen(1,2,15000);
call newRelLogAgen(5,3,800);
call newRelLogAgen(8,1,10000);
call newRelLogAgen(8,4,10000);
call newRelLogAgen(2,5,7500);
call newRelLogAgen(3,6,400);
call newRelLogAgen(4,7,650);
call newRelLogAgen(6,8,18000);
call newRelLogAgen(7,9,25000);
call newRelLogAgen(9,10,300);

-- EXERCICE 4 : REQUETES SQL
-- >>> 4.1: Affichez le nom des agences
SELECT nom "Agences" FROM agences ORDER BY nom ASC;

-- >>> 4.2: Affichez le numéro de l’agence « Orpi »
SELECT id "Numero", nom "Agence" FROM agences WHERE nom LIKE "orpi";

-- >>> 4.3: Affichez le premier enregistrement de la table logement
SELECT * FROM logements WHERE id = 1;

-- >>> 4.4: Affichez le nombre de logements (Alias : Nombre de logements)
SELECT COUNT(*) FROM logements;

-- >>> 4.5: Affichez les logements à vendre à moins de 150 000 € dans l’ordre croissant des prix.
SELECT * FROM logements WHERE prix <= 150000 AND categorie = "vente" ORDER BY prix ASC;

-- >>> 4.6: Affichez le nombre de logements à la location (alias : nombre)
SELECT COUNT(*) FROM logements WHERE categorie = "location";

-- >>> 4.7: Affichez les villes différentes recherchées par les personnes demandeuses d'un logement
SELECT DISTINCT ville FROM demandes;

-- >>> 4.8: Affichez le nombre de biens à vendre par ville
SELECT ville, COUNT(ville) FROM logements GROUP BY ville ORDER BY COUNT(ville) DESC;

-- >>> 4.9: Quelles sont les id des logements destinés à la location ?
SELECT id FROM logements WHERE categorie = "location";

-- >>> 4.10: Quels sont les id des logements entre 20 et 30m² ?
SELECT id FROM logements WHERE superficie >= 20 AND superficie <= 30;
-- NE RETOURNE RIEN ! Version qui retourne un résultat : entre 20 et 50 m² :
SELECT id FROM logements WHERE superficie >= 20 AND superficie <= 50;

-- >>> 4.11: Quel est le prix vendeur (hors frais) du logement le moins cher à vendre ? (Alias : prix minimum)
SELECT MIN(prix) FROM logements WHERE categorie = "vente";

-- >>> 4.12: Dans quelles villes se trouve les maisons à vendre ?
SELECT DISTINCT ville FROM logements WHERE categorie = "vente";

-- >>> 4.13: L’agence Orpi souhaite diminuer les frais qu’elle applique sur le logement ayant l'id « 3 ». Passer les frais de ce logement de 800 à 730€
UPDATE logement_agence SET frais = 730 WHERE id_logement = 3 AND id_agence = 5;

-- >>> 4.14: Quels sont les logements gérés par l’agence « seloger »
SELECT nom "Agence", logements.* FROM logements JOIN logement_agence ON logements.id = id_logement JOIN agences ON agences.id = id_agence WHERE nom = "seloger";

-- >>> 4.15: Affichez le nombre de propriétaires dans la ville de Paris (Alias : Nombre)
SELECT ville "Ville", COUNT(nom) "Nombre de propriétaires" FROM logements JOIN logement_personne ON logements.id = id_logement JOIN personnes ON personnes.id = id_personne WHERE ville LIKE "paris";

-- >>> 4.16: Affichez les informations des trois premières personnes souhaitant acheter un logement
SELECT personnes.* FROM personnes JOIN demandes ON personnes.id = id_personne LIMIT 3;

-- >>> 4.17: Affichez les prénoms, email des personnes souhaitant accéder à un logement en location sur la ville de Paris

-- Version de la première ligne avec Prénom et Nom concaténés pour plus de lisibilité utilisateur
-- SELECT CONCAT(p.prenom, " ", p.nom) "Prénom Nom", p.email "Email"

-- Version de la question
SELECT p.prenom "Prénom", p.email "Email" FROM personnes p  JOIN demandes d ON p.id = d.id_personne AND d.categorie = "location" AND d.ville LIKE "paris";

-- >>> 4.18: Si l’ensemble des logements étaient vendus ou loués demain, quel serait le bénéfice généré grâce aux frais d’agence et pour chaque agence (Alias : bénéfice, classement : par ordre croissant des gains)
SELECT a.nom "Agence", SUM(frais) "Bénéfice total" FROM agences a JOIN logement_agence ON a.id = id_agence GROUP BY a.nom ORDER BY SUM(frais) ASC;

-- >>> 4.19: Affichez le prénom et la ville où se trouve le logement de chaque propriétaire
-- Version de la question
SELECT prenom, ville FROM personnes p JOIN logement_personne ON p.id = id_personne JOIN logements l ON l.id = id_logement ORDER BY id_personne;
-- Version avec Prénom et Nom concaténés pour plus de lisibilité utilisateur
SELECT CONCAT(prenom, " ", nom) "Propriétaire", ville "Localisation du bien" FROM personnes p JOIN logement_personne ON p.id = id_personne JOIN logements l ON l.id = id_logement ORDER BY id_personne;

-- >>> 4.20: Affichez le nombre de logements à la vente dans la ville de recherche de « hugo » (alias : nombre)
-- Hugo n'existant pas, il faut hydrater les bases PERSONNES et DEMANDES
call newPersonne("Cabret", "Hugo", "h.cabret@gmail.com");
call newDemande(51, "appartement", "paris", 300000, 20, "vente");
-- Réponse à la question :
SELECT COUNT(DISTINCT l.id)
FROM logements l
JOIN demandes d ON l.ville = d.ville
JOIN personnes p ON d.id_personne = p.id
AND l.ville = (SELECT ville FROM demandes WHERE id_personne IN (SELECT id FROM personnes WHERE prenom = "Hugo"))
AND l.categorie = "vente";

-- Pour aller plus loin : seuls les logements matchant tous les critères de recherche de Hugo :
-- Procedure Stockée pour récupérer l'ID de Hugo
DELIMITER //
CREATE OR REPLACE PROCEDURE getUserId(IN nomUser VARCHAR(255), OUT idResult INT)
BEGIN
	SELECT id INTO idResult FROM personnes WHERE prenom = nomUser;
END//
DELIMITER ;
CALL getUserId("Hugo", @idResult);
-- REQUETE SQL
SELECT COUNT(DISTINCT l.id)
FROM logements l
JOIN demandes d ON l.ville = d.ville
JOIN personnes p ON d.id_personne = p.id
AND l.ville = (SELECT ville FROM demandes WHERE id_personne IN (@idResult))
AND l.type = (SELECT type FROM demandes WHERE id_personne IN (@idResult))
AND l.prix <= (SELECT budget FROM demandes WHERE id_personne IN (@idResult))
AND l.superficie >= (SELECT superficie FROM demandes WHERE id_personne IN (@idResult))
AND l.categorie = (SELECT categorie FROM demandes WHERE id_personne IN (@idResult));

-- Pour aller encore plus loin :
-- Procedure Stockée pour récupérer les critères de la demande de Hugo :
DELIMITER //
CREATE OR REPLACE PROCEDURE getUserId2(IN nomUser VARCHAR(255), OUT typeResult VARCHAR(255), OUT villeResult VARCHAR(255), OUT prixResult INT, OUT superficieResult INT, OUT categorieResult VARCHAR(255))
BEGIN
    CALL getUserId(nomUser, @idResult);
	SELECT type INTO typeResult FROM demandes WHERE id_personne = @idResult;
	SELECT ville INTO villeResult FROM demandes WHERE id_personne = @idResult;
	SELECT budget INTO prixResult FROM demandes WHERE id_personne = @idResult;
	SELECT superficie into superficieResult FROM demandes WHERE id_personne = @idResult;
	SELECT categorie INTO categorieResult FROM demandes WHERE id_personne = @idResult;
END//
DELIMITER ;
CALL getUserId2("Hugo", @typeResult, @villeResult, @prixResult, @superficieResult, @categorieResult);
-- REQUETE SQL
SELECT COUNT(DISTINCT l.id)
FROM logements l
JOIN demandes d ON l.ville = d.ville
JOIN personnes p ON d.id_personne = p.id
AND l.ville = @villeResult
AND l.type = @typeResult
AND l.prix <= @prixResult
AND l.superficie >= @superficieResult
AND l.categorie = @categorieResult;

-- EXERCICE 5 : LES PRIVILEGES
-- >>> 5.1: Créer deux utilisateurs afpa et cda
CREATE USER "afpa"@"localhost";
CREATE USER "cda"@"localhost";
SELECT * FROM mysql.`user`;

-- >>> 5.2: Donner les droits d’afficher et d’ajouter des personnes et logements pour l’utilisateur afpa
GRANT SELECT, INSERT ON immobilier.personnes TO "afpa"@"localhost";
GRANT SELECT, INSERT ON immobilier.logements TO "afpa"@"localhost";
SHOW GRANTS FOR "afpa"@"localhost";

-- >>> 5.3: Donner les droits de supprimer des demandes d’achat et logements pour l’utilisateur cda
GRANT DELETE ON immobilier.demandes TO "cda"@"localhost";
GRANT DELETE ON immobilier.logements TO "cda"@"localhost";
SHOW GRANTS FOR "cda"@"localhost";