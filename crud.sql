-- CUSTOMERS PAGE --

SELECT * FROM Customers
ORDER BY firstName ASC;


-- Matches Page --

SELECT * FROM Matches 
ORDER BY matchDATE ASC;


-- Seats Page --
--Display all seats ordered by section, row, and seatNumber--

SELECT * FROM Seats
Order BY section, seatRow, seatNumber ASC;

-- Orders Page --

--Read Orders Info and customer name, contact info--
SELECT  Orders.orderID, Orders.orderDate, Orders.total, Orders.paymentStatus, Customers.firstName, Customers.lastName,
Customers.email 
FROM Orders
Inner JOIN Customers ON Orders.customerID = Customers.customerID


--Match Tickets Page--
SELECT MatchTickets.ticketID, Matches.matchDATE, Matches.opponentName, Seats.section, Seats.seatRow,
Seats.seatNumber, Orders.orderID, MatchTickets.price FROM MatchTickets
INNER JOIN Matches ON MatchTickets.matchID = Matches.matchID
INNER JOIN Seats ON MatchTickets.seatID = Seats.seatID
INNER JOIN Orders ON MatchTickets.orderID = Orders.orderID
ORDER BY Matches.matchDATE; 


-- Update Match Ticket Seats and Price --
SELECT seatID FROM Seats
WHERE section = :input AND seatRow = :input AND seatNumber = :input;

UPDATE MatchTickets 
   SET seatID = :seatIDInput, price = :priceInput, 
       
   WHERE ticketID = :ticketIDInput

-- Delete Match Ticket --
DELETE FROM MatchTickets
WHERE ticketID = :selectedID;

-- CREATE a new Match on Matches Page --
INSERT INTO Matches (opponentName, matchDate) 
VALUES (:opponentNameInput, :matchDateInput);