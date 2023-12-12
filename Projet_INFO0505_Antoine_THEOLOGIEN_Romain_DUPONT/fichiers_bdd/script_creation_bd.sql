--Ce document contient les différentes requêtes sql permettant la création de la base de données sous Oracle--

CREATE TABLE Laboratoire(
   IDLaboratoire INT,
   nomLabo VARCHAR(20),
   adresseLabo VARCHAR(50),
   Ville VARCHAR(20),
   numeroTel VARCHAR(10),
   nb_chercheur INT,
   email VARCHAR(50),
   site_internet VARCHAR(50),
   PRIMARY KEY(IDLaboratoire)
);

CREATE TABLE UniversiteChercheur(
   idUniversiteChercheur INT,
   adresseUniversite VARCHAR(50),
   nb_heuresC INT,
   PRIMARY KEY(idUniversiteChercheur)
);

CREATE TABLE theseChercheur(
   idTheseC INT,
   date_debut DATE,
   date_fin DATE,
   PRIMARY KEY(idTheseC)
);

CREATE TABLE ContratChercheur_Inge(
   idContrat INT,
   secteur VARCHAR(20),
   type_contrat VARCHAR(20),
   PRIMARY KEY(idContrat)
);

CREATE TABLE Experience(
   idExperience INT,
   but VARCHAR(50),
   dureePreparation VARCHAR(50),
   dureeIncubation VARCHAR(50),
   resultat VARCHAR(50),
   PRIMARY KEY(idExperience)
);

CREATE TABLE Projet(
   idProjet INT,
   sujet VARCHAR(50),
   nb_publications INT,
   dateDebut DATE,
   statut VARCHAR(20),
   idExperience INT NOT NULL,
   PRIMARY KEY(idProjet),
   UNIQUE(idExperience),
   FOREIGN KEY(idExperience) REFERENCES Experience(idExperience)
);

CREATE TABLE CultureCellulaire(
   idCultureCellulaire INT,
   nomCultureCell VARCHAR(50),
   concentrationCultureCellulaire VARCHAR(50),
   localisationCultureCellulaire VARCHAR(50),
   PRIMARY KEY(idCultureCellulaire)
);

CREATE TABLE ProduitsChimiques(
   idProduitChimique INT,
   nomProduitChimique VARCHAR(50),
   concentrationProduitChimique VARCHAR(50),
   contres_indications VARCHAR(50),
   temperature_utilisation VARCHAR(50),
   localisationProduitChimique VARCHAR(50),
   PRIMARY KEY(idProduitChimique)
);

CREATE TABLE Consommables(
   idConsommable INT,
   contenance_taille VARCHAR(50),
   nomConsommable VARCHAR(50),
   matière_consommable VARCHAR(50),
   localisationConsommable VARCHAR(50),
   PRIMARY KEY(idConsommable)
);

CREATE TABLE Materiel_biologie_moleculaire(
   id_mat_bio INT,
   nom_Mat_Bio VARCHAR(50),
   localisation_Mat_Bio VARCHAR(50),
   PRIMARY KEY(id_mat_bio)
);

CREATE TABLE Fournisseur(
   idFournisseur INT,
   nomFournisseur VARCHAR(50),
   adresseFournisseur VARCHAR(50),
   telFournisseur VARCHAR(50),
   email_fournisseur VARCHAR(50),
   PRIMARY KEY(idFournisseur)
);

CREATE TABLE PEA(
   id_PEA INT,
   datePEA DATE,
   mention VARCHAR(50),
   observation VARCHAR(50),
   PRIMARY KEY(id_PEA)
);

CREATE TABLE reunion_laboratoire(
   idReunion INT,
   dateReunion DATE,
   heureReunion DATE,
   salleReunion VARCHAR(50),
   IDLaboratoire INT NOT NULL,
   PRIMARY KEY(idReunion),
   FOREIGN KEY(IDLaboratoire) REFERENCES Laboratoire(IDLaboratoire)
);

CREATE TABLE Enzymes_Restriction(
   id_Enzyme_Restriction INT,
   numero_container INT NOT NULL,
   nom_Enzyme VARCHAR(50),
   concentrationEnzyme VARCHAR(50),
   temperature_utilisation VARCHAR(20),
   numero_boite INT NOT NULL,
   PRIMARY KEY(id_Enzyme_Restriction)
);

CREATE TABLE Tache(
   id_Tache INT,
   nom_tache VARCHAR(50),
   PRIMARY KEY(id_Tache)
);

CREATE TABLE Chercheur(
   idChercheur INT,
   nomChercheur VARCHAR(20),
   statutChercheur VARCHAR(20),
   prenomChercheur VARCHAR(20),
   ageChercheur INT NOT NULL,
   IDLaboratoire INT NOT NULL,
   idContrat INT,
   idTheseC INT,
   idUniversiteChercheur INT,
   PRIMARY KEY(idChercheur),
   FOREIGN KEY(IDLaboratoire) REFERENCES Laboratoire(IDLaboratoire),
   FOREIGN KEY(idContrat) REFERENCES ContratChercheur_Inge(idContrat),
   FOREIGN KEY(idTheseC) REFERENCES theseChercheur(idTheseC),
   FOREIGN KEY(idUniversiteChercheur) REFERENCES UniversiteChercheur(idUniversiteChercheur)
);

CREATE TABLE Equipe(
   idEquipe INT,
   idProjet INT,
   idChercheur INT NOT NULL,
   PRIMARY KEY(idEquipe),
   FOREIGN KEY(idProjet) REFERENCES Projet(idProjet),
   FOREIGN KEY(idChercheur) REFERENCES Chercheur(idChercheur)
);

CREATE TABLE Animalerie(
   id_Animalerie INT,
   genre_Souris VARCHAR(10),
   nb_Souris INT,
   id_PEA INT NOT NULL,
   IDLaboratoire INT NOT NULL,
   PRIMARY KEY(id_Animalerie),
   UNIQUE(IDLaboratoire),
   FOREIGN KEY(id_PEA) REFERENCES PEA(id_PEA),
   FOREIGN KEY(IDLaboratoire) REFERENCES Laboratoire(IDLaboratoire)
);

CREATE TABLE Produit(
   id_Produit INT,
   nb_restant_produit INT,
   idChercheur INT NOT NULL,
   IDLaboratoire INT NOT NULL,
   idProduitChimique INT,
   id_Enzyme_Restriction INT,
   id_mat_bio INT,
   idCultureCellulaire INT,
   idConsommable INT,
   PRIMARY KEY(id_Produit),
   FOREIGN KEY(idChercheur) REFERENCES Chercheur(idChercheur),
   FOREIGN KEY(IDLaboratoire) REFERENCES Laboratoire(IDLaboratoire),
   FOREIGN KEY(idProduitChimique) REFERENCES ProduitsChimiques(idProduitChimique),
   FOREIGN KEY(id_Enzyme_Restriction) REFERENCES Enzymes_Restriction(id_Enzyme_Restriction),
   FOREIGN KEY(id_mat_bio) REFERENCES Materiel_biologie_moleculaire(id_mat_bio),
   FOREIGN KEY(idCultureCellulaire) REFERENCES CultureCellulaire(idCultureCellulaire),
   FOREIGN KEY(idConsommable) REFERENCES Consommables(idConsommable)
);

CREATE TABLE Reservation(
   id_reservation INT,
   date_reservation DATE NOT NULL,
   heure_reservation DATE NOT NULL,
   IDLaboratoire INT NOT NULL,
   idChercheur INT NOT NULL,
   PRIMARY KEY(id_reservation),
   FOREIGN KEY(IDLaboratoire) REFERENCES Laboratoire(IDLaboratoire),
   FOREIGN KEY(idChercheur) REFERENCES Chercheur(idChercheur)
);

CREATE TABLE Commande(
   idCommande INT,
   dateCommande DATE,
   dateLivraison DATE,
   IDLaboratoire INT NOT NULL,
   idFournisseur INT NOT NULL,
   id_Produit INT NOT NULL,
   PRIMARY KEY(idCommande),
   FOREIGN KEY(IDLaboratoire) REFERENCES Laboratoire(IDLaboratoire),
   FOREIGN KEY(idFournisseur) REFERENCES Fournisseur(idFournisseur),
   FOREIGN KEY(id_Produit) REFERENCES Produit(id_Produit)
);

CREATE TABLE Reserver_produit(
   id_Produit INT,
   id_reservation INT,
   PRIMARY KEY(id_Produit, id_reservation),
   FOREIGN KEY(id_Produit) REFERENCES Produit(id_Produit),
   FOREIGN KEY(id_reservation) REFERENCES Reservation(id_reservation)
);

CREATE TABLE Participer_reunion(
   idChercheur INT,
   idReunion INT,
   PRIMARY KEY(idChercheur, idReunion),
   FOREIGN KEY(idChercheur) REFERENCES Chercheur(idChercheur),
   FOREIGN KEY(idReunion) REFERENCES reunion_laboratoire(idReunion)
);

CREATE TABLE Utiliser(
   idExperience INT,
   id_Produit INT,
   PRIMARY KEY(idExperience, id_Produit),
   FOREIGN KEY(idExperience) REFERENCES Experience(idExperience),
   FOREIGN KEY(id_Produit) REFERENCES Produit(id_Produit)
);

CREATE TABLE Etre_membre(
   idChercheur INT,
   idEquipe INT,
   PRIMARY KEY(idChercheur, idEquipe),
   FOREIGN KEY(idChercheur) REFERENCES Chercheur(idChercheur),
   FOREIGN KEY(idEquipe) REFERENCES Equipe(idEquipe)
);

CREATE TABLE Est_responsable(
   idChercheur INT,
   id_Tache INT,
   PRIMARY KEY(idChercheur, id_Tache),
   FOREIGN KEY(idChercheur) REFERENCES Chercheur(idChercheur),
   FOREIGN KEY(id_Tache) REFERENCES Tache(id_Tache)
);

