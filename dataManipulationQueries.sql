-- ----------------------------------------------------------------
-- CREATE
-- ----------------------------------------------------------------

-- Add a match
INSERT INTO Matches (opponentName, matchDate) 
VALUES (:opponentName, :matchDate);

-- Add a seat
INSERT INTO Seats (section, seatRow, seatNumber) 
VALUES (:section, :seatRow, :seatNumber);

-- Add a customer
INSERT INTO Customers (firstName, lastName, email, phone)
VALUES (:firstName, :lastName, :email, :phone);

-- Add an order
INSERT INTO Orders (customerID, orderDate, total, paymentStatus)
VALUES (:customerID, :orderDate, :total, :paymentStatus);

-- Add a matchTicket
INSERT INTO MatchTickets ( matchID, seatID, orderID, price)
VALUES (:matchID, :seatID, :orderID, :price);


-- ----------------------------------------------------------------
-- READ
-- ----------------------------------------------------------------

-- get all Matches
SELECT matchID, opponentName, matchDate FROM Matches;

-- get all Seats
SELECT seatID, section, seatRow, seatNumber FROM Seats;

-- get all Customer Names
SELECT customerID, firstName, lastName FROM Customers;

-- get all Orders with customer names
SELECT Orders.orderID, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName, Orders.orderDate
FROM Orders
JOIN Customers ON Orders.customerID = Customers.customerID;

-- get all MatchTickets with match info, seat info, order info, and customer name
SELECT MatchTickets.ticketID, opponentName, matchDate, section AS seatSection, seatRow, seatNumber,
       CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName,
       MatchTickets.price
FROM MatchTickets
JOIN Matches ON MatchTickets.matchID = Matches.matchID
JOIN Seats ON MatchTickets.seatID = Seats.seatID
JOIN Orders ON MatchTickets.orderID = Orders.orderID
JOIN Customers ON Orders.customerID = Customers.customerID;

-- get available seats (seats that are not in matchTickets)
SELECT * FROM Seats
WHERE seatID NOT IN (
  SELECT seatID FROM MatchTickets WHERE matchID = :matchID
);

-- get matchTicket by orderID
SELECT * FROM MatchTickets WHERE orderID = :orderID;

-- get Orders by CustomerID
SELECT * FROM Orders WHERE customerID = :customerID;


-- ----------------------------------------------------------------
-- UPDATE
-- ----------------------------------------------------------------

-- Update a match
UPDATE Matches
SET opponentName = :newOpponentName, matchDate = :newMatchDate
WHERE matchID = :matchID;

-- Update a customer's email and phone
UPDATE Customers
SET email = :newEmail, phone = :newPhone
WHERE customerID = :customerID;

-- Update an Order
UPDATE Orders
SET orderDate = :newOrderDate, total = :newTotal, paymentStatus = :newPaymentStatus
WHERE orderID = :orderID;

-- Update a matchTicket
UPDATE MatchTickets
SET matchID = :newMatchID, seatID = :newSeatID, orderID = :newOrderID, price = :newPrice
WHERE ticketID = :ticketID;


-- ----------------------------------------------------------------
-- DELETE
-- ----------------------------------------------------------------

-- Delete a Match by (Deletes associated matchTicket through CASCADE)
DELETE FROM Matches
WHERE matchID = :matchID;

-- Delete a Seat by (Deletes associated matchTicket through CASCADE)
DELETE FROM Seats
WHERE seatID = :seatID;

-- Delete a matchTicket
DELETE FROM MatchTickets
WHERE ticketID = :ticketID;