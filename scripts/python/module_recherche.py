# -*- coding: utf8 -*-
# module pour positionner une fonction de recherche géographique dans la carte html. Il permet de rechercher une commune, un code postal, une adresse, des coordonnées GPS…
# Ajout également des css et js dans l'en-tête de la carte html


def funct(filename, string, tag):
    with open(filename, 'r+', encoding="utf-8") as file:
        text = file.read()
        i = text.index(tag) + len(tag)
        file.seek(0)
        file.write(text[:i-24] + string + '\n' + text[i-23:])

def funct2(filename, string):
    with open(filename, 'r+', encoding="utf-8") as file:
        text = file.read()
        file.seek(0)
        file.write(text[:-17] + string)
        
def funct3(filename):
    with open(filename, 'r+', encoding="utf-8") as file:
        text = file.read()
        i = text.index('map_')
        file.seek(0)
        return text[i:i+36]

def geocodeFichier(fichier):

    tag_1 = '''<style>html, body {'''

    variable_map = funct3(fichier)
             
    geo_1 = '''<script src="https://rawgit.com/k4r573n/leaflet-control-osm-geocoder/master/Control.OSMGeocoder.js"></script>
	<link rel="stylesheet" href="https://rawgit.com/k4r573n/leaflet-control-osm-geocoder/master/Control.OSMGeocoder.css" />
	<link rel="stylesheet" type="text/css" href="../css/main.css"/>
	<script src="../js/_main.js"></script>'''

    geo_2 = '''var osmGeocoder = new L.Control.OSMGeocoder({
                collapsed: true,
                position: 'topright',
                text: 'Rechercher',
                });'''+ str(variable_map) + '''.addControl(osmGeocoder);
            map.addControl(osmGeocoder);
            </script>'''
                
    funct(fichier, geo_1, tag_1)

    funct2(fichier, geo_2)
