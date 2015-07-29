# News Scraper: In the News links

This project scrapes the _UCSC in the News_ page for data related to each link. Each HTML list item has embedded `data-` attributes that this project parses and adds to a CSV file.

Currently does not work because the format of in the news has changed and does not include the `data-` attributes.

## Todos

[ ] Update the parser for the new format of the In the News page (it's now broken into year pages/formats). 