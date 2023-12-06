# artsdata-planet-ville-de-laval
Data pipeline to import events from Ville de Laval to Artsdata.

Ville de Laval events on [Donnees Quebec](https://www.donneesquebec.ca/recherche/dataset/calendrier-des-activites/resource/b51a25de-bd06-4247-87ba-2b1ea8228005).

Directories
============

Description of the directories and the files they contain.

dumps
------

The dumps directory contains the JSON dumps from Donnees Quebec and the converted RDF in turtle.

mapping
-------

The mapping directory contains the OntoRefine mappings in JSON to convert to RDF and the place mapping in turtle.

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


Supporting Graphs
===============
Places mapped to Artsdasta Places - http://laval.ca/place-mapping-to-artsdata-place
File is stored here in mapping/place-mapping-to-artsdata-place.nq for easy import to Artsdata

Artsdata Export to Footlight CMS
===========

On-demand [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=event_footlight&sparql=query_footlight_events&source=http://kg.artsdata.ca/culture-creates/artsdata-planet-ville-de-laval/calendrier-activites) 


Manual Process
============
1. Download CSV dump from Données Quebec and store in /dumps
1. Run OntoRefine Docker image (load mapping file from /mapping)
1. Convert dump to turtle and store in /dumps (must fill down the 2 fields needed to generate the event URI (PageUrl and EventDate) in order to get the multiple locations, categories, tags, etc.)
1. update name of file to upload in workflow.yml
1. Run workflow to upload RDF to Artsdata
1. Check Artsdata for places mising Artsdata IDs and mint places (see Sparql Notebook)
1. Make sure CMS events are uploaded to Artsdata (to detect duplicates)
1. Mint new Artsdata IDs for new events using "bulk mint" Satelitte Minter with Artsdata authority credentials. Use batch with sparql - which of 2? --> Batch mint events.

Future improvement: Check date of event within 23 hrs instead of truncating dateTime.