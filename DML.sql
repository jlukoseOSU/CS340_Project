-- CUSTOMERS PAGE --

-- Display all customers --
SELECT customerID, firstName, lastName FROM Customers
ORDER BY firstName ASC;

-- Update Customer email and Phone --
UPDATE Customers 
   SET email = :emailInput, 
   phone = :phoneInput
   WHERE customerID = :customerIDInput


-- Matches Page --

-- Display all matches ordered by date --
SELECT matchID, opponentName, DATE_FORMAT(matchDate, "%M %d %Y") AS matchDate FROM Matches
ORDER BY matchDate ASC;

-- CREATE a new Match on Matches Page --
INSERT INTO Matches (opponentName, matchDate) 
VALUES (:opponentNameInput, :matchDateInput);

-- Orders Page --

-- Read Orders Info and customer name, contact info --
SELECT  Orders.orderID, DATE_FORMAT(Orders.orderDate, "%M %d %Y") as orderDate, Orders.total, Orders.paymentStatus, Customers.firstName, Customers.lastName,
Customers.email 
FROM Orders
Inner JOIN Customers ON Orders.customerID = Customers.customerID

-- Delete Order --
DELETE FROM Orders
WHERE orderID = :selectedID;


-- Seats Page --

-- Display all seats ordered by section, row, and seatNumber --
SELECT seatID, section, seatRow, seatNumber FROM Seats
Order BY section, seatRow, seatNumber ASC;

-- Match Tickets Page --

-- Display all match tickets ordered by match date --
SELECT MatchTickets.ticketID, opponentName, DATE_FORMAT(Matches.matchDate, "%M %d %Y") AS matchDate, section AS seatSection, 
        seatRow, seatNumber, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName, 
        Orders.orderID, ATE_FORMAT(Orders.orderDate, "%M %d %Y") as orderDate, MatchTickets.price
         FROM MatchTickets
         INNER JOIN Matches ON MatchTickets.matchID = Matches.matchID
         INNER JOIN Seats ON MatchTickets.seatID = Seats.seatID
         INNER JOIN Orders ON MatchTickets.orderID = Orders.orderID
         INNER JOIN Customers ON Orders.customerID = Customers.customerID
         ORDER BY matchDate ASC; 

-- Update Match Ticket Seats and Price --
SELECT seatID FROM Seats
WHERE section = :input AND seatRow = :input AND seatNumber = :input;

UPDATE MatchTickets 
   SET seatID = :seatIDInput, price = :priceInput
       
   WHERE ticketID = :ticketIDInput

-- Populate Matches Dropdown in Match Tickets Update Form --
SELECT matchID, opponentName, DATE_FORMAT(matchDate, "%M %d %Y") AS matchDate FROM Matches
ORDER BY matchDate ASC;

-- Populate Seats Dropdown in Match Tickets Update Form --
SELECT seatID, section, seatRow, seatNumber FROM Seats
Order BY section, seatRow, seatNumber ASC;

-- Delete Match Ticket --
DELETE FROM MatchTickets
WHERE ticketID = :selectedID;
