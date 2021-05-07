# -*- coding: utf8 -*-
"""
Cerema Med => ajouter après la 1ère ligne :
#!/home/sii/scripts/COPRO_OCC/bin/python
"""	

import sys
import psycopg2
import pandas as pd
import json


# FONCTION DE TRI DE LISTE
def triListe(liste):
    try:
        liste.remove(None)
    except:
        pass
    return liste.sort()

# FONCTION CONSTRUCTION DU DICTIONNAIRE
def constructionDictionnaire(liste):
    triListe(liste)
    listeItem = []
    for chaqueItem in liste:
        listeItem.append({"name": chaqueItem})
    return listeItem

# FONCTION DE CRÉATION DU MENUJSON ENVOYÉ DANS L'APPLICATION POUR PRÉREMPLIR LES MENUS DE GAUCHE
def constructionJson(user):

    # Connexion du serveur sql
    conn = psycopg2.connect(
        host="localhost", port=5432, database="application_web",
        user='postgres', password='postgres')
    """
    Cerema Med :
    conn = psycopg2.connect(
        host=os.environ['POSTGRES_HOST'], port=5432, database=os.environ['POSTGRES_DB'],
        user=os.environ['POSTGRES_USER'], password=os.environ['POSTGRES_PASSWORD'])
    """	

    # Création de la base de données (dataframe) pour préremplir les filtres du menu de gauche
    where_sql = str(inventaire[user])

    df = pd.read_sql(
        "select id, lib_dep, lib_epci, lib_com from\
        copro_occ.copro2020_occ\
        where {}".format(where_sql), conn)

    conn.close()
    #print(df)

    # Création des filtres préremplis du menu de gauche en fonction de l'utilisateur
    listeChoix = {
       "DEPARTEMENT": constructionDictionnaire(
            list(df['lib_dep'].unique())),
        "EPCI": constructionDictionnaire(
            list(df['lib_epci'].unique())),
        "COMMUNE": constructionDictionnaire(
            list(df['lib_com'].unique()))
    }

    # Création du menujson en fonction de l'utilisateur
    if mdp_user == verificationLogin[user]:
        menuJson = json.dumps(listeChoix, ensure_ascii=True, indent=4)
    else:
        menuJson = {}

    return menuJson


# CORPS PRINCIPAL DU PROGRAMME
# si ce code est exécuté en tant que script principal (appelé directement avec Python et pas importé), alors exécuter ces fonctions
if __name__ == '__main__':

    # Connexion du serveur sql
    conn = psycopg2.connect(
        host="localhost", port=5432, database="application_web",
        user='postgres', password='postgres')
    """
    Cerema Med :
    conn = psycopg2.connect(
        host=os.environ['POSTGRES_HOST'], port=5432, database=os.environ['POSTGRES_DB'],
        user=os.environ['POSTGRES_USER'], password=os.environ['POSTGRES_PASSWORD'])
    """	

    # Importation de la base de données des mots de passe
    fichier = pd.read_sql("select * from copro_occ.usagers", conn)
    conn.close()
    fichier.set_index('login', inplace=True)
    
    verificationLogin = dict(fichier['mot_de_passe'])
    inventaire = dict(fichier['filtre'])

    # Variables d'entrées correspondant aux filtres, possibilité de les stocker en dur pour test en local.
    user = sys.argv[1]
    mdp_user = sys.argv[2]
	
    # Vérification identifiant/mot de passe
    if user in verificationLogin.keys():
        menuJson = constructionJson(user)
    else:
        menuJson = {}

    # Affiche le contenu des filtres
    print(menuJson)
