# artsdata-planet-ville-de-laval
Data pipeline to import events from Ville de Laval to Artsdata.

Ville de Laval events on [Donnees Quebec](https://www.donneesquebec.ca/recherche/dataset/calendrier-des-activites/resource/b51a25de-bd06-4247-87ba-2b1ea8228005).

Minting
========
This data pipeline assumes that events can be consistently minted using the page url + date.
<https://www.laval.ca/Pages/Fr/Calendrier/rencontrez-votre-elue-louise-lortie.asp#2023-06-14> 

History
==========
* In the summer of 2023 the City of Laval fixed their export of JSON event data which is sent to the Données Quebec Portal.
* 2023-07-18: Culture Creates test loaded the CSV from Données Quebec and sent the event counts per category to Signé Laval with the question of which categories to include.
* 2023-08-16: Signé Laval received the answers from the City of Laval confirming the 3 categories of Events:
  * Bibliothèques (http://laval.ca/rdf/52ff792f-a72e-4b2b-859e-2b9faf17491a)
  * Événements et festivals (http://laval.ca/rdf/685b3eae-7097-4a44-8e72-1c769ed8f6cf)
  * Expositions et spectacles (http://laval.ca/rdf/03e3e7d7-ad9a-4f10-86db-dfc9d49b7abb)
* 2023-09-11: Culture Creates starting loading City of Laval events into Artsdata.
  

Supporting Graphs
===============
Places mapped to Artsdasta Places - http://laval.ca/place-mapping-to-artsdata-place
File is stored here in mapping/place-mapping-to-artsdata-place.nq for easy import to Artsdata

Artsdata Export to Footlight CMS
===========

On-demand [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=event_footlight&sparql=query_footlight_events&source=http://kg.artsdata.ca/culture-creates/artsdata-planet-ville-de-laval/calendrier-activites) 