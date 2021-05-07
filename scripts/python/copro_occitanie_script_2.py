import sys
import os
import psycopg2
import numpy as np
import pandas as pd
import folium
from folium import plugins
from folium.plugins import Search
from folium.plugins import HeatMap
from folium.plugins import FastMarkerCluster
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
plt.style.use('ggplot')
import json
import shutil
import module_recherche


# FONCTION DE CONSTRUCTION DE LA BASE DE DONNÉES INITIALE
def constructionDf():

    # Connexion au serveur sql
    conn = psycopg2.connect(
        host="localhost", port=5432, database="application_web",
        user='postgres', password='postgres')

    """
    Cerema Med :
    conn = psycopg2.connect(
        host=os.environ['POSTGRES_HOST'], port=5432, database=os.environ['POSTGRES_DB'],
        user=os.environ['POSTGRES_USER'], password=os.environ['POSTGRES_PASSWORD'])
    """

    # Importation des variables des bases de données
    copro = pd.read_sql(
        "select id, latitude, longitude, adresse_re, lib_dep, lib_epci, lib_com,\
        datemin, datemax, datenr, nblot, nblothab, typecopro, comtour, comsru, comlitt, commont,\
        nom_usage, nom_commun, num_immat, source, dateconst, typedomin, ref_cadast,\
        exclusanahoui, exclusanahnon, etatbon, etatassezb, etatpassab, etatmedio, etatmauv, etatind,\
        chaufind, chaufcol, chaufmix, chaufsans, chaufso, chaufurb, chaufnonurb, chaufnr,\
        txrpinf50, txrpsup50, txrsinf50, txrssup50, txvacinf5, txvac57, txvacsup7, txvac2ansinf7, txvac2anssup7, txvac5ansinf7, txvac5anssup7, txpoinf50, txposup50,\
        exclus_ana, etatent, chauffage, chauf_urba, tx_rp, tx_rs, tx_vac, tx_vac2ans, tx_vac5ans, tx_po\
        from copro_occ.copro2020_occ", conn)
    
    patrimoineHLM = pd.read_sql(
        "select id, rs, source, numvoie, nomvoie, nb_lls, latitude, longitude, lib_dep, lib_epci, lib_com from copro_occ.rpls2019_occ_grouped",
        conn)
    
    monopropriete = pd.read_sql(
        "select id, source, num_voirie, libelle_voie, nom_commune, nb_appt, latitude, longitude, lib_dep, lib_epci, lib_com from copro_occ.monopro2019_occ", conn)
    
    conn.close()
    
    bdd = [copro, patrimoineHLM, monopropriete]

    return bdd


# FONCTION DE FILTRAGE DE LA BASE DE DONNÉES A PARTIR DES SELECTIONS DANS LE MENU DE GAUCHE DE L'APPLICATION (bouton GENERER)
def filtres(data, perimetreChoix, etablissementChoix, ref_cadastrChoix, num_immatChoix, dateminChoix, datemaxChoix, datenrChoix, nblotminChoix, nblotmaxChoix, nblothabminChoix, nblothabmaxChoix, typecoproChoix, typecomChoix, exclusanahouiChoix, exclusanahnonChoix, etatbonChoix, etatassezbChoix, etatpassabChoix, etatmedioChoix, etatmauvChoix, etatindChoix, chaufindChoix, chaufcolChoix, chaufmixChoix, chaufsansChoix, chaufsoChoix, chaufurbChoix, chaufnonurbChoix, chaufnrChoix, txrpinf50Choix, txrpsup50Choix, txrsinf50Choix, txrssup50Choix, txvacinf5Choix, txvac57Choix, txvacsup7Choix, txvac2ansinf7Choix, txvac2anssup7Choix, txvac5ansinf7Choix, txvac5anssup7Choix, txpoinf50Choix, txposup50Choix):

    copro = data[0]
    hlm = data[1]
    monop = data[2]

    if perimetreChoix == "tous":
        copro = copro
        hlm = hlm
        monop = monop

    if perimetreChoix == "DEPARTEMENT":
        if etablissementChoix == "tous":
            copro = copro
            hlm = hlm
            monop = monop            
        else:
            copro = copro[copro['lib_dep'] == etablissementChoix]
            hlm = hlm[hlm['lib_dep'] == etablissementChoix]
            monop = monop[monop['lib_dep'] == etablissementChoix]

    if perimetreChoix == "EPCI":
        if etablissementChoix == "tous":
            copro = copro
            hlm = hlm
            monop = monop
        else:
            copro = copro[copro['lib_epci'] == etablissementChoix]
            hlm = hlm[hlm['lib_epci'] == etablissementChoix]
            monop = monop[monop['lib_epci'] == etablissementChoix]

    if perimetreChoix == "COMMUNE":
        if etablissementChoix == "tous":
            copro = copro
            hlm = hlm
            monop = monop
        else:
            copro = copro[copro['lib_com'] == etablissementChoix]
            hlm = hlm[hlm['lib_com'] == etablissementChoix]
            monop = monop[monop['lib_com'] == etablissementChoix]

    if ref_cadastrChoix != "tous":
        copro = copro[copro['ref_cadast'] == ref_cadastrChoix]

    if num_immatChoix != "tous":
        copro = copro[copro['num_immat'] == num_immatChoix]

    copro = copro[copro['datemin'] >= int(dateminChoix)]
    copro = copro[copro['datemax'] <= int(datemaxChoix)]

    if datenrChoix == 0:
        copro = copro[copro['datenr'] == datenrChoix]

    copro = copro[copro['nblot'] >= int(nblotminChoix)]
    copro = copro[copro['nblot'] <= int(nblotmaxChoix)]

    copro = copro[copro['nblothab'] >= int(nblothabminChoix)]
    copro = copro[copro['nblothab'] <= int(nblothabmaxChoix)]

    if typecoproChoix != "tous":
        copro = copro[copro['typedomin'] == typecoproChoix]

    if typecomChoix != "tous":
        if typecomChoix == "touristique":
            copro = copro[copro['comtour'] == 1]
        if typecomChoix == "sru":
            copro = copro[copro['comsru'] == 1]
        if typecomChoix == "littoral":
            copro = copro[copro['comlitt'] == 1]
        if typecomChoix == "montagne":
            copro = copro[copro['commont'] == 1]

    if exclusanahouiChoix == 0:
        copro = copro[copro['exclusanahoui'] == 0]

    if exclusanahnonChoix == 0:
        copro = copro[copro['exclusanahnon'] == 0]

    if etatbonChoix == 0:
        copro = copro[copro['etatbon'] == 0]

    if etatassezbChoix == 0:
        copro = copro[copro['etatassezb'] == 0]

    if etatpassabChoix == 0:
        copro = copro[copro['etatpassab'] == 0]

    if etatmedioChoix == 0:
        copro = copro[copro['etatmedio'] == 0]

    if etatmauvChoix == 0:
        copro = copro[copro['etatmauv'] == 0]

    if etatindChoix == 0:
        copro = copro[copro['etatind'] == 0]

    if chaufindChoix == 0:
        copro = copro[copro['chaufind'] == 0]

    if chaufcolChoix == 0:
        copro = copro[copro['chaufcol'] == 0]

    if chaufmixChoix == 0:
        copro = copro[copro['chaufmix'] == 0]

    if chaufsansChoix == 0:
        copro = copro[copro['chaufsans'] == 0]

    if chaufsoChoix == 0:
        copro = copro[copro['chaufso'] == 0]

    if chaufurbChoix == 0:
        copro = copro[copro['chaufurb'] == 0]

    if chaufnonurbChoix == 0:
        copro = copro[copro['chaufnonurb'] == 0]

    if chaufnrChoix == 0:
        copro = copro[copro['chaufnr'] == 0]

    if txrpinf50Choix == 0:
        copro = copro[copro['txrpinf50'] == 0]

    if txrpsup50Choix == 0:
        copro = copro[copro['txrpsup50'] == 0]

    if txrsinf50Choix == 0:
        copro = copro[copro['txrsinf50'] == 0]

    if txrssup50Choix == 0:
        copro = copro[copro['txrssup50'] == 0]

    if txvacinf5Choix == 0:
        copro = copro[copro['txvacinf5'] == 0]

    if txvac57Choix == 0:
        copro = copro[copro['txvac57'] == 0]

    if txvacsup7Choix == 0:
        copro = copro[copro['txvacsup7'] == 0]

    if txvac2ansinf7Choix == 0:
        copro = copro[copro['txvac2ansinf7'] == 0]

    if txvac2anssup7Choix == 0:
        copro = copro[copro['txvac2anssup7'] == 0]

    if txvac5ansinf7Choix == 0:
        copro = copro[copro['txvac5ansinf7'] == 0]

    if txvac5anssup7Choix == 0:
        copro = copro[copro['txvac5anssup7'] == 0]

    if txpoinf50Choix == 0:
        copro = copro[copro['txpoinf50'] == 0]

    if txposup50Choix == 0:
        copro = copro[copro['txposup50'] == 0]

    bdd = [copro, hlm, monop]

    return bdd


# FONCTION D'APPLICATION DES FILTRES
def initialisation(perimetreChoix, etablissementChoix, ref_cadastrChoix, num_immatChoix, dateminChoix, datemaxChoix, datenrChoix, nblotminChoix, nblotmaxChoix, nblothabminChoix, nblothabmaxChoix, typecoproChoix, typecomChoix, exclusanahouiChoix, exclusanahnonChoix, etatbonChoix, etatassezbChoix, etatpassabChoix, etatmedioChoix, etatmauvChoix, etatindChoix, chaufindChoix, chaufcolChoix, chaufmixChoix, chaufsansChoix, chaufsoChoix, chaufurbChoix, chaufnonurbChoix, chaufnrChoix, txrpinf50Choix, txrpsup50Choix, txrsinf50Choix, txrssup50Choix, txvacinf5Choix, txvac57Choix, txvacsup7Choix, txvac2ansinf7Choix, txvac2anssup7Choix, txvac5ansinf7Choix, txvac5anssup7Choix, txpoinf50Choix, txposup50Choix):

    print("Recuperation de la base de donnees - 1/3")

    # les variables initiales
    bdd = constructionDf()

    # Application des filtres
    print("Preparation de la base de donnees - 2/3")

    data = filtres(
        bdd, perimetreChoix, etablissementChoix, ref_cadastrChoix, num_immatChoix, dateminChoix, datemaxChoix, datenrChoix, nblotminChoix, nblotmaxChoix, nblothabminChoix, nblothabmaxChoix, typecoproChoix, typecomChoix, exclusanahouiChoix, exclusanahnonChoix, etatbonChoix, etatassezbChoix, etatpassabChoix, etatmedioChoix, etatmauvChoix, etatindChoix, chaufindChoix, chaufcolChoix, chaufmixChoix, chaufsansChoix, chaufsoChoix, chaufurbChoix, chaufnonurbChoix, chaufnrChoix, txrpinf50Choix, txrpsup50Choix, txrsinf50Choix, txrssup50Choix, txvacinf5Choix, txvac57Choix, txvacsup7Choix, txvac2ansinf7Choix, txvac2anssup7Choix, txvac5ansinf7Choix, txvac5anssup7Choix, txpoinf50Choix, txposup50Choix)

    copro = data[0]
    hlm = data[1]
    monop = data[2]
    
    bdd = [copro, hlm, monop]
    
    return data


# FONCTION DE CREATION DE LA CARTE ET TABLEAU DE DONNEES
def exportCarte(bdd, repertoire):

    # Base copropriété
    copro = bdd[0]
    copro['color'] = 'blue'

    dcarte_copro = copro[['id', 'longitude', 'latitude', 'color', 'nom_usage', 'adresse_re', 'source', 'nom_commun', 'ref_cadast', 'num_immat', 'dateconst', 'nblot', 'nblothab', 'typecopro', 'exclus_ana', 'etatent', 'chauffage', 'chauf_urba', 'tx_rp', 'tx_rs', 'tx_vac', 'tx_vac2ans', 'tx_vac5ans', 'tx_po']].fillna(0) # fillna remplace les vides par 0. Important : le dataframe ne doit pas contenir de valeur vide sinon le symbole n'est pas généré
    dcarte_copro = dcarte_copro[dcarte_copro['latitude'] > 0] # Important : suppression des coordonnées nulles
    
    col = dcarte_copro.apply (
        lambda row : ('<hr><center><big><b>Copropriété</b></big><br>Source : {1}</center><hr>\
            - Nom d’usage : {2}<br/>\
            - Adresse : {3}<br/>\
            - Réf. cadastrale : {4}<br/>\
            - N° RNIC : {5}<br/><br/>\
            <center><form action="#" method="post" target="_blank"><input type="button" value="Fiche copropriété" class="bouton3" onclick="javascript:main.fiche_copro({0});"><input type="hidden" name="id" value="{0}"></form>\
            <a href="http://maps.google.com/maps?q=&layer=c&cbll={6},{7}" target="_blank"><input type="button" value="Google Street View" class="bouton3"></a>\
            </center>'.format(
                str(row['id']), # on affiche des valeurs alphanumériques
                str(row['source']),
                str(row['nom_usage']),
                str(row['adresse_re']),
                str(row['ref_cadast']),
                str(row['num_immat']),
                str(row['latitude']),
                str(row['longitude']))),
            axis = 1)
      
    dcarte_copro['names'] = col

    try:
        # Base patrimoine hlm => si pas de données avec les filtres sélectionnés on passe
        hlm = bdd[1]
        hlm['color'] = 'purple'
        
        dcarte_hlm = hlm.fillna(0) # fillna remplace les vides par 0. Important : le dataframe ne doit pas contenir de valeur vide sinon le symbole n'est pas généré
        dcarte_hlm = dcarte_hlm[dcarte_hlm['latitude'] > 0] # Important : suppression des coordonnées nulles
       
        col = dcarte_hlm.apply(
            lambda row : ('<hr><center><big>Bailleur : <b>{1}</b></big><br>Source : {2}</center><hr>\
                - Adresse : {3} {4}<br/>\
                - Commune : {5}<br/>\
                - Nb logements sociaux : {6}<br/><br>\
                <center><form action="#" method="post" target="_blank"><input type="button" value="Fiche parc social" class="bouton3" onclick="javascript:main.fiche_lls({0});"><input type="hidden" name="id" value="{0}"></form>\
                <a href="http://maps.google.com/maps?q=&layer=c&cbll={7},{8}" target="_blank"><input type="button" value="Google Street View" class="bouton3"></a>\
                </center>'.format(
            str(row['id']), # on affiche des valeurs alphanumériques
            str(row['rs']),
            str(row['source']),
            str(row['numvoie']),
            str(row['nomvoie']),
            str(row['lib_com']),
            str(row['nb_lls']),
            str(row['latitude']),
            str(row['longitude']))),
            axis = 1)
        
        dcarte_hlm['names'] = col
    except:
        pass

    try:
        # Base monopropriété => si pas de données avec les filtres sélectionnés on passe
        monop = bdd[2]
        monop['color'] = 'green'

        dcarte_mono = monop.fillna(0) # fillna remplace les vides par 0. Important : le dataframe ne doit pas contenir de valeur vide sinon le symbole n'est pas généré
        dcarte_mono = dcarte_mono[dcarte_mono['latitude'] > 0] # Important : suppression des coordonnées nulles

        col = dcarte_mono.apply (
            lambda row : ('<hr><center><big><b>Monopropriété</b></big><br>Source : {1}</center><hr>\
                - Adresse : {2} {3}<br/>\
                - Commune : {4}<br/>\
                - Nb appartements : {5}<br/><br>\
                <center><form action="#" method="post" target="_blank"><input type="button" value="Fiche monopropriété" class="bouton3" onclick="javascript:main.fiche_monopro({0});"><input type="hidden" name="id" value="{0}"></form>\
                <a href="http://maps.google.com/maps?q=&layer=c&cbll={6},{7}" target="_blank"><input type="button" value="Google Street View" class="bouton3"></a>\
                </center>'.format(
            str(row['id']), # on affiche des valeurs alphanumériques
            str(row['source']),
            str(row['num_voirie']),
            str(row['libelle_voie']),
            str(row['nom_commune']),
            str(row['nb_appt']),
            str(row['latitude']),
            str(row['longitude']))),
            axis = 1)
        
        dcarte_mono['names'] = col
    except:
        pass

    # Création de la carte avec paramètres d'affichage
    macarte = folium.Map(
        location=[dcarte_copro['latitude'].mean(),
        dcarte_copro['longitude'].mean()],
        zoom_start=12)

    # Ajout de fond de plan
    folium.TileLayer('openstreetmap').add_to(macarte)

    # Création des symboles graphiques à la carte
    callback = """\
        function (row) {
            var icon, marker;
            icon = L.AwesomeMarkers.icon({
                icon: "home", markerColor: row[2]});
            marker = L.marker(new L.LatLng(row[0], row[1]));
            marker.setIcon(icon);
            marker.bindPopup(row[3]);
        return marker;
        };
    """
    
    macarte.add_child(
        FastMarkerCluster(
            dcarte_copro[['latitude', 'longitude', 'color', 'names']].values.tolist(),
            callback=callback, name="Copropriétés", show=True))
    
    try:
        macarte.add_child(
            FastMarkerCluster(
                dcarte_hlm[['latitude', 'longitude', 'color', 'names']].values.tolist(),
                callback=callback, name="Patrimoine des bailleurs", show=False))      
    except:
        pass

    try:
        macarte.add_child(
            FastMarkerCluster(
                dcarte_mono[['latitude', 'longitude', 'color', 'names']].values.tolist(),
                callback=callback, name="Monopropriétés", show=False))      
    except:
        pass

    # Carte de chaleur (Répartition des copropriétés)
    HeatMap(dcarte_copro[dcarte_copro.latitude.notnull()][
        ['latitude', 'longitude']],
        name="Répartition des copropriétés", show=False).add_to(macarte)

    # Création des calques de la carte
    style_function_dep = lambda feature: dict(
        fillColor='#6c431b',
        color='#6c431b',
        fillOpacity=0,            
        weight=2.5,
        opacity=1)

    style_function_epci = lambda feature: dict(
        fillColor='#6c431b',
        color='#6c431b',
        fillOpacity=0,            
        weight=1,
        opacity=1)

    """
    style_function_atc = lambda feature: dict(
        fillColor='#B944BA',
        color='#883589',
        fillOpacity=0.5,            
        weight=1,
        opacity=1)
    """

    style_function_qpv = lambda feature: dict(
        fillColor='#e51919',
        color='#921e1e',
        fillOpacity=0.2,            
        weight=1,
        opacity=1)

    style_function_litt = lambda feature: dict(
        fillColor='#397AC3',
        color='#397AC3',
        fillOpacity=0.2,            
        weight=1,
        opacity=1)

    style_function_mont = lambda feature: dict(
        fillColor='#6ACF59',
        color='#248015',
        fillOpacity=0.2,            
        weight=1,
        opacity=1)

    style_function_opah = lambda feature: dict(
        fillColor='#FFB400',
        color='#FFB400',
        fillOpacity=0.2,            
        weight=1,
        opacity=1)

    style_function_pig = lambda feature: dict(
        fillColor='#EC4EB1',
        color='#EC4EB1',
        fillOpacity=0.2,            
        weight=1,
        opacity=1)

    folium.GeoJson(
        json.load(open(repertoire_json + 'departement_occ.json',
            encoding='utf-8')),
        style_function=style_function_dep,
        name='Département', show=True).add_to(macarte)

    folium.GeoJson(
        json.load(open(repertoire_json + 'epci_occ.json',
            encoding='utf-8')),
        style_function=style_function_epci,
        name='EPCI', show=False).add_to(macarte)

    """
    folium.GeoJson(
        json.load(open(repertoire_json + 'atc_occ.json',
            encoding='utf-8')),
        style_function=style_function_atc,
        name='Arrêts de Transport Collectif', show=False).add_to(macarte)
    """

    folium.GeoJson(
        json.load(open(repertoire_json + 'qpv_occ.json',
            encoding='utf-8')),
        style_function=style_function_qpv,
        name='QPV', show=False).add_to(macarte)

    folium.GeoJson(
        json.load(open(repertoire_json + 'litt_occ.json',
            encoding='utf-8')),
        style_function=style_function_litt,
        name='Commune loi littoral', show=False).add_to(macarte)

    folium.GeoJson(
        json.load(open(repertoire_json + 'mont_occ.json',
            encoding='utf-8')),
        style_function=style_function_mont,
        name='Commune loi montagne', show=False).add_to(macarte)

    folium.GeoJson(
        json.load(open(repertoire_json + 'opah_occ.json',
            encoding='utf-8')),
        style_function=style_function_opah,
        name='OPAH', show=False).add_to(macarte)

    folium.GeoJson(
        json.load(open(repertoire_json + 'pig_occ.json',
            encoding='utf-8')),
        style_function=style_function_pig,
        name='PIG', show=False).add_to(macarte)


    # Affichage du Panneau de controle des couches
    folium.LayerControl(collapsed=False).add_to(macarte)

    # Ajout du bouton Mode plein écran
    plugins.Fullscreen(
        position='topleft',
        title='Mode plein écran',
        title_cancel='Quitter le mode plein écran',
        force_separate_button=True).add_to(macarte)

    # La méthode save() génère une carte.html visible dans un navigateur web
    fichier_carte = repertoire + 'carte.html'

    macarte.save(fichier_carte)

    # Ajout d'un bouton de recherche géographique
    module_recherche.geocodeFichier(fichier_carte)

    # Création de tableau de données (dataframe) à exporter
    dataframe_provisoire = dcarte_copro[['nom_usage', 'adresse_re', 'source', 'nom_commun', 'ref_cadast', 'num_immat', 'dateconst', 'nblot', 'nblothab', 'typecopro', 'exclus_ana', 'etatent', 'chauffage', 'chauf_urba', 'tx_rp', 'tx_rs', 'tx_vac', 'tx_vac2ans', 'tx_vac5ans', 'tx_po', 'latitude', 'longitude']] # sélection des colonnes à exporter
    dataframe_export = dataframe_provisoire.copy() # copie du dataframe précédent avant modification (sinon problème)
    dataframe_export.rename(columns={
        'nom_usage': 'Nom d’usage de la copropriété',
        'adresse_re': 'Adresse de référence',
        'source': 'Source',
        'nom_commun': 'Commune',
        'ref_cadast': 'Réf. cadastrale',
        'num_immat': 'Numéro RNIC',
        'dateconst': 'Année de construction',
        'nblot': 'Nombre de lots',
        'nblothab': 'Nombre de lots d’habitation',
        'typecopro': 'Copropriété touristique',
        'exclus_ana': 'Exclu des aides ANAH',
        'etatent': 'État d''entretien',
        'chauffage': 'Type de chauffage',
        'chauf_urba': 'Chauffage urbain/non urbain',
        'tx_rp': 'Taux de résidences principales',
        'tx_rs': 'Taux de résidences secondaires',
        'tx_vac': 'Taux de vacance',
        'tx_vac2ans': 'Taux de vacance de +2ans',
        'tx_vac5ans': 'Taux de vacance de +5ans',
        'tx_po': 'Taux de propriétaires occupants',
        'longitude': 'Longitude',
        'latitude': 'Latitude'},
        inplace=True) # renommage des colonnes

    dataframe_export.reset_index(drop = True, inplace = True) # réinitialisation de la colonne index
    dataframe_export.index = dataframe_export.index+1 # nouvel index commençant à 1 plutôt que 0

    # Exporter un tableau vers un fichier excel
    writer = pd.ExcelWriter(repertoire + 'tableau.xlsx', engine='xlsxwriter') # Création du fichier tableur

    dataframe_export.to_excel(writer, sheet_name='Copropriété', startrow=1, header=False) # Création d'une feuille avec possibilité de modification des entêtes de colonnes

    workbook  = writer.book # variable tableau
    worksheet = writer.sheets['Copropriété'] # variable feuille

    header_format = workbook.add_format({'color': 'white', 'bold': True, 'text_wrap': True, 'align': 'center', 'valign': 'vcenter', 'fg_color': '#4F5764', 'border': 1}) # Format des entêtes de colonnes
    cell_format1 = workbook.add_format({'border': 1}) # Format de cellule : bordure
    cell_format2 = workbook.add_format({'align': 'center', 'border': 1}) # Format de cellule : texte centré, bordure
    cell_format3 = workbook.add_format({'align': 'left', 'border': 1}) # Format de cellule : bordure

    for col_num, value in enumerate(dataframe_export.columns.values):
        worksheet.write(0, col_num + 1, value, header_format) # Application du format des entêtes de colonnes

    worksheet.freeze_panes(1, 0) # Figer la première ligne
    worksheet.autofilter('A1:Q1') # Autofiltre
    worksheet.set_row(0, 45) # Hauteur de la première ligne
    worksheet.write('A1', 'Index', header_format) # Texte à mettre en cellule A1 (idem : worksheet.write(0, 0, 'Index', header_format2)
    worksheet.set_column('A:A', 8, cell_format1) # Largeur de la première colonne
    worksheet.set_column('B:C', 25, cell_format3) # Largeur des colonnes suivantes
    worksheet.set_column('D:W', 20, cell_format2) # Largeur des colonnes suivantes

    writer.save() # Sauvegarde du classeur


# FONCTION D'EXPORTATION DE LA CARTE HTML
def calculs(data, repertoire):

    print("Traitement de la carte - 3/3")
    
    try:
        exportCarte(data, repertoire)
        print("Operation terminee avec succes")
    except:
        print("Il y a eu un probleme")
        pass


# CORPS PRINCIPAL DU PROGRAMME
if __name__ == '__main__':

    # répertoires et fichiers utilises
    repertoire = 'C:/wamp64/www/copro_occ/webroot/temp/'
    repertoire_json = 'C:/wamp64/www/copro_occ/scripts/json/'
    repertoire_pasderesultat = 'C:/wamp64/www/copro_occ/scripts/pasderesultat/'

    """
    Cerema Med :
    repertoire = '/var/www/copro_occ/temp/'
    repertoire_json = '/home/sii/scripts/COPRO_OCC/json/'
    repertoire_pasderesultat = '/home/sii/scripts/COPRO_OCC/pasderesultat/'
    """

    # variables d'entrées correspondant aux filtres, possibilité de les stocker en dur pour test en local
    user_serveur = str(sys.argv[1]) # ne sert pas
    mdp_user = str(sys.argv[2]) # ne sert pas
    perimetreChoix = str(sys.argv[3])
    etablissementChoix = str(sys.argv[4])
    ref_cadastrChoix = str(sys.argv[5])
    num_immatChoix = str(sys.argv[6])
    dateminChoix =  int(sys.argv[7])
    datemaxChoix =  int(sys.argv[8])
    datenrChoix =  int(sys.argv[9])
    nblotminChoix = int(sys.argv[10])
    nblotmaxChoix = int(sys.argv[11])
    nblothabminChoix = int(sys.argv[12])
    nblothabmaxChoix = int(sys.argv[13])
    typecoproChoix = str(sys.argv[14])
    typecomChoix = str(sys.argv[15])
    exclusanahouiChoix = int(sys.argv[16])
    exclusanahnonChoix = int(sys.argv[17])
    etatbonChoix = int(sys.argv[18])
    etatassezbChoix = int(sys.argv[19])
    etatpassabChoix = int(sys.argv[20])
    etatmauvChoix = int(sys.argv[21])
    etatmedioChoix = int(sys.argv[22])
    etatindChoix = int(sys.argv[23])
    chaufindChoix = int(sys.argv[24])
    chaufcolChoix = int(sys.argv[25])
    chaufmixChoix = int(sys.argv[26])
    chaufsansChoix = int(sys.argv[27])
    chaufsoChoix = int(sys.argv[28])
    chaufurbChoix = int(sys.argv[29])
    chaufnonurbChoix = int(sys.argv[30])
    chaufnrChoix = int(sys.argv[31])
    txrpinf50Choix = int(sys.argv[32])
    txrpsup50Choix = int(sys.argv[33])
    txrsinf50Choix = int(sys.argv[34])
    txrssup50Choix = int(sys.argv[35])
    txvacinf5Choix = int(sys.argv[36])
    txvac57Choix = int(sys.argv[37])
    txvacsup7Choix = int(sys.argv[38])
    txvac2ansinf7Choix = int(sys.argv[39])
    txvac2anssup7Choix = int(sys.argv[40])
    txvac5ansinf7Choix = int(sys.argv[41])
    txvac5anssup7Choix = int(sys.argv[42])
    txpoinf50Choix = int(sys.argv[43])
    txposup50Choix = int(sys.argv[44])

    # création de la base de données
    data = initialisation(perimetreChoix, etablissementChoix, ref_cadastrChoix, num_immatChoix, dateminChoix, datemaxChoix, datenrChoix, nblotminChoix, nblotmaxChoix, nblothabminChoix, nblothabmaxChoix, typecoproChoix, typecomChoix, exclusanahouiChoix, exclusanahnonChoix, etatbonChoix, etatassezbChoix, etatpassabChoix, etatmedioChoix, etatmauvChoix, etatindChoix, chaufindChoix, chaufcolChoix, chaufmixChoix, chaufsansChoix, chaufsoChoix, chaufurbChoix, chaufnonurbChoix, chaufnrChoix, txrpinf50Choix, txrpsup50Choix, txrsinf50Choix, txrssup50Choix, txvacinf5Choix, txvac57Choix, txvacsup7Choix, txvac2ansinf7Choix, txvac2anssup7Choix, txvac5ansinf7Choix, txvac5anssup7Choix, txpoinf50Choix, txposup50Choix)
    
    # lancement des calculs
    if len(data[0]) > 0:
        calculs(data, repertoire)
    else:
        print("Il n'y a pas de valeur.")
        # copie des fichiers carte et tableau de substitution qui indique un message d'erreur lorsqu'il n'y a pas de carte disponible avec les filtres sélectionnés
        shutil.copy(repertoire_pasderesultat + 'carte.html', repertoire)
        shutil.copy(repertoire_pasderesultat + 'tableau.xlsx', repertoire)
