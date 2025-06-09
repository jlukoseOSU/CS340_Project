### Eighty-One FC Ticketing System

# Authors
Kevin Penate
Joshua Lukose

## ABOUT THIS PROJECT 
Our goal is to support this local team's growth and implement a database driven website with a database backend that will track ticket sales, order information, and fan information. Allowing fans to purchase tickets based on available seats eliminates the possibility of double booking a seat or over filling the stadium. This will be done by implementing the following entities: Matches, Seats, Customers, Orders, and an intersection table MatchTickets that will host our reserved seats and the occupant information. As the team continues their deep run in the tournament, we anticipate this database to scale as necessary with a forecast of at least 6,000 tickets to be processed and a revenue of $90,000. 

# How to run
the following environmental variables must be defined:
DB_HOST, DB_NAME, DB_USER, DB_PASSWORD, PORT



# Citations
// Citation for createMatches routehandler:
// # Date: 05/20/2025
// Based on: CS340 Module 8 exploration 
// Source Module 8 Exploration "Implementing CUD Operations in your app"