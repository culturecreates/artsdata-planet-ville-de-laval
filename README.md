# artsdata-planet-ville-de-laval
Data pipeline to import events from Ville de Laval to Artsdata.

Ville de Laval events on [Donnees Quebec](https://www.donneesquebec.ca/recherche/dataset/calendrier-des-activites/resource/b51a25de-bd06-4247-87ba-2b1ea8228005).

The extraction in done by the workflow in several steps:
1. Download the JSON file [calendrier-activites.json](https://www.donneesquebec.ca/recherche/dataset/calendrier-des-activites/resource/b51a25de-bd06-4247-87ba-2b1ea8228005) from Donnèes Québec.
2. Convert the JSON to an RDF Graph using the OntoRefine Docker image with config.json that contains the mapping of JSON to RDF.
3. Run `main.rb` to get a list of all event's places and then crawl the URL of each place to extract the JSON-LD and add it to the RDF graph of events.
4. Store a Github version of the RDF graph in dumps/entities.ttl
5. Call the Artsdata Databus to register a new version of the artifact "calendrier-activites"
6. Wait for Artsdata to load the artifact into an [Artsdata graph](http://kg.artsdata.ca/entity?uri=http%3A%2F%2Fkg.artsdata.ca%2Fculture-creates%2Fartsdata-planet-ville-de-laval%2Fcalendrier-activites)
6. Check Artsdata for events and places that should be minted for use in the Signé Laval calendar using sparql upcoming-cultural-events.sparql.

Directories
============

Description of the directories and the files they contain.

dumps
------

The converted RDF in turtle. This file is versioned with each load of the data from Donnees Quebec.

mapping
-------

The mapping directory contains the OntoRefine mappings in JSON to convert to RDF and the place mapping in turtle.

sparqls
-------
* replace-blank-nodes.sparql assigns a place URI to all schema:Place and subtypes including schema:LocalBusiness.
* add-derived-from.sparql adds the webpage to the Place for reference

Minting
========
This data pipeline assumes that events can be consistently minted using the page url + date (without time).
<https://www.laval.ca/Pages/Fr/Calendrier/rencontrez-votre-elue-louise-lortie.aspx#2023-06-14> 



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
* 2023-12-04: CUlture Creates resumes weekly imports to  Artsdata.
* 2024-03-15: Culture Creates automates pull from Donnees Quebec using this repo's [workflow](https://github.com/culturecreates/artsdata-planet-ville-de-laval/blob/main/.github/workflows/ville-de-laval-entities.yml)



Artsdata Export to Footlight CMS
===========
The events are loaded into Footlight CMS on a schedule located in the [Footlight Aggregator workflow](https://github.com/culturecreates/footlight-aggregator/blob/main/.github/workflows/import-data-ville-de-laval.yml).

Manual check [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=event_footlight&sparql=query_footlight_events&source=http://kg.artsdata.ca/culture-creates/artsdata-planet-ville-de-laval/calendrier-activites) 



Future improvement: Check date of event within 23 hrs instead of truncating dateTime.