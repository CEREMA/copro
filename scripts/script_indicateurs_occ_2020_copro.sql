DROP TABLE IF EXISTS zz_copro_occ_2020.indicateurs_occ_2020_copro;
CREATE TABLE zz_copro_occ_2020.indicateurs_occ_2020_copro
(
gid SERIAL NOT NULL,
idtup character varying(20),
source character varying(10),
nom_usage character varying(254),
nom_dep character varying(50),
siren_epci character varying(10),
nom_epci character varying(100),
insee_com character varying(5),
nom_commune character varying(45),
code_iris character varying (9),
nom_iris character varying(60),
adresse_ref character varying(254),
visu_adres character varying(254),
num_immat character varying (9),
nbat integer,
nb_tot_lot integer,
nb_lot_hab integer,
tx_lot_hab numeric(4,1),
nlocal integer, 
nlogh integer, 
nloccom integer,
tx_nlogh numeric(4,1),
tx_nloccom numeric(6,1),
exclus_anah boolean,
p_constr character varying(254),
jannatminh integer,
dpe_bat text[],
a integer,
b integer,
c integer,
d integer,
e integer,
f integer,
g integer,
non_deter integer,
nb_t1 integer,
nb_t2 integer,
nb_t3 integer,
nb_t4 integer,
nb_t5plus integer,
stationnement integer,
detent text[],
chauffage character varying(20),
chauf_urba character varying(20),
nrj_non_ur character varying(20),
nb_ascensc integer,
nb_rp integer,
nb_rs integer,
nb_vacant integer,
nb_vac2ans integer,
nb_vac5ans integer,
tx_rs numeric(4,1),
tx_vac2ans numeric(4,1),
nb_po integer,
nb_loue integer,
tx_po numeric(4,1),
typedomin character varying(10),
copro_tour boolean,
copromixte boolean,
nb_lls integer,
nbventes3a integer,
tx_ventelogt numeric(6,2),
prix_m2 integer,
evolprix5a numeric(5,2),
qpv character varying(100),
opah_pig character varying(100),
popac_voc character varying(100),
rhi_ori character varying(100),
dette_copr numeric,
dette_four numeric,
charge_ope numeric,
charge_tr numeric,
tx_impayes numeric(10,2),
evol_tx_imp numeric(5,2),
nb_copro_3 integer,
nb_arret_s integer,
nb_arret_p integer,
nb_arret_e integer,
mdt_ah_en_ character varying(3),
ordo_caren character varying(20),
type_syndi character varying(15),
admin_prov character varying(10),
syndic_pro character varying(20),
repre_lega character varying(254),
geom geometry(Point,2154),
CONSTRAINT indicateurs_occ_2020_copro_pkey PRIMARY KEY (gid)
)
WITH (
  OIDS=FALSE
);

-- Création d'index
CREATE INDEX indicateurs_occ_2020_copro_idtup_idx ON zz_copro_occ_2020.indicateurs_occ_2020_copro USING btree(idtup);
CREATE INDEX indicateurs_occ_2020_copro_code_iris_idx ON zz_copro_occ_2020.indicateurs_occ_2020_copro USING btree(code_iris);
CREATE INDEX indicateurs_occ_2020_copro_insee_com_idx ON zz_copro_occ_2020.indicateurs_occ_2020_copro USING btree(insee_com);

-- Insertion des valeurs issues de la table union_rnic_tup_2019
INSERT INTO zz_copro_occ_2020.indicateurs_occ_2020_copro(
            idtup, source, nom_usage, insee_com, adresse_ref, num_immat, nbat, nb_tot_lot, nb_lot_hab, nlocal, nlogh, nloccom, 
			p_constr, jannatminh, a, b, c, d, e, f, g, non_deter, nb_t1, nb_t2, nb_t3, nb_t4, nb_t5plus, stationnement, detent, chauffage, 
			chauf_urba, nrj_non_ur, nb_ascensc, nb_rs, nb_vacant, nb_vac2ans, nb_vac5ans, nb_po, nb_loue, nb_lls, dette_copr, dette_four, charge_ope, 
			charge_tr,	nb_copro_3, nb_arret_s, nb_arret_p, nb_arret_e, mdt_ah_en_, ordo_caren, type_syndi, admin_prov, syndic_pro, repre_lega, geom)
(SELECT     idtup, source, nomusageco, (CASE WHEN commune IS NOT NULL THEN commune ELSE idcom END), adresse_ff, num_immat, 
            nbat, nb_tot_lot, nb_lot_hab, nlocal, nlogh::integer, nloccom::integer, p_constr, jannatminh::integer, a, b, c, d, e, f, g, non_determ, 
			nb_t1, nb_t2, nb_t3, nb_t4, nb_t5plus, stationnem, cc, typchauffa, chauf_urba, nrj_non_ur, nb_ascensc, nb_rs, nloghvac, nloghvac2a, 
			nloghvac5a, nb_po, nb_loue, nloghlls, dette_copr, dette_four, charge_ope, charge_tr_, nb_copro_3, nb_arret_s, nb_arret_p, nb_arret_e, mdt_ah_en_, 
			ordo_caren, type_syndi, admin_prov, syndic_pro, repre_lega, geom_rnic
FROM zz_copro_occ_2020.union_rnic_tup_2019);

-- Mise à jour du champ geom
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET geom = (CASE WHEN geom IS NULL THEN (SELECT st_geomfromewkt(b.geomloc) FROM zz_copro_occ_2020.tup_2019_occitanie b WHERE a.idtup = b.idtup) ELSE a.geom END);

-- Mise à jour du champ nom_commune
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET nom_commune = b.idcomtxt FROM zz_copro_occ_2020.union_rnic_tup_2019 b where a.insee_com = b.idcom;
-- Mise à jour du champ nom_dep
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET nom_dep = SUBSTRING(insee_com,1,2);
-- Mise à jour du champ siren_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET siren_epci = siren FROM zz_copro_occ_2020.epcicom2020 WHERE siren_epci IS NULL AND insee_com = insee;
-- Mise à jour du champ nom_epci
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET nom_epci = raison_sociale FROM zz_copro_occ_2020.epcicom2020 WHERE nom_epci IS NULL AND siren_epci = siren::character varying;
-- Mise à jour du champ code_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET code_iris = b.code_iris FROM public.iris b WHERE ST_WITHIN(a.geom, b.geom) AND a.insee_com = b.insee_com;
-- Mise à jour du champ nom_iris
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET nom_iris = b.nom_iris FROM public.iris b WHERE a.code_iris = b.code_iris;
-- Mise à jour du champ adresse_ref
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET adresse_ref = (CASE WHEN a.adresse_ref IS NULL THEN (SELECT UPPER(b.adress_ref) 
FROM zz_copro_occ_2020.copro_occ_2020 b WHERE a.idtup = b.idtup LIMIT 1) ELSE a.adresse_ref END);
-- Mise à jour du champ tx_lot_hab
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET tx_lot_hab = (nb_lot_hab*1.0/nb_tot_lot)*100;
-- Mise à jour du champ tx_nlogh
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET tx_nlogh = (nlogh*1.0/nlocal)*100;
-- Mise à jour du champ tx_nloccom
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET tx_nloccom = (CASE WHEN nloccom !=0 THEN (nloccom*1.0/nlogh)*100 ELSE 0 END);
-- Mise à jour du champ tx_impayes
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET tx_impayes = dette_four*1.0/(charge_ope + charge_tr)*100.0
WHERE charge_ope !=0 OR charge_tr !=0;
-- Mise à jour du champ exclus_anah
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro SET exclus_anah = 
(CASE WHEN nb_lot_hab > 200 AND tx_impayes BETWEEN 8 AND 15 THEN FALSE 
      WHEN nb_lot_hab <= 200 AND tx_impayes BETWEEN 8 AND 25 THEN FALSE ELSE TRUE END);
-- Mise à jour du champ classement cadastral
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET detent = (SELECT b.cc FROM zz_copro_occ_2020.tup_2019_occitanie b WHERE a.idtup = b.idtup);
-- Mise à jour du champ rp
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET nb_rp = (CASE WHEN (nlogh - (nb_rs + nb_vacant)) < 0 THEN 0 ELSE nlogh - (nb_rs + nb_vacant) END);
-- Mise à jour du champ tx_rs
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET tx_rs = nb_rs*1.0/nlogh*100.0;
-- Mise à jour du champ tx_vac2ans
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET tx_vac2ans = nb_vac2ans*1.0/nlogh*100.0;
-- Mise à jour du champ tx_po
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET tx_po = nb_po*1.0/(nb_po+nb_loue)*100.0 WHERE ((nb_po+nb_loue))!=0;
-- Mise à jour du champ typedomin
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET typedomin = (CASE WHEN tx_rs > 50 THEN 'coprotour' ELSE NULL END);
-- Mise à jour du champ nb_lls
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET nb_lls = (SELECT b.nloghlls FROM zz_copro_occ_2020.tup_2019_occitanie b WHERE a.idtup = b.idtup);
-- Mise à jour du champ copromixte
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET copromixte = (CASE WHEN nb_lls > 0 THEN TRUE ELSE FALSE END);
-- Mise à jour du champ nbventes3a
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET nbventes3a = b.nbventes3a FROM zz_copro_occ_2020.indl1_occ_2020_copro b WHERE a.gid = b.gid;
-- Mise à jour du champ tx_ventelogt
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET tx_ventelogt = nbventes3a*1.0/nlogh*100;
-- Mise à jour du champ prix_m2
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET prix_m2 = b.prix_m2 FROM zz_copro_occ_2020.indl1_occ_2020_copro b WHERE a.gid = b.gid;
-- Mise à jour du champ evol_tx_imp
--UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET evol_tx_imp = ;


-- Ajout et mise à jour du champ nmediocre (confort médiocre des locaux d'habitation)
ALTER TABLE zz_copro_occ_2020.indicateurs_occ_2020_copro ADD COLUMN nmediocre bigint;
-- Mise à jour du champ qpv
UPDATE zz_copro_occ_2020.indicateurs_occ_2020_copro a SET nmediocre = b.nmediocre FROM zz_copro_occ_2020.union_rnic_tup_2019 b WHERE a.idtup = b.idtup;






















