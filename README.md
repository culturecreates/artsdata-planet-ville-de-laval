# artsdata-planet-ville-de-laval
Data pipeline to import events from Ville de Laval to Artsdata.

Ville de Laval publishes events in a file called [callendrier-des-activites](https://www.donneesquebec.ca/recherche/dataset/calendrier-des-activites/resource/b51a25de-bd06-4247-87ba-2b1ea8228005) on the Donnees Quebec portal.

The [script](https://github.com/culturecreates/artsdata-planet-ville-de-laval/blob/main/.github/workflows/ville-de-laval-entities.yml) in this repository does the following: 
1. Download the JSON file [calendrier-activites.json](https://www.donneesquebec.ca/recherche/dataset/calendrier-des-activites/resource/b51a25de-bd06-4247-87ba-2b1ea8228005) from Donnees Québec.
2. Convert the JSON to an RDF Graph using the OntoRefine Docker image with config.json that contains the mapping of JSON to RDF.
3. Get a list of event places from the calendrier-activites CSV on Donnees Québec and then crawl the URL of each place to extract the JSON-LD and add it to the data to be uploaded.
4. Commit the RDF graph in Github in dumps/entities.ttl. This is versioned by Github.
5. Call the Artsdata Databus to register a new version of the artifact "calendrier-activites"
6. Mint Artsdata URIs for events and places for use in the Signé Laval calendar  [upcoming-cultural-events.sparql](https://kg.artsdata.ca/fr/query/show?sparql=https%3A%2F%2Fraw.githubusercontent.com%2Fculturecreates%2Fartsdata-planet-ville-de-laval%2Fmain%2Fsparql%2Fnebula%2Fupcoming-cultural-events.sparql&title=Ville-de-Laval+événements+pour+Signé+Laval+CMS 
).

## Events to be sent to Signé Laval's CMS

The events to be sent to Signé Laval's CMS must meet the following criteria:
- event is in atleast one of 3 categories: Bibliothèques, Expositions et spectacles, Événements et festivals
- event is NOT tagged "Enseignants et étudiants"
- event has a single startDate and location 
- location is not a webinar/online

## Trouble shooting

Use this URL to view the data for 5 events that will be sent to CMS.
-  https://api.artsdata.ca/query?limit=5&frame=event_footlight&format=json&sparql=https://raw.githubusercontent.com/culturecreates/footlight-aggregator/main/sparql/query-events-v2.sparql&source=http://kg.artsdata.ca/culture-creates/artsdata-planet-ville-de-laval/calendrier-activites

Directories
============

Description of the directories and the files they contain.

dumps
------

* File from Données Québec in JSON
* File of data converted to RDF turtle

mapping
-------

The mapping directory contains the OntoRefine mappings in JSON to convert to RDF and the place mapping in turtle.

sparqls
-------
* replace-blank-nodes.sparql assigns a place URI to all schema:Place and subtypes including schema:LocalBusiness.
* add-derived-from.sparql adds the webpage to the Place for reference

laval.ca URIs
========
This data pipeline assumes that event URIs can be consistently generated using the page url + date + time(hour,mintues)
<https://www.laval.ca/Pages/Fr/Calendrier/rencontrez-votre-elue-louise-lortie.aspx#2023-06-14T16-00> 


Editing the Mapping file
===========
To edit RDF mapping:

- Run ./run_ontorefine.sh (if needed chmod +x run_ontorefine.sh)
- Open localhost:7333 to use Open Refine workbench
- Open the existing project
- Click "Edit RDF Mapping"
- When done making changes save RDF Mapping
- Clean up the history (tab undo/redo) to keep only the steps needed.
- Export > Export project configurations into Github /ontorefine/config.json


History
==========
* In the summer of 2023 the City of Laval fixed their export of JSON event data which is sent to the Données Quebec Portal.
* 2023-07-18: Culture Creates test loaded the CSV from Données Quebec and sent the event counts per category to Signé Laval with the question of which categories to include.
* 2023-08-16: Signé Laval received the answers from the City of Laval confirming the 3 categories of Events:
  * Bibliothèques (http://laval.ca/rdf/52ff792f-a72e-4b2b-859e-2b9faf17491a)
  * Événements et festivals (http://laval.ca/rdf/685b3eae-7097-4a44-8e72-1c769ed8f6cf)
  * Expositions et spectacles (http://laval.ca/rdf/03e3e7d7-ad9a-4f10-86db-dfc9d49b7abb)
* 2023-09-11: Culture Creates starting loading City of Laval events into Artsdata.
* 2023-09-18: Culture Creates confirms that the feed from Ville de Laval is broken.
* 2023-11-07: Culture Creates confirms that the feed from Ville de Laval is starting to work again.
* 2023-12-04: CUlture Creates resumes weekly imports to Artsdata.
* 2024-03-15: Culture Creates automates pull from Donnees Quebec using this repo's [workflow](https://github.com/culturecreates/artsdata-planet-ville-de-laval/blob/main/.github/workflows/ville-de-laval-entities.yml)



Artsdata Export to Footlight CMS
===========
The events are loaded into Footlight CMS on a schedule located in the [Footlight Aggregator workflow](https://github.com/culturecreates/footlight-aggregator/blob/main/.github/workflows/import-data-ville-de-laval.yml).

Future improvement: Check date of event within 23 hrs instead of truncating dateTime.
