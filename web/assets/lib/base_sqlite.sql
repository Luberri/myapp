PRAGMA foreign_keys = ON;

-- -----------------------------------------------------
-- 1. Nettoyage des tables existantes
-- -----------------------------------------------------
DROP TABLE IF EXISTS Etape;
DROP TABLE IF EXISTS Planning_Journee;
DROP TABLE IF EXISTS Personne;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Groupe;
DROP TABLE IF EXISTS Circuit;
DROP TABLE IF EXISTS Statut_Etape;

-- -----------------------------------------------------
-- 2. Création de la structure
-- -----------------------------------------------------

CREATE TABLE Circuit (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titre VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    nb_jours INTEGER NOT NULL
);

CREATE TABLE Groupe (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom VARCHAR(255) NOT NULL,
    date_debut DATE NOT NULL,
    id_circuit INTEGER NOT NULL,
    FOREIGN KEY (id_circuit) REFERENCES Circuit(id) ON DELETE CASCADE
);

CREATE TABLE Role (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom_role VARCHAR(100) NOT NULL
);

CREATE TABLE Personne (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255),
    image VARCHAR(255),
    id_role INTEGER NOT NULL,
    id_groupe INTEGER NOT NULL,
    FOREIGN KEY (id_role) REFERENCES Role(id) ON DELETE RESTRICT,
    FOREIGN KEY (id_groupe) REFERENCES Groupe(id) ON DELETE CASCADE
);

CREATE TABLE Statut_Etape (
    id INTEGER PRIMARY KEY,
    nom TEXT UNIQUE NOT NULL,
    couleur TEXT NOT NULL,
    icone TEXT NOT NULL
);

CREATE TABLE Planning_Journee (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    n_jour INTEGER NOT NULL,
    date DATE NOT NULL,
    titre VARCHAR(255) NOT NULL,
    id_groupe INTEGER NOT NULL,
    FOREIGN KEY (id_groupe) REFERENCES Groupe(id) ON DELETE CASCADE
);

CREATE TABLE Etape (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titre VARCHAR(255) NOT NULL,
    heure_debut TIME,
    duree_estimee INTEGER, -- Durée en minutes
    details VARCHAR(255),
    image VARCHAR(255),
    latitude REAL,
    longitude REAL,
    id_statut INTEGER NOT NULL DEFAULT 1,
    id_planning INTEGER NOT NULL,
    FOREIGN KEY (id_statut) REFERENCES Statut_Etape(id) ON DELETE RESTRICT,
    FOREIGN KEY (id_planning) REFERENCES Planning_Journee(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- 3. Insertion des données
-- -----------------------------------------------------

INSERT INTO Statut_Etape (id, nom, couleur, icone) VALUES
(1, 'A_VENIR',   '#BDBDBD', 'schedule'),
(2, 'EN_COURS',  '#2196F3', 'play_circle'),
(3, 'TERMINE',   '#4CAF50', 'check_circle'),
(4, 'ANNULE',    '#F44336', 'cancel');

INSERT INTO Role (id, nom_role) VALUES 
(1, 'Guide Local'),
(2, 'Touriste');

INSERT INTO Circuit (id, titre, image, nb_jours) VALUES 
(1, 'CIRCUIT ISALO - SUD', 'isalo_cover.jpg', 5);

INSERT INTO Groupe (id, nom, date_debut, id_circuit) VALUES 
(1, 'Groupe Explorer Isalo A1', '2026-08-10', 1);

INSERT INTO Personne (id, nom, prenom, image, id_role, id_groupe) VALUES 
(1, 'Raza', 'Andry', 'avatars/guide_andry.jpg', 1, 1),
(2, 'Dupont', 'Marie', 'avatars/marie.jpg', 2, 1),
(3, 'Martin', 'Lucas', 'avatars/lucas.jpg', 2, 1),
(4, 'Bernard', 'Sophie', 'avatars/sophie.jpg', 2, 1);

INSERT INTO Planning_Journee (id, n_jour, date, titre, id_groupe) VALUES 
(1, 1, '2026-08-10', 'Départ & Première Immersion à Isalo', 1),
(2, 2, '2026-08-11', 'Canyon des Makis & Crête des Baras', 1),
(3, 3, '2026-08-12', 'Cascade des Nymphes & piscine naturelle', 1);

-- Jour 1
INSERT INTO Etape (titre, heure_debut, duree_estimee, details, image, latitude, longitude, id_statut, id_planning) VALUES 
('Accueil & Briefing', '08:00', 30, 'Vérification de l équipement', 'steps/briefing.jpg', -22.5851, 45.3621, 1, 1),
('Traversée des Savanes', '09:00', 120, 'Marche sous les tapia', 'steps/savane.jpg', -22.5910, 45.3705, 1, 1),
('Coucher de soleil à la Fenêtre de l Isalo', '17:00', 90, 'Photos au coucher du soleil', 'steps/fenetre.jpg', -22.6102, 45.3512, 1, 1);

-- Jour 2
INSERT INTO Etape (titre, heure_debut, duree_estimee, details, image, latitude, longitude, id_statut, id_planning) VALUES 
('Entrée du Canyon des Makis', '07:30', 60, 'Observation des lémuriens', 'steps/makis.jpg', -22.5401, 45.3850, 1, 2),
('Pause rafraîchissante aux gorges', '09:30', 45, 'Détente au bord du ruisseau', 'steps/gorges.jpg', -22.5350, 45.3910, 1, 2),
('Ascension vers la Crête', '11:00', 90, 'Vue panoramique', 'steps/crete.jpg', -22.5280, 45.4020, 1, 2),
('Pique-nique en forêt', '13:00', 120, 'Repas traditionnel', 'steps/piquenique.jpg', -22.5312, 45.3985, 1, 2);

-- Jour 3
INSERT INTO Etape (titre, heure_debut, duree_estimee, details, image, latitude, longitude, id_statut, id_planning) VALUES 
('Départ du Campement', '07:00', 45, 'Fil de la journée - Étape 1', 'steps/depart_camp.jpg', -22.5701, 45.3600, 1, 3),
('Traversée du Ruisseau', '08:15', 30, 'Fil de la journée - Étape 2', 'steps/ruisseau.jpg', -22.5735, 45.3642, 1, 3),
('Cascade des Nymphes', '10:30', 45, 'baignade libre', 'steps/cascade.jpg', -22.5780, 45.3690, 1, 3),
('Piscine Naturelle', '13:30', 90, 'Baignade et détente', 'steps/piscine.jpg', -22.5830, 45.3750, 1, 3),
('Retour au Village de Ranohira', '16:30', 120, 'Fin du parcours', 'steps/ranohira.jpg', -22.5890, 45.3580, 1, 3);

-----------------------

CREATE TABLE Planning_Info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type_info VARCHAR(50) NOT NULL, -- Ex: 'INCLUSION', 'CONSIGNE', 'INFORMATION'
    contenu TEXT NOT NULL,
    id_planning INTEGER NOT NULL,
    FOREIGN KEY (id_planning) REFERENCES Planning_Journee(id) ON DELETE CASCADE
);