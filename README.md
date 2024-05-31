This project tries to viualize: 
1) The topic salience of "Worries" (political context) in media _ ex: healthcare, AHV, climate, immigration etc.
2) Voting results of Swiss Federal elections  

The main idea is that:
News media outlets cover more on certain topics which increases salience of the issue,
This leads to people voting for parties whose ideology aligns with frequently covered issues.

Although this not a straightforward relationship, this project visualizes the
most covered topics and the strength of party in the recent federal elections 
across cantons.
- This might give us an idea of which issues were discussed more leading to the 
  election and does the majority party goals align with these issues 

FILE STRUCTURE:

scripts:
- data_extraction: Fetch data from api and storing
- EDA: Process and visualize data
- map_viz: Plot the strength of party based on 2023 Federal election results
           on swiss map
- app: Shiny app to visualize most discussed topics and strength of party 
- swiss_source_availability: Check if Switzerland sources are included in api

data_original:
- Extracted data from api
- Election results csv

data_map:
- Shape file of Switzerland
- Processed election data

plots:
Stores generated output plots

