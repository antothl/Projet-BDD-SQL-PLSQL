
--Afficher les prénoms et noms des chercheurs du laboratoire dont l'identifiant est 1--

DECLARE
P_NOMCHERCHEUR CHERCHEUR.NOMCHERCHEUR%TYPE;
P_PRENOMCHERCHEUR CHERCHEUR.PRENOMCHERCHEUR%TYPE;
CURSOR curseur_CHERCHEUR IS
SELECT NOMCHERCHEUR, PRENOMCHERCHEUR FROM CHERCHEUR WHERE IDLABORATOIRE=1;
BEGIN 
OPEN curseur_CHERCHEUR;
LOOP
FETCH curseur_CHERCHEUR INTO P_NOMCHERCHEUR,P_PRENOMCHERCHEUR;
EXIT WHEN NOT curseur_CHERCHEUR%FOUND;
DBMS_OUTPUT.PUT_LINE('Le chercheur '|| P_NOMCHERCHEUR || ' se prénomme : '|| P_PRENOMCHERCHEUR ||'.');

END LOOP;
END;


--Procedure permettant de mettre a jour le nombre de chercheurs au sein des laboratoires--
CREATE OR REPLACE PROCEDURE maj_nombre_chercheurs(
    id_labo IN NUMBER
)
IS
    v_nb_chercheurs NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_nb_chercheurs FROM CHERCHEUR;

    UPDATE LABORATOIRE
    SET nb_chercheur = v_nb_chercheurs
    WHERE IDLABORATOIRE=id_labo;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Nombre de chercheurs mis à jour : ' || v_nb_chercheurs);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erreur lors de la mise à jour du nombre de chercheurs : ' || SQLERRM);
END;

--Execution--
BEGIN 
maj_nombre_chercheurs(1);
END;

--¨Procédure permettant d'ajouter un chercheur sans profession au labo 1, appel à maj_nombre_chercheurs--
CREATE OR REPLACE PROCEDURE ajouter_chercheur_labo1 (
    nom_chercheur IN VARCHAR2,
    prenom_chercheur IN VARCHAR2,
    age_chercheur IN NUMBER
)

IS
temp NUMBER;
BEGIN
    SELECT MAX(IDCHERCHEUR) INTO temp FROM CHERCHEUR;
    INSERT INTO CHERCHEUR(IDCHERCHEUR,NOMCHERCHEUR, PRENOMCHERCHEUR,AGECHERCHEUR, IDLABORATOIRE, STATUTCHERCHEUR)
    VALUES (temp+1, nom_chercheur,prenom_chercheur,age_chercheur,0,'Non');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Chercheur ajouté avec succès.');
    maj_nombre_chercheurs(0);
EXCEPTION
WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erreur lors de l''ajout du chercheur : ' || SQLERRM);
END;
--Exécution--
BEGIN
    ajouter_chercheur_labo1('Théologien', 'Antoine', 20);
END;

--Trigger permettant de diminuer la quantité disponible d'un produit après que celui-ci est été réservé--
CREATE OR REPLACE TRIGGER diminuer_quantite_produit
AFTER INSERT ON Reserver_produit
FOR EACH ROW
BEGIN
    UPDATE Produit
    SET nb_restant_produit = nb_restant_produit - 1
    WHERE id_produit = :NEW.id_produit;

    DBMS_OUTPUT.PUT_LINE('Quantité réservée mise à jour pour le produit : ' || :NEW.id_produit);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur lors de la mise à jour de la quantité réservée : ' || SQLERRM);
END;

--Pour tester--
INSERT INTO RESERVER_PRODUIT(ID_RESERVATION,ID_PRODUIT) VALUES (2,19);



--Procédure permettant d'afficher les détails de la profession d'un chercheur en fonction de sa profession--
CREATE OR REPLACE PROCEDURE profession_chercheur(
    p_id_chercheur IN NUMBER
    
)
IS
    v_statut VARCHAR2(100);
	p_id_profession NUMBER;
BEGIN
    SELECT statutchercheur
    INTO v_statut
    FROM CHERCHEUR
    WHERE IDCHERCHEUR = p_id_chercheur;

    IF v_statut != 'Non' THEN
        DBMS_OUTPUT.PUT_LINE('La profession du chercheur est : ' || v_statut);
        IF v_statut LIKE 'Ingénieur' THEN
        SELECT IDCONTRAT INTO p_id_profession FROM CHERCHEUR WHERE IDCHERCHEUR=p_id_chercheur;
        FOR contrat IN (SELECT * FROM CONTRATCHERCHEUR_INGE WHERE IDCONTRAT = p_id_profession) LOOP
            DBMS_OUTPUT.PUT_LINE('Détails du contrat :');
            DBMS_OUTPUT.PUT_LINE('ID du contrat : ' || contrat.IDCONTRAT);
			DBMS_OUTPUT.PUT_LINE('Secteur :' || contrat.secteur );
			DBMS_OUTPUT.PUT_LINE('Type de contrat :' || contrat.type_contrat);
        END LOOP;
		END IF;
		IF v_statut LIKE 'Professeur' THEN
        SELECT IDUNIVERSITECHERCHEUR INTO p_id_profession FROM CHERCHEUR WHERE IDCHERCHEUR=p_id_chercheur;
            FOR contrat IN (SELECT * FROM UNIVERSITECHERCHEUR WHERE IDUNIVERSITECHERCHEUR=p_id_profession) LOOP
            DBMS_OUTPUT.PUT_LINE('Détails du contrat professeur :');
			DBMS_OUTPUT.PUT_LINE('ID du contrat professeur : ' || contrat.IDUNIVERSITECHERCHEUR);
			DBMS_OUTPUT.PUT_LINE('Adresse de l''université : '|| contrat.adresseUniversite);
			DBMS_OUTPUT.PUT_LINE('Nombre d''heures enseignées :  '|| contrat.nb_heuresC);
		END LOOP;
		END IF;
		IF v_statut LIKE 'Etudiant' THEN
        SELECT IDTHESEC INTO p_id_profession FROM CHERCHEUR WHERE IDCHERCHEUR=p_id_chercheur;
            FOR contrat IN(SELECT * FROM THESECHERCHEUR WHERE IDTHESEC=p_id_profession) LOOP
                DBMS_OUTPUT.PUT_LINE('Détails de la thèse : ');
				DBMS_OUTPUT.PUT_LINE('ID de la thèse : ' || contrat.IDTHESEC);
				DBMS_OUTPUT.PUT_LINE('Date de début de la thèse : ' || contrat.date_debut);
				DBMS_OUTPUT.PUT_LINE('Date de fin estimée de la thèse : ' || contrat.date_fin);
			END LOOP;
		END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ce chercheur n''a pas de profession associée.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun chercheur trouvé avec cet identifiant.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur lors de la recherche des détails du chercheur : ' || SQLERRM);
END;
--Exécution--
BEGIN
profession_chercheur(19);
END;