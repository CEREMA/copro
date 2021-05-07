/*===================================================================================================================================================*/
/* 												SCRIPT SUR LES COPROPRIETES TORUISTIQUES EN OCCITANIE												 */
/* 												      ----- BENEFICIAIRE : EPF OCCITANIE ----- 													 	 */
/*===================================================================================================================================================*/

-----------------------------------------------------------------------------
-- Ecrit par: Cerema - Direction territoriale M�diterran�e ------------------
------------- D�partement Territoires Villes B�timent - Groupe Territoires --
------------- HOUDAYER St�phane ---------------------------------------------
-----------------------------------------------------------------------------


/*=======================================================================*/
/*         ETAPE 0: IMPORT ET NETTOYAGE DE LA TABLE ISSU DU              */
/*                  REGISTRE NATIONAL DES COPROPRIETES (RNIC)            */
/*=======================================================================*/


----- Importer via QGIS de la table des copropri�t�s en OCCITANIE -----
-- Ajout d'une contrainte de cl� primiare sur l'identifiant unique "id"
-- 79 862 copropri�t�s en OCCITANIE (en double !!!)

-- Renommage des colonnes
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "num�ro d'immatriculation" TO num_immat;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "administration provisoire (oui / non / non connu)" TO admin_prov;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "type de syndic : b�n�vole / professionnel / non connu" TO type_syndi;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "syndic provisoire : oui / non" TO syndic_pro;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "identification du repr�sentant l�gal  (raison sociale et le n" TO repre_lega;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "code ape" TO code_ape;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "commune du repr�sentant l�gal" TO com_rl;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "mandat en cours dans la copropri�t�" TO mandat;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "date de fin du dernier mandat" TO dfinmandat;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nom d�usage de la copropri�t�" TO nomusageco;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "adresse de r�f�rence" TO adress_ref;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "adresse compl�mentaire 1" TO ad_compl1;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "adresse compl�mentaire 2" TO ad_compl2;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "adresse compl�mentaire 3" TO ad_compl3;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d'adresses compl�mentaires" TO nb_adr_com;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "code insee commune" TO insee_com;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "pr�fixe" TO prefixe;  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "num�ro parcelle" TO num_parcel;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "code insee commune_1" TO insee_com1;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "pr�fixe_1" TO prefixe1;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN section_1 TO section1;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "num�ro parcelle_1" TO num_parcel1;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "code insee commune_2" TO insee_com2;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "pr�fixe_2" TO prefixe2;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN section_2 TO section2;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "num�ro parcelle_2" TO num_parcel2;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre de parcelles cadastrales" TO nb_parcell;   
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "coordonn�es de g�olocalisation" TO geom;   
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "r�sidence service" TO res_servic;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "date du r�glement de copropri�t�" TO date_regl_;    
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "syndicat coop�ratif" TO syndic_coo;       
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "syndicat principal ou syndicat secondaire" TO syndic_p_s;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "si secondaire, n� d�immatriculation du principal" TO immat_p;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d�asl auxquelles est rattach� le syndicat de copropri" TO nb_asl; 
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d�aful auxquelles est rattach� le syndicat de copropr" TO nb_aful; 
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d�unions de syndicats auxquelles est rattach� le synd" TO nb_unions; 
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre total de lots" TO nb_tot_lot;  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre total de lots � usage d�habitation, de bureaux ou de " TO nb_tot_hbc; 
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre de lots � usage d�habitation" TO nb_lot_hab;  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre de lots de stationnement" TO stationnem;     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d'arr�t�s relevant du code de la sant� publique en co" TO nb_arret_s;     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d'arr�t�s de p�ril sur les parties communes en cours" TO nb_arret_p;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d'arr�t�s sur les �quipements communs en cours" TO nb_arret_e;      
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "mandat ad hoc en cours (oui / non)" TO mdt_ah_en_;       
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "ordonnance de carence (date)" TO ordo_caren;          
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "premier exercice comptable (oui / non)" TO exe_compta;     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN  "date de d�but de l�exercice comptable" TO deb_exe_co;     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "date de fin de l�exercice comptable" TO fin_exe_co;     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "date de l�assembl�e g�n�rale approuvant les comptes" TO dte_ag_cpt;      
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "charges pour op�rations courantes de l�exercice clos" TO charge_ope;  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "charges pour travaux et op�rations exceptionnelles de l�exer" TO charge_tr_;     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "montant des dettes fournisseurs, r�mun�rations et autres" TO dette_four;      
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "montant des sommes restant dues par les copropri�taires" TO dette_copr; 
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre de copropri�taires d�biteurs de plus de 300 euros vis-" TO nb_copro_3;  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "montant du fonds de travaux" TO mont_trava;  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "pr�sence de personnel(s) employ�(s) par le syndicat de coprop" TO employe_sy;   
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "p�riode de construction" TO p_constr; 
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "ann�e d'ach�vement de la construction" TO an_fin_con;      
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "non-d�termin�" TO non_determ;      
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "type de chauffage" TO typchauffa;     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "pour un chauffage collectif (partiel ou total) : ce chauffage " TO chauf_urba;       
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "pour un chauffage collectif (partiel ou total) non urbain : �n" TO nrj_non_ur;   
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "nombre d�ascenseurs" TO nb_ascensc;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN "identifiant ign" TO ident_ign;
  

-- Mises � jour de certaines colonnes
UPDATE zz_copro_occ_2020.copro_occ_2020 SET ad_compl1 = (CASE WHEN ad_compl1 = ''  THEN NULL ELSE ad_compl1 END); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET ad_compl2 = (CASE WHEN ad_compl2 = ''  THEN NULL ELSE ad_compl2 END); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET ad_compl3 = (CASE WHEN ad_compl3 = ''  THEN NULL ELSE ad_compl3 END);  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET nb_asl = (CASE WHEN nb_asl = 'non renseign�' THEN NULL ELSE nb_asl END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET nb_aful = (CASE WHEN nb_aful = 'non renseign�' THEN NULL ELSE nb_aful END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET nb_unions = (CASE WHEN nb_unions = 'non renseign�' THEN NULL ELSE nb_unions END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET charge_ope = (CASE WHEN charge_ope = 'non renseign�' THEN NULL ELSE charge_ope END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET charge_tr_ = (CASE WHEN charge_tr_ = 'non renseign�' THEN NULL ELSE charge_tr_ END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET dette_four = (CASE WHEN dette_four = 'non renseign�' THEN NULL ELSE dette_four END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET dette_copr = (CASE WHEN dette_copr = 'non renseign�' THEN NULL ELSE dette_copr END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET nb_copro_3 = (CASE WHEN nb_copro_3 = 'non renseign�' THEN NULL ELSE nb_copro_3 END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET mont_trava = (CASE WHEN mont_trava = 'non renseign�' THEN NULL ELSE mont_trava END);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET nb_ascensc = (CASE WHEN nb_ascensc = 'non renseign�' THEN NULL ELSE nb_ascensc END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET a = (CASE WHEN a = '' THEN NULL ELSE a END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET b = (CASE WHEN b = '' THEN NULL ELSE b END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET c = (CASE WHEN c = '' THEN NULL ELSE c END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET d = (CASE WHEN d = '' THEN NULL ELSE d END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET e = (CASE WHEN e = '' THEN NULL ELSE e END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET f = (CASE WHEN f = '' THEN NULL ELSE f END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET g = (CASE WHEN g = '' THEN NULL ELSE g END);
--UPDATE zz_copro_occ_2020.copro_occ_2020 SET non_determ = (CASE WHEN non_determ = '' THEN NULL ELSE non_determ END);

-- Remplacements des caract�res sp�ciaux sur certaines colonnes (valables pour les colonnes de type num�rique
UPDATE zz_copro_occ_2020.copro_occ_2020 SET charge_ope = REPLACE(charge_ope, ',', '.'); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET charge_tr_ = REPLACE(charge_tr_, ',', '.'); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET dette_four = REPLACE(dette_four, ',', '.'); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET dette_copr = REPLACE(dette_copr, ',', '.'); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET nb_copro_3 = REPLACE(nb_copro_3, ',', '.'); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET mont_trava = REPLACE(mont_trava, ',', '.');     

-- Typage des colonnes
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN epci TYPE character varying(9) using cast(epci AS character varying);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN commune TYPE character varying(5) using cast(commune AS character varying);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_adr_com TYPE bigint using cast(nb_adr_com AS bigint);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN insee_com TYPE character varying(5) using cast(insee_com AS character varying);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN insee_com1 TYPE character varying(5) using cast(insee_com1 AS character varying);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN insee_com2 TYPE character varying(5) using cast(insee_com2 AS character varying);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN prefixe2 TYPE character varying(3) using cast(prefixe2 AS character varying);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_parcell TYPE bigint using cast(nb_parcell AS bigint);  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_asl TYPE bigint using cast(nb_asl AS bigint);     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_aful TYPE bigint using cast(nb_aful AS bigint);   
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_unions TYPE bigint using cast(nb_unions AS bigint);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_tot_lot TYPE bigint using cast(nb_tot_lot AS bigint);    
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_tot_hbc TYPE bigint using cast(nb_tot_hbc AS bigint);     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_lot_hab TYPE bigint using cast(nb_lot_hab AS bigint);     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN stationnem TYPE bigint using cast(stationnem AS bigint);       
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_arret_s TYPE bigint using cast(nb_arret_s AS bigint);      
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_arret_p TYPE bigint using cast(nb_arret_p AS bigint);         
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_arret_e TYPE bigint using cast(nb_arret_e AS bigint);   
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN charge_ope TYPE numeric using cast(charge_ope AS numeric);        
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN charge_tr_ TYPE numeric using cast(charge_tr_ AS numeric);    
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN dette_four TYPE numeric using cast(dette_four AS numeric);    
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN dette_copr TYPE numeric using cast(dette_copr AS numeric);       
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_copro_3 TYPE integer using cast(nb_copro_3 AS integer);     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN mont_trava TYPE numeric using cast(mont_trava AS numeric);       
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN a TYPE bigint using cast(a AS bigint);  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN b TYPE bigint using cast(b AS bigint);  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN c TYPE bigint using cast(c AS bigint);  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN d TYPE bigint using cast(d AS bigint);  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN e TYPE bigint using cast(e AS bigint);  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN f TYPE bigint using cast(f AS bigint);  
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN g TYPE bigint using cast(g AS bigint);      
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN non_determ TYPE bigint using cast(non_determ AS bigint);     
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ALTER COLUMN nb_ascensc TYPE bigint using cast(nb_ascensc AS bigint);  

-- Compl�ments de colonnes
UPDATE zz_copro_occ_2020.copro_occ_2020 SET commune = LPAD(commune, 5, '0');
UPDATE zz_copro_occ_2020.copro_occ_2020 SET com_rl = LPAD(com_rl, 5, '0');  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET insee_com = LPAD(insee_com, 5, '0');  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET prefixe = LPAD(prefixe, 3, '0');  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET num_parcel = LPAD(num_parcel, 4, '0'); 
UPDATE zz_copro_occ_2020.copro_occ_2020 SET insee_com1 = LPAD(insee_com1, 5, '0');
UPDATE zz_copro_occ_2020.copro_occ_2020 SET prefixe1 = LPAD(prefixe1, 3, '0');  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET num_parcel1 = LPAD(num_parcel1, 4, '0');  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET insee_com2 = LPAD(insee_com2, 5, '0');  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET prefixe2 = LPAD(prefixe2, 3, '0');  
UPDATE zz_copro_occ_2020.copro_occ_2020 SET num_parcel2 = LPAD(num_parcel2, 4, '0');  

-- Renommage de la colonne geom
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 RENAME COLUMN geom TO geom_char;

-- Cr�ation d'une g�ometrie de type POINT � partir de la colonne geom_char
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN geom geometry(Point,2154);
-- Mise � jour de la colonne geom
UPDATE zz_copro_occ_2020.copro_occ_2020 AS co SET geom = g.geom 
FROM
(WITH f AS (SELECT id,geom_char, regexp_split_to_array(geom_char,E'\\s+') AS rsta FROM zz_copro_occ_2020.copro_occ_2020)
SELECT id, st_transform(st_setsrid(st_makepoint( ltrim(rsta[2],'(')::double precision, rtrim(rsta[3],')')::double precision),4326),2154) AS geom  FROM f) AS g
WHERE co.id = g.id;

-- Cr�ation d'un index g�om�trique sur le champ geom
CREATE INDEX zz_copro_occ_2020_geom_idx ON zz_copro_occ_2020.copro_occ_2020 USING gist(geom)

-- Ajout d'une contrainte de cl� primaire sur la colonne gid (colonne de type SERIAL NOT NULL donc colonne avce des valeurs uniques)
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN gid SERIAL NOT NULL;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD CONSTRAINT copro_occ_2020_gid_pk PRIMARY KEY(gid);


/*=============================================================================================*/
/* 		ETAPE 1 : CREATION DE LA TABLE UNIFIEE DU PARCELLAIRE (TUP) SUR LA REGION OCCITANIE    */ 
/*                A PARTIR DES TABLES UNIFIEES DU PARCELLAIRES (TUP) DEPARTEMENTALES           */        
/*=============================================================================================*/
 
 ----- Rappel: une g�om�trie TUP correspond soit � une parcelle, soit � une Unit� Fonci�re (UF), 
 ----- soit � une Propri�t� Divis�e en Lots Multi-Parcelles (PDLMP)

-- DROP TABLE IF EXISTS zz_copro_occ_2019.tup_2019_occitanie;
CREATE TABLE zz_copro_occ_2020.tup_2019_occitanie AS
SELECT * FROM ff_2019_dep.d09_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d11_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d12_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d30_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d31_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d32_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d34_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d46_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d48_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d65_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d66_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d81_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d82_ffta_2019_tup WHERE nlocmaison > 1 OR nlocappt > 1;

-- Cr�ation d'un index sur la g�om�trie geomtup
CREATE INDEX zz_copro_occ_2020_tup_2019_geomtup_idx ON zz_copro_occ_2020.tup_2019_occitanie USING gist(geomtup);

-- Cr�ation d'un identifiant unique de type serial non null
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN id SERIAL NOT NULL;
-- Cr�ation d'une contrainte de cl� primaire sur le champ id
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD CONSTRAINT zz_copro_occ_2020_tup_2019_id_pk PRIMARY KEY (id);

-- Modificaton du type de la colonne idpar_l dans la table TUP
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ALTER COLUMN idpar_l TYPE text using cast(idpar_l AS text);
UPDATE zz_copro_occ_2020.tup_2019_occitanie  SET idpar_l='{'||idpar_l||'}';
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ALTER COLUMN idpar_l TYPE text[] using cast(idpar_l AS text[]);

-- Cr�ation d'index sur 2 colonnes: idapr_l et idtup
CREATE INDEX zz_copro_occ_2020_tup_2019_idpar_l_idx ON zz_copro_occ_2020.tup_2019_occitanie USING btree(idpar_l);
CREATE INDEX zz_copro_occ_2020_tup_2019_idtup_idx ON zz_copro_occ_2020.tup_2019_occitanie USING btree(idtup);


/*=========================================================================================================*/
/* 		ETAPE 2 : GEOCODAGE DES DIFFERENTES COLONNES ADRESSES DU RNIC VIA LA BASE ADRESSE NATIONAL (BAN)   */ 
/*                           Site de la BAN : https://adresse.data.gouv.fr/csv                             */
/*                              (utilisation de l'outil "Le geocodeur CSV")                                */
/*=========================================================================================================*/

-- (a) Export de la table du RNIC OCCITANIE en fichier texte .csv. Au final, cr�ation de 4 fichiers .csv (1 fichier .csv) par colonne adresse
    -- sachant que la table du RNIC comporte 4 colonnes adresse: adress_ref, ad_compl1, ad_compl2 et ad_compl3
-- (b) D�coupage du fichier texte .csv (correspondant � la colonne adress_ref) en 3 fichiers pour permettre � l'outil de la GEOBAN, uniquement pour la colonne adress_ref
    -- de pouvoir faire le g�ocodage (probl�me au niveau du nombre de lignes max)
-- (c) Lancement du g�ocodage pour le fichier texte .csv pour adress_ref, et pour les 3 fichiers .csv pour ad_compl1, ad_compl2 et ad_compl3
-- (d) Import des 6 fichiers .csv g�ocod�s � travers l'outil BAN dans postgresql via QGIS (dont 3 fichiers pour la colonne adress_ref)
    -- Au total, 6 tables sont cr��es dans postgresql: 
	-- geocodage_ban_ad_ref_0_12999, geocodage_ban_ad_ref_13000_25999 et geocodage_ban_ad_ref_26000_fin (tables g�ocod�es � partir de la colonne adress_ref)
	-- geocodage_ban1 (table g�ocod�e � partir de la colonne adcompl1)
	-- geocodage_ban2 (table g�ocod�e � partir de la colonne adcompl2)
	-- geocodage_ban3 (table g�ocod�e � partir de la colonne adcompl3)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cr�ation d'une table geocodage_ban_ref resultant des 3 tables import�es issue du g�ocodage de la colonne adress_ref (3 fichiers .csv import�s dans postgresql) --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE zz_copro_occ_2020.geocodage_ban_ref AS
SELECT * FROM zz_copro_occ_2020.geocodage_ban_ad_ref_0_12999
UNION
SELECT * FROM zz_copro_occ_2020.geocodage_ban_ad_ref_13000_25999
UNION
SELECT * FROM zz_copro_occ_2020.geocodage_ban_ad_ref_26000_fin;

----- Nettoyage des tables issues du g�ocodage - on ne conserve que la valeur 'housenumber' de la colonne result_type
----- cette valeur correspond � une localistaion la plus pr�cise (a la plaque de rue / au num�ro de rue)
----- On �limine donc toutes les valeurs NULL ou diff�rentes de 'house_number' de la colonne result_type
DELETE FROM zz_copro_occ_2020.geocodage_ban_ref WHERE result_type != 'housenumber' OR result_type IS NULL;
DELETE FROM zz_copro_occ_2020.geocodage_ban1 WHERE result_type != 'housenumber' OR result_type IS NULL;
DELETE FROM zz_copro_occ_2020.geocodage_ban2 WHERE result_type != 'housenumber' OR result_type IS NULL;
DELETE FROM zz_copro_occ_2020.geocodage_ban3 WHERE result_type != 'housenumber' OR result_type IS NULL;


----- Mise � jour des colonnes longitude et latitude avec la valeur NULL 
----- quand ces colonnes n'ont aucune valeur de renseign�e (�gale � '') de la table copro_occ_2020
-- Table geocodage_ban_ref
UPDATE zz_copro_occ_2020.geocodage_ban_ref SET longitude = NULL WHERE longitude = '';
UPDATE zz_copro_occ_2020.geocodage_ban_ref SET latitude = NULL WHERE latitude = '';
-- Table geocodage_ban1
UPDATE zz_copro_occ_2020.geocodage_ban1 SET longitude = NULL WHERE longitude = '';
UPDATE zz_copro_occ_2020.geocodage_ban1 SET latitude = NULL WHERE latitude = '';
-- Table geocodage_ban2
UPDATE zz_copro_occ_2020.geocodage_ban2 SET longitude = NULL WHERE longitude = '';
UPDATE zz_copro_occ_2020.geocodage_ban2 SET latitude = NULL WHERE latitude = '';
-- Table geocodage_ban3
UPDATE zz_copro_occ_2020.geocodage_ban3 SET longitude = NULL WHERE longitude = '';
UPDATE zz_copro_occ_2020.geocodage_ban3 SET latitude = NULL WHERE latitude = '';

-----------------------------------------------------------------------------------------------------------------------------
----- Ajout de 4 colonnes � la table copro_occ_2020 correspondants aux localisants issus des colonnes logitude et latitude --
-----------------------------------------------------------------------------------------------------------------------------
----- des 4 tables du geocodage (geocodage_ban_ref, geocodage_ban1, geocodage_ban2 et geocodage_ban3)
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN geom_ban_ref geometry;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN geom_ban1 geometry;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN geom_ban2 geometry;
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN geom_ban3 geometry;


----- Cr�ation des index g�om�triques pour les 4 champs de type geometry cr�es pr�c�demment (geom_ban_ref, geom_ban1, geom_ban2 et geom_ban3)-----
-- Table geocodage_ban_ref
DROP INDEX IF EXISTS zz_copro_occ_2020_geom_ban_ref_idx;
CREATE INDEX zz_copro_occ_2020_geom_ban_ref_idx ON zz_copro_occ_2020.copro_occ_2020 USING gist(geom_ban_ref);
-- Table geocodage_ban1
DROP INDEX IF EXISTS zz_copro_occ_2020_geom_ban1_idx;
CREATE INDEX zz_copro_occ_2020_geom_ban1_idx ON zz_copro_occ_2020.copro_occ_2020 USING gist(geom_ban1);
-- Table geocodage_ban2
DROP INDEX IF EXISTS zz_copro_occ_2020_geom_ban2_idx;
CREATE INDEX zz_copro_occ_2020_geom_ban2_idx ON zz_copro_occ_2020.copro_occ_2020 USING gist(geom_ban2);
-- Table geocodage_ban3
DROP INDEX IF EXISTS zz_copro_occ_2020_geom_ban3_idx;
CREATE INDEX zz_copro_occ_2020_geom_ban3_idx ON zz_copro_occ_2020.copro_occ_2020 USING gist(geom_ban3);


----- G�olocalisation des points(x,y) -----
-- Table geocodage_ban_ref
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET geom_ban_ref = ST_TRANSFORM(ST_SetSRID(ST_MAKEPOINT(b.longitude::double precision, b.latitude::double precision),4326),2154) FROM zz_copro_occ_2020.geocodage_ban_ref b
WHERE a.gid = b.gid::integer;
-- Table geocodage_ban1
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET geom_ban1 = ST_TRANSFORM(ST_SetSRID(ST_MAKEPOINT(b.longitude::double precision, b.latitude::double precision),4326),2154) FROM zz_copro_occ_2020.geocodage_ban1 b
WHERE a.gid = b.gid::integer;
-- Table geocodage_ban2
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET geom_ban2 = ST_TRANSFORM(ST_SetSRID(ST_MAKEPOINT(b.longitude::double precision, b.latitude::double precision),4326),2154) FROM zz_copro_occ_2020.geocodage_ban2 b
WHERE a.gid = b.gid::integer;
-- Table geocodage_ban3
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET geom_ban3 = ST_TRANSFORM(ST_SetSRID(ST_MAKEPOINT(b.longitude::double precision, b.latitude::double precision),4326),2154) FROM zz_copro_occ_2020.geocodage_ban3 b
WHERE a.gid = b.gid::integer;



/*=====================================================================================================*/
/*  					ETAPE 3 : RAPPROCHEMENT ENTRE LE RNIC ET LA TABLE DES TUP                      */
/*         SOIT A PARTIR DES IDENTIFIANTS DE PARCELLES,  SOIT A PARTIR DES LOCALISANTS DU RNIC         */
/*                                    AFIN DE METTRE A JOUR LA COLONNE idtup                           */
/*=====================================================================================================*/

------------------------------------------------------------
----- Ajout de la colonne idtup � la table copro_occ_2020 --
------------------------------------------------------------
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN idtup character varying(20);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET idtup = NULL;
CREATE INDEX zz_copro_occ_2020_idtup_idx ON zz_copro_occ_2020.copro_occ_2020 USING btree(idtup);

----------------------------------------------------------------------------------------------------
----- Ajouts de 3 colonnes correspondants � 3 identifiants de parcelles � la table corpo_occ_2020 --
----------------------------------------------------------------------------------------------------
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN idpar character varying(14);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN idpar1 character varying(14);
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN idpar2 character varying(14);

----- Mise � jour de 3 ces colonnes (colonne de type caract�re de taille 14) -----
-- colonne idpar: concat�nation des colonnes insee_com(5), prefixe(3), section(2) et num_parcel(4)
UPDATE zz_copro_occ_2020.copro_occ_2020 
SET idpar = (CASE WHEN insee_com = '00000' THEN commune ELSE insee_com END) || prefixe || LPAD(UPPER(section),2,'0') || num_parcel 
WHERE section NOT IN ('', '0', '0-', '01', '1', '12', '13', '25', '26', '28', '29', '39', '4', '5', '53', '56', '61', '65', '68', '80', '81', '87', '9A') 
AND num_parcel != '0000'; 
-- 25 650 parcelles mises � jour
-- colonne idpar1: concat�nation des colonnes insee_com1(5), prefixe1(3), section1(2) et num_parcel1(4)
UPDATE zz_copro_occ_2020.copro_occ_2020 
SET idpar1 = (CASE WHEN insee_com1 = '00000' THEN commune ELSE insee_com1 END) ||prefixe1 || LPAD(UPPER(section1),2,'0') || num_parcel1 
WHERE section1 NOT IN ('', '0') AND num_parcel1 != '0000';
-- 4 698 parcelles mises� jour
-- colonne idpar2: concat�nation des colonnes insee_com2(5), prefixe2(3), section2(2) et num_parcel2(4)
UPDATE zz_copro_occ_2020.copro_occ_2020 
SET idpar2 = (CASE WHEN insee_com2 = '00000' THEN commune ELSE insee_com2 END) || prefixe2 || LPAD(UPPER(section2),2,'0') || num_parcel2
WHERE section2 NOT IN ('', '0', '17') AND num_parcel2 != '0000'; 
-- 2 260 parcelles mises � jour


----------------------------------------------------------------------------------------------------------------------------------------------------
-- Recgerche de correspondance "exacte" entre la table issue du RNIC (table copro_occ_2020) et la table issue des TUP (table tup_2020_occitanie ) --
-- A partir des identifiants de parcelles pr�sents dans la table copro_occ_2020 : idpar, idpar1, idpar2 --------------------------------------------
-- Ajouts et mises � jour des colonnes idpar_tup, idapr1_tup et idpar2_tup � la table copro_occ_2020 correspondantes aux �tapes 1 � 3---------------
----------------------------------------------------------------------------------------------------------------------------------------------------

----- Etape 1 : rapprochement entre l'identifiant de parcelle (idpar) de la table copro_occ_2020 et les identifiants de parcelles contenus dans la table tup_2020_occitanie (idpar_l) -----
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN idpar_tup boolean;
CREATE INDEX zz_copro_occ_2020_2020_idpar_idx ON zz_copro_occ_2020.copro_occ_2020 USING btree(idpar);
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET idpar_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET idpar_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b WHERE a.idpar = ANY(b.idpar_l);
-- 21 532 copro correspondantes

----- Etape 2 : rapprochement entre l'identifiant de parcelle 1 (idpar1)de la table copro_occ_2020 et les identifiants de parcelles contenus dans la table tup_2019_occitanie (idpar_l) -----
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN idpar1_tup boolean;
CREATE INDEX zz_copro_occ_2020_2020_idpar1_idx ON zz_copro_occ_2020.copro_occ_2020 USING btree(idpar1);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET idpar1_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET idpar1_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b WHERE a.idpar1 = ANY(b.idpar_l) 
AND a.idtup IS NULL AND idpar_tup IS NULL;
-- 295 copro correspondantes

----- Etape 3 : rapprochement entre l'identifiant de parcelle 2 (idpar2) de la table copro_occ_2020 et les identifiants de parcelles contenus dans la table tup_2019_occitanie (idpar_l) -----
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN idpar2_tup boolean;
CREATE INDEX zz_copro_occ_2020_2020_idpar2_idx ON zz_copro_occ_2020.copro_occ_2020 USING btree(idpar2);
UPDATE zz_copro_occ_2020.copro_occ_2020 SET idpar2_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET idpar2_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b WHERE a.idpar2 = ANY(b.idpar_l) 
AND a.idtup IS NULL AND (idpar_tup IS NULL OR idpar1_tup IS NULL);
-- 51 copro correspondantes

----- 21 878 TUP r�cup�r�es -----


------------------------------------------------------------------------------------------------------------------------------------------------------
-- Recherche de correspondance entre le localisant du RNIC plus ceux issus du g�ocodage (colonnes geom_ban_ref, geom_ban1, geom_ban2 et geom_ban3) ---
-- et les g�om�tries TUP de la table tup_2019_occitanie (colonne geom) sachant qu'une TUP peut �tre: -------------------------------------------------
-- une parcelle, une Unit� Fonci�re (UF) ou une Propri�t� Divis�e en Lot Multi-Parcelles (PDLMP) -----------------------------------------------------
-- Ajouts et mises � jour des colonnes rnic_tup, banref_tup, ban1_tup, ban2_tupe et ban3_tup correspondants aux �tapes 4 � 8 -------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

----- Etape 4 : rapprochement entre le localisant RNIC (colonne geom) de la table copro_occ_2020 et les g�om�tries TUP de la table tup_2019_occitanie                                           
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN rnic_tup boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET rnic_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET rnic_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b
WHERE a.idtup IS NULL AND ST_WITHIN(a.geom, b.geomtup);
-- 4 655 copro correspondantes

----- Etape 5 : rapprochement entre le localisant issu de l'adresse de r�f�rence (colonne geom_ban_ref) de la table copro_occ_2020 et les g�om�tries TUP de la table tup_2019_occitanie
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN banref_tup boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET banref_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET banref_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b 
WHERE a.idtup IS NULL AND ST_WITHIN(a.geom_ban_ref, b.geomtup);
-- 1 307 copro correspondantes

----- Etape 6 : rapprochement entre le localisant issu de l'adresse compl�mentaire 1 (colonne geom_ban1) de la table copro_occ_2020 et les g�om�tries TUP de la table tup_2019_occitanie
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban1_tup boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban1_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban1_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b 
WHERE a.idtup IS NULL AND ST_WITHIN(a.geom_ban1, b.geomtup) AND banref_tup IS NULL;
-- 178 copro correspondantes

----- Etape 7 : rapprochement entre le localisant issu de l'adresse compl�mentaire 2 (colonne geom_ban2) de la table copro_occ_2020 et les g�om�tries TUP de la table tup_2019_occitanie
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban2_tup boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban2_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban2_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b 
WHERE a.idtup IS NULL AND ST_WITHIN(a.geom_ban2, b.geomtup) AND (banref_tup IS NULL OR ban1_tup IS NULL);
-- 30 copro correspondantes

----- Etape 8 : rapprochement entre le localisant issu de l'adresse compl�mentaire 3 (colonne geom_ban3) de la table copro_occ_2020 et les g�om�tries TUP de la table tup_2019_occitanie
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban3_tup boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban3_tup = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban3_tup = TRUE, idtup = b.idtup FROM zz_copro_occ_2020.tup_2019_occitanie b 
WHERE a.idtup IS NULL AND ST_WITHIN(a.geom_ban3, b.geomtup) AND (banref_tup IS NULL OR ban1_tup IS NULL OR ban2_tup IS NULL);
-- 10 copro correspondantes

----- 6 180 TUP r�cup�r�es -----

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Recherche de correspondance entre le localisant du RNIC(colonne geom) plus ceux issus du g�ocodage (colonnes geom_ban_ref, geom_ban1, geom_ban2 et geom_ban3) --
-- et les g�om�tries TUP de la table tup_2019_occitanie (colonne geom) les plus proches du localisant du RNIC dans un rayon de 3m ---------------------------------
-- Ajouts et mises � jour des colonnes rnic_tup_3m, banref_tup_3m, ban1_tup_3m, ban2_tup_3m et ban3_tup_3m correspondants aux �tapes 9 � 13 -----------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

----- Etape 9: rapprochement entre le localisant RNIC (colonne geom) de la table copro_occ_2020 
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 3m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN rnic_tup_3m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET rnic_tup_3m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET rnic_tup_3m = TRUE, idtup = w.idtup FROM
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom, b.geomtup, 3) 
		    GROUP BY a.gid, b.idtup, a.geom, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid; 
-- 8 574 copro correspondantes

----- Etape 10: rapprochement entre le localisant issu du g�ocodage de l'adresse de r�f�rrence (colonne geom_ban_ref) de la table copro_occ_2020 
------ et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 3m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN banref_tup_3m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET banref_tup_3m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET banref_tup_3m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban_ref, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban_ref, b.geomtup, 3) 
		    GROUP BY a.gid, b.idtup, a.geom_ban_ref, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid; 
-- 279 copro correspondantes

----- Etape 11: rapprochement entre le localisant issu du g�ocodage de l'adresse compl�mentaire 1 (colonne geom_ban1) de la table copro_occ_2020
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 3m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban1_tup_3m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban1_tup_3m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban1_tup_3m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban1, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban1, b.geomtup, 3) 
		    GROUP BY a.gid, b.idtup, a.geom_ban1, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid AND banref_tup_3m IS NULL; 
-- 49 copro correspondantes

----- Etape 12: rapprochement entre le localisant issu du g�ocodage de l'adresse compl�mentaire 2 (colonne geom_ban2) de la table copro_occ_2020
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 3m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban2_tup_3m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban2_tup_3m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban2_tup_3m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban2, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban2, b.geomtup, 3) 
		    GROUP BY a.gid, b.idtup, a.geom_ban2, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid AND (banref_tup_3m IS NULL OR ban1_tup_3m IS NULL); 
-- 3 copro correspondantes

----- Etape 13: rapprochement entre le localisant issu du g�ocodage de l'adresse compl�mentaire 3 (colonne geom_ban3) de la table copro_occ_2020
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 3m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban3_tup_3m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban3_tup_3m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban3_tup_3m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban3, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban3, b.geomtup, 3) 
		    GROUP BY a.gid, b.idtup, a.geom_ban3, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid AND (banref_tup_3m IS NULL OR ban1_tup_3m IS NULL OR ban2_tup_3m IS NULL);
-- 2 copro correspondante

----- 8 907 TUP r�cup�r�es -----

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Recherche de correspondance entre le localisant du RNIC (colonne geom) plus ceux issus du g�ocodage (colonnes geom_ban_ref, geom_ban1, geom_ban2 et geom_ban3) --
-- et les g�om�tries TUP de la table tup_2019_occitanie (colonne geom) les plus proches du localisant du RNIC dans un rayon de 6m ----------------------------------
-- Ajouts et mises � jour des colonnes rnic_tup_6m, banref_tup_6m, ban1_tup_6m, ban2_tup_6m et ban3_tup_6m correspondants aux �tapes 14 � 18 ------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

----- Etape 14: rapprochement entre le localisant RNIC (colonne geom) de la table copro_occ_2020 
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 6m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN rnic_tup_6m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET rnic_tup_6m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET rnic_tup_6m = TRUE, idtup = w.idtup FROM
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom, b.geomtup, 6) 
		    GROUP BY a.gid, b.idtup, a.geom, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid; 
-- 713 copro correspondantes

----- Etape 15: rapprochement entre le localisant issu du g�ocodage de l'adresse de r�f�rrence (colonne geom_ban_ref) de la table copro_occ_2020 
------ et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 6m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN banref_tup_6m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET banref_tup_6m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET banref_tup_6m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban_ref, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban_ref, b.geomtup, 6) 
		    GROUP BY a.gid, b.idtup, a.geom_ban_ref, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid; 
-- 71 copro correspondantes

----- Etape 16: rapprochement entre le localisant issu du g�ocodage de l'adresse compl�mentaire 1 (colonne geom_ban1) de la table copro_occ_2020
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 6m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban1_tup_6m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban1_tup_6m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban1_tup_6m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban1, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban1, b.geomtup, 6) 
		    GROUP BY a.gid, b.idtup, a.geom_ban1, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid AND banref_tup_6m IS NULL; 
-- 12 copro correspondantes

----- Etape 17: rapprochement entre le localisant issu du g�ocodage de l'adresse compl�mentaire 2 (colonne geom_ban2) de la table copro_occ_2020
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 6m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban2_tup_6m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban2_tup_6m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban2_tup_6m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban2, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban2, b.geomtup, 6) 
		    GROUP BY a.gid, b.idtup, a.geom_ban2, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid AND (banref_tup_6m IS NULL OR ban1_tup_6m IS NULL); 
-- 1 copro correspondantes

----- Etape 18: rapprochement entre le localisant issu du g�ocodage de l'adresse compl�mentaire 3 (colonne geom_ban3) de la table copro_occ_2020
----- et la g�om�trie TUP de la table tup_2019_occitanie la plus proche dans un rayon de 6m
ALTER TABLE zz_copro_occ_2020.copro_occ_2020 ADD COLUMN ban3_tup_6m boolean;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban3_tup_6m = NULL;
UPDATE zz_copro_occ_2020.copro_occ_2020 a SET ban3_tup_6m = TRUE, idtup = w.idtup FROM 
(WITH foo AS (SELECT a.gid, b.idtup, ST_DISTANCE(a.geom_ban3, b.geomtup) AS distance FROM zz_copro_occ_2020.copro_occ_2020 a, zz_copro_occ_2020.tup_2019_occitanie b
		    WHERE a.idtup IS NULL AND ST_DWITHIN(a.geom_ban3, b.geomtup, 6) 
		    GROUP BY a.gid, b.idtup, a.geom_ban3, b.geomtup
		    ORDER BY a.gid)
SELECT DISTINCT ON (gid)
gid, idtup, distance FROM foo
ORDER BY gid, distance
) w
WHERE a.idtup IS NULL AND a.gid = w.gid AND (banref_tup_6m IS NULL OR ban1_tup_6m IS NULL OR ban2_tup_6m IS NULL);
-- 0 copro correspondante

----- 797 TUP r�cup�r�es -----

----------------------------------------------------------------------------------------------------------
----- Nombre de TUP r�cup�r�es via les 18 �tapes sur les 39 932 copropri�t�s existantes : 38 192 TUP -----
----- Ainsi, ce sont 1 740 copropri�t�s qui ne sont pas approch�es par ces diff�rents traitements --------
----------------------------------------------------------------------------------------------------------


/*================================================================================================================*/
/*  				ETAPE 4 : CREATION ET MISE A JOUR DES TABLES DE PASSAGE / TEMPORAIRES / D'INDICATEURS         */
/*                            AFIN DE CREER LA TABLE D'UNION DES TABLES RNIC ET TUP                               */
/*================================================================================================================*/

------------------------------------------------------------------------------------------------------------------------
----- Cr�ation d'une table r�gionale de parcelles � partir des tables d�partementales des parcelles Fichiers Fonciers --
----- constitu�es d'au moins un local de type 'APPARTEMENT' ou 'MAISON' ------------------------------------------------
----- afin d'approcher les copropri�t�s (une copropri�t� est constitu�e d'au moins un appartement ou une maison --------
------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS zz_copro_occ_2020.parcelles_2019_occitanie;
CREATE TABLE zz_copro_occ_2020.parcelles_2019_occitanie AS
SELECT * FROM ff_2019_dep.d09_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d11_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d12_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d30_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d31_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d32_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d34_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d46_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d48_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d65_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d65_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d81_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1
UNION
SELECT * FROM ff_2019_dep.d82_fftp_2019_pnb10_parcelle WHERE nlocmaison > 1 OR nlocappt > 1;


-- Ajout d'une colonne adress_ref et mise � jour de cette colonne afin d'avoir une adresse Fichiers Fonciers pour chaque parcelle 
-- La colonne adress_ref est la concat�nation des colonnes dnuvoi, dindic, ccconvo, dvoilib et idcomtxt 
ALTER TABLE zz_copro_occ_2020.parcelles_2019_occitanie ADD COLUMN adresse_ff character varying(254);
UPDATE zz_copro_occ_2020.parcelles_2019_occitanie 
SET adresse_ff = (COALESCE(LTRIM(dnuvoi, '0'),'')||COALESCE(dindic,'')||' '||COALESCE(cconvo,'')||' '||COALESCE(dvoilib,'')||' - '||UPPER(idcomtxt));

-- Cr�ation d'un index attributaire sur la colonne idpar (identifiant parcellaire )
CREATE INDEX zz_copro_occ_2020_parcelles_2019_occitanie_idpar_idx ON zz_copro_occ_2020.parcelles_2019_occitanie USING btree(idpar);


------------------------------------------------------------------------------------------------------------------
----- Cr�ation d'une table r�gionale de locaux � partir des tables d�partementales des locaux Fichiers Fonciers --
----- dont le type de local correspond soit � 'MAISON' (dteloc = '1'), soit � 'APPARTEMENT' (dteloc = '2') -------
----- afin d'approcher le nombre de pi�ces par copropri�t�s ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS zz_copro_occ_2020.loc_copro_2019_occitanie;
CREATE TABLE zz_copro_occ_2020.loc_copro_2019_occitanie AS
SELECT * FROM ff_2019_dep.d09_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2') 
UNION
SELECT * FROM ff_2019_dep.d11_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d12_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d30_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d31_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d32_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d34_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d46_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d48_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d65_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d66_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d81_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2')
UNION
SELECT * FROM ff_2019_dep.d82_fftp_2019_pb0010_local WHERE dteloc IN ('1', '2');

-- Cr�ation de 3 index attributaires sur les colonnes idpar (identifiant de parcelle), idlocal (identifiant du local) et idprocpte (identifiant du compte communal)
CREATE INDEX zz_copro_occ_2020_loc_copro_2019_occitanie_idpar_idx ON zz_copro_occ_2020.loc_copro_2019_occitanie USING btree(idpar);
CREATE INDEX zz_copro_occ_2020_loc_copro_2019_occitanie_idlocal_idx ON zz_copro_occ_2020.loc_copro_2019_occitanie USING btree(idlocal);
CREATE INDEX zz_copro_occ_2020_loc_copro_2019_occitanie_idprocpte_idx ON zz_copro_occ_2020.loc_copro_2019_occitanie USING btree (idprocpte);

--------------------------------------------------------------------------------------------------------
----- Cr�ation d'une table r�gionale (temporaire) de locaux selon une r�partition du nombre de pi�ces --
----- � partir de la table r�gionale de locaux cr��e pr�c�demment --------------------------------------
--------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS zz_copro_occ_2020.nbpieces_2019_tmp;
CREATE TABLE zz_copro_occ_2020.nbpieces_2019_tmp as
SELECT idlocal, idpar,
       COUNT(CASE WHEN npiece_p2 = 1 THEN '1' ELSE NULL END) AS nb_t1,
       COUNT(CASE WHEN npiece_p2 = 2 THEN '1' ELSE NULL END) AS nb_t2,
       COUNT(CASE WHEN npiece_p2 = 3 THEN '1' ELSE NULL END) AS nb_t3,
       COUNT(CASE WHEN npiece_p2 = 4 THEN '1' ELSE NULL END) AS nb_t4,
       COUNT(CASE WHEN npiece_p2 >= 5 THEN '1' ELSE NULL END) AS nb_t5plus
FROM zz_copro_occ_2020.loc_copro_2019_occitanie
GROUP BY idlocal, idpar, npiece_p2
ORDER BY idlocal,idpar;

-- Cr�ation d'un index attributaire sur la colonne idpar (identifiant de parcelle)
CREATE INDEX zz_copro_occ_2020_nbpieces_2019_tmp_idpar_idx ON zz_copro_occ_2020.nbpieces_2019_tmp USING btree(idpar);


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Ajout de 5 colonnes (nb_t1, nbt2, nbt3, nb_t4, nb_t5plus) � la table r�gionale des TUP Occitanie (tup_2019_occitanie) ----------------------------
-- correspondant aux nombres de pi�ces sur chacune des TUP, et mises � jour de ces 5 colonnes � partir de la table temporaire nbpieces_2019_tmp --
-----------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_t1 integer; -- nombre de 1 pi�ce
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_t2 integer; -- nombre de 2 pi�ces
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_t3 integer; -- nombre de 3 pi�ces
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_t4 integer; -- nombre de 4 pi�ces
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_t5plus integer; -- nombre de 5 pi�ces et plus

-- Mises � jour de ces 5 colonnes � partir de la table des locaux cr��e pr�c�demment (nbpieces_2019_tmp)
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_t1 = (SELECT SUM(b.nb_t1) FROM zz_copro_occ_2020.nbpieces_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_t2 = (SELECT SUM(b.nb_t2) FROM zz_copro_occ_2020.nbpieces_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_t3 = (SELECT SUM(b.nb_t3) FROM zz_copro_occ_2020.nbpieces_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_t4 = (SELECT SUM(b.nb_t4) FROM zz_copro_occ_2020.nbpieces_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_t5plus = (SELECT SUM(b.nb_t5plus) FROM zz_copro_occ_2020.nbpieces_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));


----------------------------------------------------------------------------------------------------------------------------------------------
----- Cr�ation d'une table r�gionale de parties d'�valuation � partir des tables d�partementales des parties d'�valuation Fichiers Fonciers --
----- afin d'approcher le classement cadastral de la PEV (Partie d'EValuation) Principale d'habitation ---------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS zz_copro_occ_2020.pev_copro_2019_occitanie;
CREATE TABLE zz_copro_occ_2020.pev_copro_2019_occitanie AS
SELECT * FROM ff_2019_dep.d09_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d11_fftp_2019_pb40_pevprincipale 
UNION
SELECT * FROM ff_2019_dep.d12_fftp_2019_pb40_pevprincipale 
UNION
SELECT * FROM ff_2019_dep.d30_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d31_fftp_2019_pb40_pevprincipale 
UNION
SELECT * FROM ff_2019_dep.d32_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d34_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d46_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d48_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d65_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d66_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d81_fftp_2019_pb40_pevprincipale
UNION
SELECT * FROM ff_2019_dep.d82_fftp_2019_pb40_pevprincipale;

-- Cr�ation de 3 index attributaires sur les colonnes idpar (identifiant de parcelle), idlocal (identifiant du local) et idpev (identifiant de la PEV)
CREATE INDEX zz_copro_occ_2020_pev_copro_2019_occitanie_idpar_idx ON zz_copro_occ_2020.pev_copro_2019_occitanie USING btree(idpar);
CREATE INDEX zz_copro_occ_2020_pev_copro_2019_occitanie_idlocal_idx ON zz_copro_occ_2020.pev_copro_2019_occitanie USING btree(idlocal);
CREATE INDEX zz_copro_occ_2020_pev_copro_2019_occitanie_idpev_idx ON zz_copro_occ_2020.pev_copro_2019_occitanie USING btree(idpev);

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ajout de la colonne cc � la table r�gionale tup_2019_occitanie correspondant au classement cadastral de chaque logement composant la copropri�t� ----------
-- et mise � jour de la colonne cc � partir de la colonne detent (�tat d'entretien de la pev principale d'habitation) de la table  pev_copro_2019_occitanie --
--------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN cc text[];
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET cc = (SELECT ARRAY_AGG(b.detent) FROM zz_copro_occ_2020.pev_copro_2019_occitanie b WHERE b.idpar = ANY(a.idpar_l));


----------------------------------------------------------------------------------------------
----- Cr�ation d'une table r�gionale (temporaire) de r�partition, pour chaque local, ---------
----- du nombre de r�sidences principales (RP) et de r�sidences secondaires (RS) -------------
----- � partir de la table r�gionale des locaux afin d'approcher les R�sidences Secondaires --
----------------------------------------------------------------------------------------------

-- Approche des R�sidences Secondaires
DROP TABLE IF EXISTS zz_copro_occ_2020.nb_rp_rs_2019_tmp;
CREATE TABLE zz_copro_occ_2020.nb_rs_rp_2019_tmp AS
SELECT idlocal, idpar, 
COUNT(CASE WHEN proba_rprs = 'RP' THEN '1' ELSE NULL END) AS nb_rp,
COUNT(CASE WHEN proba_rprs = 'RS' THEN '1' ELSE NULL END) AS nb_rs
FROM zz_copro_occ_2020.loc_copro_2019_occitanie
GROUP BY idlocal, idpar;

-- Cr�ation d'un index attributaire sur la colonne idpar (identifiant de parcelle)
CREATE INDEX zz_copro_occ_2020_nb_rp_rs_2019_tmp_idpar_idx ON zz_copro_occ_2020.nb_rs_rp_2019_tmp USING btree(idpar);


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ajout de la colonne nb_rs � la table r�gionale tup_2019_occitanie correspondant au nombre de R�sidences Secondaires sur chaque TUP ---------------------
-- et mise � jour de cette colonne � partir de la table r�gionale de r�partition du nombre de RP / RS (nb_rp_rs_2019_tmp) cr��e pr�c�demment --------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_rs integer; 
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_rs = (SELECT SUM(b.nb_rs) FROM zz_copro_occ_2020.nb_rs_rp_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));


-------------------------------------------------------------------------------------------------------
----- Cr�ation d'une table r�gionale (temporaire) de r�partition, pour chaque parcelle, ---------------
----- du nombre de logements occup�s par le propri�taire (PO) et du nombre de logements lou�s (LOUE) --
----- � partir de la table r�gionale des locaux afin les Propri�taires Occupants ----------------------
-------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS zz_copro_occ_2020.nb_po_loue_2019_tmp;
CREATE TABLE zz_copro_occ_2020.nb_po_loue_2019_tmp AS
SELECT idpar, 
COUNT(CASE WHEN ccthp = 'P' THEN '1' ELSE NULL END) AS nb_po,
COUNT(CASE WHEN ccthp = 'L' THEN '1' ELSE NULL END) AS nb_loue
FROM zz_copro_occ_2020.loc_copro_2019_occitanie
GROUP BY idpar;

-- Cr�ation d'un index attributaire sur la colonne idpar (identifiant de parcelle)
CREATE INDEX zz_copro_occ_2020_nb_po_loue_2019_tmp_idpar_idx ON zz_copro_occ_2020.nb_po_loue_2019_tmp USING btree(idpar);


--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ajout de 2 colonnes nb_po et nb_loue � la table r�gionale tup_2019_occitanie correspondant nombre de Propri�taires Occupants et logements lou�s sur chaque TUP --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_po integer; 
ALTER TABLE zz_copro_occ_2020.tup_2019_occitanie ADD COLUMN nb_loue integer; 
-- Mises � jour de ces 2 colonnes � partir de la table r�gionale de r�partition du nombre de PO/LOUE (nb_po_loue_2019_tmp) cr��e pr�c�demment
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_po = (SELECT SUM(b.nb_po) FROM zz_copro_occ_2020.nb_po_loue_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));
UPDATE zz_copro_occ_2020.tup_2019_occitanie a SET nb_loue = (SELECT SUM(b.nb_loue) FROM zz_copro_occ_2020.nb_po_loue_2019_tmp b WHERE b.idpar = ANY(a.idpar_l));



/*========================================================================================================*/
/*  			ETAPE 5 : CREATION DE LA TABLE D'UNION ENTRE LA TABLE DU RNIC ET LA TABLE DES TUP         */
/*                           OU ON NE GARDE QUE LES TUP POUVANT CORRESPONDRE A DES COPROPRIETES           */
/*                                AFIN DE CREER LA TABLE DES INDICATEURS A LA COPROPRIETE                 */
/*========================================================================================================*/

DROP TABLE IF EXISTS zz_copro_occ_2020.union_rnic_tup_2019;
CREATE TABLE zz_copro_occ_2020.union_rnic_tup_2019 AS
SELECT * FROM
(SELECT gid AS id1, epci, commune, num_immat, type_syndi, admin_prov, syndic_pro, repre_lega, 
		code_ape, com_rl, mandat, dfinmandat, nomusageco, adress_ref, ad_compl1, ad_compl2, 
		ad_compl3, nb_adr_com, insee_com, prefixe, section, num_parcel, insee_com1, prefixe1, 
		section1, num_parcel1, insee_com2, prefixe2, section2, num_parcel2, nb_parcell, geom_char,
		date_regl_, res_servic, syndic_coo, syndic_p_s, immat_p, nb_asl, nb_aful, nb_unions, nb_tot_lot, 
		nb_tot_hbc, nb_lot_hab, stationnem, nb_arret_s, nb_arret_p, nb_arret_e, mdt_ah_en_, ordo_caren, 
		exe_compta, deb_exe_co, fin_exe_co, dte_ag_cpt, charge_ope, charge_tr_, dette_four, dette_copr,
		nb_copro_3, mont_trava, employe_sy, p_constr, an_fin_con, a, b, c, d, e, f, g, non_determ, typchauffa, 
		chauf_urba, nrj_non_ur, nb_ascensc, ident_ign, geom as geom_rnic, geom_ban_ref, geom_ban1, geom_ban2, geom_ban3,
		idtup, idpar, idpar1, idpar2, idpar_tup, idpar1_tup, idpar2_tup, rnic_tup, banref_tup, ban1_tup, ban2_tup,
		ban3_tup, rnic_tup_3m, banref_tup_3m, ban1_tup_3m, ban2_tup_3m, ban3_tup_3m, rnic_tup_6m, banref_tup_6m, 
		ban1_tup_6m, ban2_tup_6m, ban3_tup_6m
  FROM zz_copro_occ_2020.copro_occ_2020) a
  FULL JOIN
  (SELECT id, geomtup, idtup, idprocpte, idprocpt_l, idcom, idcomtxt, ccodep, 
       typetup, npar, idpar_l, dcntpa, ctpdl, jannatmin, jannatmax, 
       jannatminh, jannatmaxh, nsuf, ssuf, cgrnumd, cgrnumdtxt, dcntarti, 
       dcntnaf, dcnt01, dcnt02, dcnt03, dcnt04, dcnt05, dcnt06, dcnt07, 
       dcnt08, dcnt09, dcnt10, dcnt11, dcnt12, dcnt13, nlocal, nlocmaison, 
       nlocappt, nloclog, nloccom, nloccomrdc, nloccomter, ncomtersd, 
       nloccomsec, nlocdep, nlocburx, tlocdomin, nbat, nlochab, nlogh, 
       npevph, stoth, stotdsueic, nloghvac, nloghmeu, nloghloue, nloghpp, 
       nloghautre, nloghnonh, nactvacant, nloghvac2a, nactvac2a, nloghvac5a, 
       nactvac5a, nmediocre, nloghlm, nloghlls, stotd, sprincp, ssecp, ssecncp, 
	   sparkp, sparkncp, slocal, nparcopro, ncp, catpro2, catpro2txt, catpro3, 
	   catpropro2, catproges2, locprop, locproptxt, split_uf, geomloc, nparloc,
	   nvecteur, ncontour, nb_t1, nb_t2, nb_t3, nb_t4, nb_t5plus, cc, nb_rs, nb_po, nb_loue
  FROM zz_copro_occ_2020.tup_2019_occitanie) b
  USING (idtup);


-- Suppression des TUP ne correspondant pas a priori � des copropri�t�s: le type de Propri�t�s Divis�es en Lots (colonne ctpdl) 
-- ne comprend pas les valeurs CL (Copropri�t�s en Lots), CV (Corporpi�t�s en Volume) et CLV (Copropri�t�s en Lots/Volumes)
DELETE FROM zz_copro_occ_2020.union_rnic_tup_2019 WHERE ctpdl IS NULL AND id1 IS NULL;
-- 201 125 lignes supprim�es
DELETE FROM zz_copro_occ_2020.union_rnic_tup_2019 WHERE ctpdl NOT IN ('CL', 'CV', 'CLV') AND id1 IS NULL;
-- 48 lignes (ou TUP) supprim�es de la table union_rnic_tup_2019

-----------------------------
----- 88 869 RNIC - TUP -----
-----------------------------

-- Cr�ation d'un index attributaire sur la colonne idtup (identifiant de la tup)
CREATE INDEX zz_copro_occ_2020_union_rnic_tup_2019_idtup_idx ON zz_copro_occ_2020.union_rnic_tup_2019 USING btree(idtup);


---------------------------------------------------------------------------------------------------------------------------------------
-- Ajout et mise � jour de la colonne adresse_ff dans la table union_rnic_tup_2019 ----------------------------------------------------
-- qui correspond � l'adresse Fichiers Fonciers, colonne d�j� cr��e dans la table r�gionale des parcelles (parcelles_2019_occitanie) --
---------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE zz_copro_occ_2020.union_rnic_tup_2019 ADD COLUMN adresse_ff character varying(254); 
UPDATE zz_copro_occ_2020.union_rnic_tup_2019 a SET adresse_ff = (SELECT b.adresse_ff FROM zz_copro_occ_2020.parcelles_2019_occitanie b WHERE b.idpar = ANY(a.idpar_l) LIMIT 1); 


--------------------------------------------------------------------------------------------------------------------------------------------------
-- Ajout d'une colonne source qui correspond � la source de la base de donn�es pour chaque enregistremenet de la table union_rnic_tup_2019 -------
-- Cette colonne source peut comporter 3 valeurs: 'rnic', 'tup' ou 'rnic_tup' --------------------------------------------------------------------
---------- la valeur 'rnic' signifie que les donn�es proviennent de la table du RNIC et qu'il n'y a pas de jointure pssible avec la table TUP ----
---------- la valeur 'tup' signifie que les donn�es proviennent de la table TUP et qu'il n'y a pas de jointure pssible avec la table du RNIC -----
---------- la valeur 'rnic_tup' signifie que les donn�es provienent des tables RNIC et TUP, et que la jointure entre ces 2 tables � pu se faire --
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ALTER TABLE zz_copro_occ_2020.union_rnic_tup_2019 DROP COLUMN source;
ALTER TABLE zz_copro_occ_2020.union_rnic_tup_2019 ADD COLUMN source character varying(8);

-- Mise � jour de la colonne source
UPDATE zz_copro_occ_2020.union_rnic_tup_2019 SET source = (SELECT
(CASE WHEN id1 IS NOT NULL AND id IS NULL THEN 'rnic'
      WHEN id1 IS NULL AND id IS NOT NULL THEN 'tup'
      WHEN id1 IS NOT NULL AND id IS NOT NULL THEN 'rnic_tup'
ELSE '' END))
WHERE idtup IS NOT NULL; 




/*================================================================================================================================*/
/*  			ETAPE 6 : IMPORT D'AUTRES BASES DE DONNEES AFIN DE RENSEIGNER LES TABLES INDICATEURS A LA COPROPRIETE             */
/*================================================================================================================================*/

-----------------------------------------------------------------------------------------------------------------------------------------
-- Import dans postgresql via QGIS (DB Manager - Bases de donn�es) de la table Base Permanente des Equipements ou BPE (base communale) --
-----------------------------------------------------------------------------------------------------------------------------------------

-- Typage de la colonne nb_equip (en entier)
ALTER TABLE zz_copro_occ_2020.bpe18_ensemble ALTER COLUMN nb_equip TYPE integer USING CAST(nb_equip AS integer);

-- Cr�ation d'une table communale Base Permanente des Equipements (BPE)
DROP TABLE IF EXISTS zz_copro_occ_2020.bpe18_com;
CREATE TABLE zz_copro_occ_2020.bpe18_com AS
SELECT num_reg, num_dep, code_insee, SUM(nb_equip) AS nb_equip FROM zz_copro_occ_2020.bpe18_ensemble
GROUP BY num_reg, num_dep, code_insee;

-- Cr�ation d'un index attributaire sur la colonne code_insee (code INSEE de la commune)
CREATE INDEX zz_copro_occ_2020_bpe18_com_code_insee_idx ON zz_copro_occ_2020.bpe18_com USING btree(code_insee);


--------------------------------------------------------------------------------------------------
-- Import dans postgresql via QGIS (DB Manager - Bases de donn�es) de la table des EPCI de 2020 --
--------------------------------------------------------------------------------------------------

-- Typage de la colonne siren_epci (en caract�res)
ALTER TABLE zz_copro_occ_2020.epcicom2020 ALTER COLUMN siren TYPE character varying USING CAST(siren AS character varying);




