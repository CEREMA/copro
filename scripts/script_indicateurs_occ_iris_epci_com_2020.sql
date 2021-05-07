/* ==================================================*/
/* SCRIPT CREE LE 29-10-2020                         */
/* CEREMA - DTER MED - DAT - GROUPE TERRITOIRES      */
/* ==================================================*/

-------------------------------------------------------
----- Création d'une table d'indicateurs à l'IRIS -----
-------------------------------------------------------
DROP TABLE IF EXISTS zz_copro_occ_2020.indicateurs_occ_2020_iris;
CREATE TABLE zz_copro_occ_2020.indicateurs_occ_2020_iris
(
gid SERIAL NOT NULL,
code_iris character varying (9),
nom_iris character varying(60),
tx_vac2ans_iris numeric(4,1),
tx_vac_iris numeric(4,1),
tx_po_iris numeric(4,1),
nb_copro_tour_iris integer,
nbventes3a_iris integer,
tx_ventelogt_iris numeric(5,2),
prixmed_m2_iris integer,
evolprix5a_iris numeric(6,2),
nb_copro_iris integer,
nb_copro_mtaille_iris integer,
nb_logts_neufs_iris integer, 
nb_lls_iris integer,
nb_lls_neuf_iris integer,
nb_hab integer,
geom geometry(geometry,2154),
CONSTRAINT indicateurs_occ_2020_iris_pkey PRIMARY KEY (gid)
)
WITH (OIDS=FALSE);

-- Création d'un index sur le code de l'IRIS
CREATE INDEX indicateurs_occ_2020_iris_code_iris_idx ON zz_copro_occ_2020.indicateurs_occ_2020_iris USING btree(code_iris);

-- Insertion des champs code_iris et nom_iris
INSERT INTO zz_copro_occ_2020.indicateurs_occ_2020_iris(code_iris, nom_iris)
(SELECT code_iris, nom_iris FROM public.iris 
WHERE SUBSTRING(insee_com,1,2) IN ('09', '11', '12', '30', '31', '32', '34', '46', '48', '65', '66', '81', '82'));

-- Mise à jour du champ tx_vac2ans_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET tx_vac2ans_iris = 
(SELECT SUM(nlogh*tx_vac2ans/100.0)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris);

-- Mise à jour du champ tx_vac_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET tx_vac_iris = 
(SELECT SUM(nb_vacant)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris);

-- Mise à jour du champ tx_po_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET tx_po_iris =
(SELECT SUM(nb_po)*1.0/SUM(nb_po+nb_loue)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris AND (nb_po+nb_loue)!=0);

-- Mise à jour du champ nb_copro_tour_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET nb_copro_tour_iris = 
(SELECT COUNT(CASE WHEN typedomin = 'coprotour' THEN '1' ELSE NULL END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris);

-- Mise à jour du champ nb_copro_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET nb_copro_iris = (SELECT COUNT(*) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris);

-- Mise à jour du champ nb_logts_neufs_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET nb_logts_neufs_iris = 
(SELECT SUM(CASE WHEN p_constr = 'APRES_2011' THEN nb_lot_hab
                 WHEN jannatminh >= '2011' THEN nlogh ELSE 0 END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris);

-- Mise à jour du champ nb_lls_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET nb_lls_iris = 
(SELECT SUM(nb_lls) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris);

-- Mise à jour du champ nb_lls_neuf_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET nb_lls_neuf_iris = 
(SELECT SUM(CASE WHEN jannatminh >= '2011' THEN nb_lls ELSE 0 END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_iris = b.code_iris);
				 
-- Mise à jour du champ geom
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET geom = (SELECT b.geom FROM public.iris b WHERE a.code_iris = b.code_iris);	

-- Mise à jour du champ nbventes3a_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET nbventes3a_iris = 
(SELECT nb_appart_seul FROM zz_copro_occ_2020.ind_l1_iris_2016_2018 b WHERE a.code_iris = b.pk::varchar AND b.nb_appart_seul >= 25);

-- Mise à jour du champ prixmed_m2_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET prixmed_m2_iris = 
(SELECT prix_euro_m2_median FROM zz_copro_occ_2020.ind_l1_iris_2016_2018 b WHERE a.code_iris = b.pk::varchar AND b.nb_appart_seul >= 25);

-- Mise à jour du champ tx_ventelogt_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET tx_ventelogt_iris = (SELECT nbventes3a_iris*1.0/nlogh*100 FROM
(SELECT SUM(nbventes3a) AS nbventes3a_iris, SUM(b.nlogh) AS nlogh FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b 
 WHERE a.code_iris = b.code_iris AND nbventes3a_iris >= 25) foo); 

-- Mise à jour du champ evolprix5a_iris
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_iris a SET evolprix5a_iris = (SELECT ((pmed_euro_m2_2017-pmed_euro_m2_2013)*1.0/pmed_euro_m2_2013*100) 
--FROM zz_copro_occ_2020.evol_iris_2013_2017 b WHERE a.code_iris = b.pk);	 


-----------------------------------------------------------
----- Création d'une table d'indicateurs à la commune -----
-----------------------------------------------------------
DROP TABLE IF EXISTS zz_copro_occ_2020.indicateurs_occ_2020_com;
CREATE TABLE zz_copro_occ_2020.indicateurs_occ_2020_com
(
gid SERIAL NOT NULL,
code_insee character varying (5),
nom_com character varying(80),
tx_vac2ans_com numeric(4,1),
tx_vac_com numeric(4,1),
tx_po_com numeric(4,1),
nb_copro_tour_com integer,
nbventes3a_com integer,
tx_ventelogt_com numeric(5,2),
prixmed_m2_com integer,
evolprix5a_com numeric(7,2),
nb_copro_com integer,
nb_copro_mtaille_com integer,
nb_logts_neufs_com integer, 
nb_lls_com integer,
nb_lls_neuf_com integer,
nb_hab integer,
evol_pop_10ans_com numeric(5,2),
tx_lls_hab_com numeric(4,1),
tx_100hab_equip_com numeric(4,1),
type_com character varying(10),
littorale boolean,
montagne boolean,
tourist boolean,
geom geometry(geometry,2154),
CONSTRAINT indicateurs_occ_2020_com_pkey PRIMARY KEY (gid)
)
WITH (OIDS=FALSE);


-- Mise à jour du champ pop_2017 afin de mettre à jour le champ evol_pop_10ans
ALTER TABLE zz_copro_occ_2020.population_ensemble_2017 ADD COLUMN pop_2007 integer;
UPDATE zz_copro_occ_2020.population_2007 a SET pop_2007  = 0 WHERE pop_2007 IS NULL;
UPDATE zz_copro_occ_2020.population_ensemble_2017 a SET pop_2007  = (SELECT SUM(b.pop_2007) FROM zz_copro_occ_2020.population_2007 b WHERE a.insee_com = b.code_insee);


-- Création d'un index sur le code de la commune
CREATE INDEX indicateurs_occ_2020_com_code_insee_idx ON zz_copro_occ_2020.indicateurs_occ_2020_com USING btree(code_insee);

-- Insertion des valeurs issues de la table des indicateurs sur les communes entre 2015 et 2017
INSERT INTO zz_copro_occ_2020.indicateurs_occ_2020_com(code_insee, nom_com, geom)
(SELECT insee_com, nom, geom FROM adm.commune_2019 WHERE insee_reg = '76');

-- Mise à jour du champ geom
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET geom = (SELECT b.geom FROM adm.commune_2019 b WHERE b.insee_reg = '76' AND a.code_insee = b.insee_com);

-- Mise à jour du champ tx_vac2ans_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tx_vac2ans_com = 
(SELECT SUM(nlogh*tx_vac2ans/100.0)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com);

-- Mise à jour du champ tx_vac_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tx_vac_com = 
(SELECT SUM(nb_vacant)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com);

-- Mise à jour du champ nbventes3a_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET nbventes3a_com = 
(SELECT nb_appart_seul FROM zz_copro_occ_2020.ind_l1_appt_occ_2016_2018 b WHERE b.nb_appart_seul >= 25 AND a.code_insee = b.pk::varchar);

-- Mise à jour du champ prixmed_m2_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET prixmed_m2_com = 
(SELECT prix_euro_m2_median FROM zz_copro_occ_2020.ind_l1_appt_occ_2016_2018 b WHERE b.nb_appart_seul >= 25 AND a.code_insee = b.pk::varchar);

-- Mise à jour du champ tx_ventelogt_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tx_ventelogt_com = (SELECT nbventes3a_com*1.0/nlogh*100 FROM
(SELECT SUM(nbventes3a) AS nbventes3a_com, SUM(b.nlogh) AS nlogh FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b 
 WHERE a.code_insee = b.insee_com AND nbventes3a_com >= 25) foo); 
 
-- Mise à jour du champ evolprix5a_com
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET evolprix5a_com = (SELECT ((pmed_euro_m2_2017-pmed_euro_m2_2013)*1.0/pmed_euro_m2_2013*100) 
--FROM zz_copro_occ_2020.evol_commune_2013_2017 b WHERE a.code_insee = b.code_insee);	 

-- Mise à jour du champ tx_po_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tx_po_com =
(SELECT SUM(nb_po)*1.0/SUM(nb_po+nb_loue)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com AND (nb_po+nb_loue)!=0);

-- Mise à jour du champ nb_copro_tour_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET nb_copro_tour_com = 
(SELECT COUNT(CASE WHEN typedomin = 'coprotour' THEN '1' ELSE NULL END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com);

-- Mise à jour du champ nb_copro_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET nb_copro_com = (SELECT COUNT(*) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com);

-- Mise à jour du champ nb_logts_neufs_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET nb_logts_neufs_com = 
(SELECT SUM(CASE WHEN p_constr = 'APRES_2011' THEN nb_lot_hab
                 WHEN jannatminh >= '2011' THEN nlogh ELSE 0 END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com);

-- Mise à jour du champ nb_lls_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET nb_lls_com = 
(SELECT SUM(nb_lls) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com);

-- Mise à jour du champ nb_lls_neuf_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET nb_lls_neuf_com = 
(SELECT SUM(CASE WHEN jannatminh >= '2011' THEN nb_lls ELSE 0 END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.code_insee = b.insee_com);

-- Mise à jour du champ nb_hab
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET nb_hab = (SELECT pmun_2020 FROM zz_copro_occ_2020.epcicom2020 b WHERE a.code_insee = b.insee);

-- Mise à jour du champ evol_pop_10ans_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET evol_pop_10ans_com = (SELECT (pop_mun_2017-pop_2007)*1.0/pop_2007*100 
FROM zz_copro_occ_2020.population_ensemble_2017 b WHERE b.pop_2007 IS NOT NULL AND a.code_insee = b.insee_com);

-- Mise à jour du champ tx_lls_hab_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tx_lls_hab_com = (nb_lls_com*1.0/nb_hab*100);

-- Mise à jour du champ tx_100hab_equip_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tx_100hab_equip_com = (SELECT b.nb_equip*1.0/a.nb_hab*100 FROM zz_copro_occ_2020.bpe18_com b WHERE a.code_insee = b.code_insee);

-- Mise à jour du champ littorale
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET littorale = (SELECT (CASE WHEN b.classement IS NOT NULL THEN TRUE ELSE FALSE END) FROM zz_copro_occ_2020.communes_littorales_2019 b WHERE a.code_insee = b.code_insee);
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET littorale = FALSE WHERE littorale IS NULL;

-- Mise à jour du champ montagne
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET montagne = (SELECT (CASE WHEN b.classement = 'M' THEN TRUE ELSE FALSE END) FROM zz_copro_occ_2020.communes_montagne b WHERE a.code_insee = b.code_insee);

-- Mise à jour du champ tourist
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tourist = (SELECT (CASE WHEN b.type = 'Commune touristique' THEN TRUE ELSE FALSE END) 
FROM zz_copro_occ_2020.communes_touristique_2019 b WHERE a.code_insee = b.insee_com);
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET tourist = FALSE WHERE tourist IS NULL;

-- Mise à jour du champ type_com
ALTER TABLE zz_copro_occ_2020.indicateurs_occ_2020_com ALTER COLUMN type_com TYPE text[] using cast(type_com AS text[]);
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_com a SET type_com = (SELECT ARRAY_AGG((CASE WHEN tourist IS TRUE THEN 'com_tour_loi' ELSE '' END)||','||
																				(CASE WHEN littorale IS TRUE THEN 'com_littoral' ELSE '' END)||','||
																				(CASE WHEN montagne IS TRUE THEN 'com_montagne' ELSE '' END))
FROM zz_copro_occ_2020.indicateurs_occ_2020_com b WHERE a.code_insee = b.code_insee);


-------------------------------------------------------
----- Création d'une table d'indicateurs à l'EPCI -----
-------------------------------------------------------
DROP TABLE IF EXISTS zz_copro_occ_2020.indicateurs_occ_2020_epci;
CREATE TABLE zz_copro_occ_2020.indicateurs_occ_2020_epci
(
gid SERIAL NOT NULL,
siren_epci character varying (9),
nom_epci character varying(60),
tx_vac2ans_epci numeric(4,1),
tx_vac_epci numeric(4,1),
tx_po_epci numeric(4,1),
nb_copro_tour_epci integer,
nbventes3a_epci integer,
tx_ventelogt_epci numeric(5,2),
prixmed_m2_epci integer,
evolprix5a_epci numeric(7,2),
nb_copro_epci integer,
nb_copro_mtaille_epci integer,
nb_logts_neufs_epci integer,
nb_lls_epci integer,
nb_lls_neuf_epci integer,
nb_hab integer,
evol_pop_10ans_epci numeric(5,2),
tx_lls_hab_epci numeric(4,1),
tx_100hab_equip_epci numeric(4,1),
geom geometry(geometry,2154),
CONSTRAINT indicateurs_occ_2020_epci_pkey PRIMARY KEY (gid)
)
WITH (OIDS=FALSE);

-- Création d'un index sur le code de l'EPCI
CREATE INDEX indicateurs_occ_2020_epci_siren_epci_idx ON zz_copro_occ_2020.indicateurs_occ_2020_epci USING btree(siren_epci);

-- Insertion des valeurs issues de la table des indicateurs sur les EPCI entre 2013 et 2017
INSERT INTO zz_copro_occ_2020.indicateurs_occ_2020_epci(siren_epci, nom_epci)
(SELECT siren, raison_sociale FROM zz_copro_occ_2020.epcicom2020 
WHERE dept IN ('09', '11', '12', '30', '31', '32', '34', '46', '48', '65', '66', '81', '82'));

-- Mise à jour du champ tx_vac2ans_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET tx_vac2ans_epci = 
(SELECT SUM(nlogh*tx_vac2ans/100.0)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci);

-- Mise à jour du champ tx_vac_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET tx_vac_epci = 
(SELECT SUM(nb_vacant)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci);

-- Mise à jour du champ nb_ventes3a_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET nbventes3a_epci = (SELECT SUM(b.nbventes3a_com) FROM zz_copro_occ_2020.indicateurs_occ_2020_com b, zz_copro_occ_2020.epcicom2020 c 
WHERE b.code_insee = c.insee AND a.siren_epci = c.siren); 

-- Mise à jour du champ tx_ventelogt_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET tx_ventelogt_epci = (SELECT nbventes3a_epci*1.0/nlogh*100 FROM
(SELECT SUM(nbventes3a) AS nbventes3a_epci, SUM(b.nlogh) AS nlogh FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b 
 WHERE a.siren_epci = b.siren_epci AND nbventes3a_epci >= 25) foo); 

-- Mise à jour du champ prixmed_m2_epci (est ce utle et pertinent de le mettre à jour?)
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET prixmed_m2_epci = (SELECT prix_euro_m2_median::integer 
--FROM zz_copro_occ_2020.ind_l1_epci_2015_2017 b WHERE prix_euro_m2_median != '' AND a.siren_epci = b.pk);

-- Mise à jour du champ evolprix5a_epci
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET evolprix5a_epci = (SELECT SUM(pmed_euro_m2_2017-pmed_euro_m2_2013)*1.0/SUM(pmed_euro_m2_2013)*100 
--FROM zz_copro_occ_2020.evol_commune_2013_2017 b, zz_copro_occ_2020.epcicom2020 c WHERE b.code_insee = c.insee AND a.siren_epci = c.siren);	 

-- Mise à jour du champ tx_po_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET tx_po_epci =
(SELECT SUM(nb_po)*1.0/SUM(nb_po+nb_loue)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci AND (nb_po+nb_loue)!=0);

-- Mise à jour du champ nb_copro_tour_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET nb_copro_tour_epci = 
(SELECT COUNT(CASE WHEN typedomin = 'coprotour' THEN '1' ELSE NULL END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci);

-- Mise à jour du champ nb_copro_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET nb_copro_epci = (SELECT COUNT(*) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci);

-- Mise à jour du champ nb_logts_neufs_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET nb_logts_neufs_epci = 
(SELECT SUM(CASE WHEN p_constr = 'APRES_2011' THEN nb_lot_hab
                 WHEN jannatminh >= '2011' THEN nlogh ELSE 0 END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci);

-- Mise à jour du champ nb_lls_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET nb_lls_epci = 
(SELECT SUM(nb_lls) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci);

-- Mise à jour du champ nb_lls_neuf_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET nb_lls_neuf_epci = 
(SELECT SUM(CASE WHEN jannatminh >= '2011' THEN nb_lls ELSE 0 END) FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.siren_epci = b.siren_epci);

-- Mise à jour du champ nb_hab
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET nb_hab = (SELECT b.total_pop_mun FROM zz_copro_occ_2020.epcicom2020 b WHERE a.siren_epci = b.siren LIMIT 1);

-- Mise à jour du champ evol_pop_10ans_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET evol_pop_10ans_epci = (SELECT SUM(pop_mun_2017-pop_2007)*1.0/SUM(pop_2007)*100 
FROM zz_copro_occ_2020.population_ensemble_2017 b, zz_copro_occ_2020.epcicom2020 c WHERE b.pop_2007 IS NOT NULL AND b.insee_com = c.insee AND a.siren_epci = c.siren);

-- Mise à jour du champ tx_lls_hab_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET tx_lls_hab_epci = (nb_lls_epci*1.0/nb_hab*100);

-- Mise à jour du champ tx_100hab_equip_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET tx_100hab_equip_epci = (SELECT SUM(b.nb_equip)*1.0/a.nb_hab*100 
FROM zz_copro_occ_2020.bpe18_com b, zz_copro_occ_2020.epcicom2020 c WHERE b.code_insee = c.insee AND a.siren_epci = c.siren);

-- Mise à jour du champ geom
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_epci a SET geom = (SELECT b.the_geom FROM zz_copro_occ_2020.epci_occ_2020 b WHERE a.siren_epci = b.siren::character varying);


-------------------------------------------------------------
----- Création d'une table d'indicateurs au département -----
-------------------------------------------------------------
DROP TABLE IF EXISTS zz_copro_occ_2020.indicateurs_occ_2020_dep;
CREATE TABLE zz_copro_occ_2020.indicateurs_occ_2020_dep
(
gid SERIAL NOT NULL,
num_dep character varying (9),
nom_dep character varying(60),
tx_vac2ans_dep numeric(4,1),
tx_vac_dep numeric(4,1),
tx_po_dep numeric(4,1),
nb_copro_tour_dep integer,
--nbventes3a_dep integer,
--tx_ventelogt_dep numeric(5,2),
--prixmed_m2_dep integer,
--evolprix5a_dep numeric(7,2),
nb_copro_dep integer,
nb_copro_mtaille_dep integer,
nb_logts_neufs_dep integer, -- jannatminh
nb_lls_dep integer,
nb_lls_neuf_dep integer,
nb_hab integer,
evol_pop_10ans_dep numeric(5,2),
tx_lls_hab_dep numeric(4,1),
tx_100hab_equip_dep numeric(4,1),
geom geometry(geometry,2154),
CONSTRAINT indicateurs_occ_2020_dep_pkey PRIMARY KEY (gid)
)
WITH (OIDS=FALSE);

-- Création d'un index sur le code de département
CREATE INDEX indicateurs_occ_2020_dep_num_dep_idx ON zz_copro_occ_2020.indicateurs_occ_2020_dep USING btree(num_dep);

-- Insertion des valeurs issues de la table des régions
INSERT INTO zz_copro_occ_2020.indicateurs_occ_2020_dep(num_dep, nom_dep)
(SELECT insee_dep, nom FROM adm.save_dep_19 WHERE insee_reg = '76' GROUP BY insee_dep, nom);

-- Mise à jour du champ geom
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET geom = (SELECT b.the_geom FROM adm.deps b WHERE a.num_dep = b.num_dep);

-- Mise à jour du champ tx_vac2ans_com
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET tx_vac2ans_dep = 
(SELECT SUM(nlogh*tx_vac2ans/100.0)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.num_dep = SUBSTRING(b.insee_com,1,2));

-- Mise à jour du champ tx_vac_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET tx_vac_dep = 
(SELECT SUM(nb_vacant)*1.0/SUM(nlogh)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.num_dep = SUBSTRING(b.insee_com,1,2));

-- Mise à jour du champ nbventes3a_dep
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET nbventes3a_dep = (SELECT SUM(nbventes3a_com) FROM zz_copro_occ_2020.indicateurs_occ_2020_com b WHERE a.num_dep = SUBSTRING(b.code_insee,1,2));

-- Mise à jour du champ prixmed_m2_dep
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET prixmed_m2_dep = (SELECT prix_euro_m2_median::integer FROM zz_copro_occ_2020.ind_l1_dep_occ_2015_2017 b WHERE a.num_dep = b.pk);

-- Mise à jour du champ tx_ventelogt_dep
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET tx_ventelogt_dep = (SELECT nbventes3a_dep*1.0/nlogh*100 FROM
--(SELECT SUM(nbventes3a) AS nbventes3a_dep, SUM(b.nlogh) AS nlogh FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b 
 --WHERE a.num_dep = SUBSTRING(b.insee_com,1,2) AND nbventes3a_dep >= 25) foo); 

-- Mise à jour du champ evolprix5a_dep
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET evolprix5a_dep = (SELECT SUM(pmed_euro_m2_2017-pmed_euro_m2_2013)*1.0/SUM(pmed_euro_m2_2013)*100 
--FROM zz_copro_occ_2020.evol_commune_2013_2017 b WHERE a.num_dep = SUBSTRING(b.code_insee,1,2));	 

-- Mise à jour du champ tx_po_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET tx_po_dep =
(SELECT SUM(nb_po)*1.0/SUM(nb_po+nb_loue)*100 FROM zz_copro_occ_2020.indicateurs_occ_2020_copro b WHERE a.num_dep = SUBSTRING(b.insee_com,1,2) AND (nb_po+nb_loue)!=0);

-- Mise à jour du champ nb_copro_tour_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET nb_copro_tour_dep = 
(SELECT SUM(nb_copro_tour_com) FROM zz_copro_occ_2020.indicateurs_occ_2020_com b WHERE a.num_dep = SUBSTRING(b.code_insee,1,2));

-- Mise à jour du champ nb_copro_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET nb_copro_dep = (SELECT SUM(nb_copro_com) FROM zz_copro_occ_2020.indicateurs_occ_2020_com b WHERE a.num_dep = SUBSTRING(b.code_insee,1,2));

-- Mise à jour du champ nb_logts_neufs_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET nb_logts_neufs_dep = 
(SELECT SUM(nb_logts_neufs_com) FROM zz_copro_occ_2020.indicateurs_occ_2020_com b WHERE a.num_dep = SUBSTRING(b.code_insee,1,2));

-- Mise à jour du champ nb_lls_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET nb_lls_dep = 
(SELECT SUM(nb_lls_com) FROM zz_copro_occ_2020.indicateurs_occ_2020_com b WHERE a.num_dep = SUBSTRING(b.code_insee,1,2));

-- Mise à jour du champ nb_lls_neuf_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET nb_lls_neuf_dep = 
(SELECT SUM(nb_lls_neuf_com) FROM zz_copro_occ_2020.indicateurs_occ_2020_com b WHERE a.num_dep = SUBSTRING(b.code_insee,1,2));

-- Mise à jour du champ nb_hab
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET evol_pop_10ans_dep = (SELECT SUM(pop_mun_2017-pop_2007)*1.0/SUM(pop_2007)*100 
FROM zz_copro_occ_2020.population_ensemble_2017 b WHERE b.pop_2007 IS NOT NULL AND a.num_dep = SUBSTRING(b.insee_com,1,2));


-- Mise à jour du champ evol_pop_10ans_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET evol_pop_10ans_dep = (SELECT SUM(pop_2016-pop_2006)*1.0/SUM(pop_2006)*100 
FROM zz_copro_occ_2020.pop_2006 b WHERE b.pop_2006 IS NOT NULL AND a.num_dep = SUBSTRING(b.cog_2016,1,2));

-- Mise à jour du champ tx_lls_hab_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET tx_lls_hab_dep = (nb_lls_dep*1.0/nb_hab*100);

-- Mise à jour du champ tx_100hab_equip_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_dep a SET tx_100hab_equip_dep = (SELECT SUM(b.nb_equip)*1.0/a.nb_hab*100 FROM zz_copro_occ_2020.bpe18_com b WHERE a.num_dep = b.num_dep);





















