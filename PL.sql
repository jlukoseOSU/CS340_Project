-- CUSTOMERS PAGE --

-- Display all customers --
DROP PROCEDURE IF EXISTS GetCustomers;
DELIMITER //
CREATE PROCEDURE GetCustomers()
BEGIN
   SELECT customerID, firstName, lastName, email, phone FROM Customers;
END //
DELIMITER ;

-- Update Customer email and Phone --
DROP PROCEDURE IF EXISTS UpdateCustomer;
DELIMITER //
CREATE PROCEDURE UpdateCustomer(IN emailInput VARCHAR(255), IN phoneInput VARCHAR(15), IN customerIDInput INT)
BEGIN
   UPDATE Customers 
   SET email = emailInput, phone = phoneInput
   WHERE customerID = customerIDInput;
END //
DELIMITER ;


-- Matches Page --

-- Display all matches ordered by date --
DROP PROCEDURE IF EXISTS GetMatches;
DELIMITER //
CREATE PROCEDURE GetMatches()
BEGIN
   SELECT matchID, opponentName, DATE_FORMAT(matchDate, "%M %d %Y") AS matchDate
   FROM Matches
   ORDER BY matchDate ASC;
END //
DELIMITER ;

-- CREATE a new Match --
DROP PROCEDURE IF EXISTS CreateMatch;
DELIMITER //
CREATE PROCEDURE CreateMatch(IN opponentNameInput VARCHAR(255), IN matchDateInput DATE)
BEGIN
   INSERT INTO Matches (opponentName, matchDate) 
   VALUES (opponentNameInput, matchDateInput);
END //
DELIMITER ;


-- Orders Page --

-- Read Orders Info and customer name, contact info --
DROP PROCEDURE IF EXISTS GetOrders;
DELIMITER //
CREATE PROCEDURE GetOrders()
BEGIN
   SELECT Orders.orderID, DATE_FORMAT(Orders.orderDate, "%M %d %Y") as orderDate, Orders.total, Orders.paymentStatus, 
          Customers.firstName, Customers.lastName, Customers.email 
   FROM Orders
   INNER JOIN Customers ON Orders.customerID = Customers.customerID;
END //
DELIMITER ;

-- Delete an Order --
DROP PROCEDURE IF EXISTS DeleteOrder;
DELIMITER //
CREATE PROCEDURE DeleteOrder(IN selectedID INT)
BEGIN
   DELETE FROM Orders
   WHERE orderID = selectedID;
END //
DELIMITER ;


-- Seats Page --

-- Display all seats ordered by section, row, and seatNumber --
DROP PROCEDURE IF EXISTS GetSeats;
DELIMITER //
CREATE PROCEDURE GetSeats()
BEGIN
   SELECT seatID, section, seatRow, seatNumber 
   FROM Seats
   ORDER BY section, seatRow, seatNumber ASC;
END //


-- Match Tickets Page --

-- Display all match tickets ordered by match date --
DROP PROCEDURE IF EXISTS GetMatchTickets;
DELIMITER //
CREATE PROCEDURE GetMatchTickets()
BEGIN
   SELECT MatchTickets.ticketID, opponentName, DATE_FORMAT(Matches.matchDate, "%M %d %Y") AS matchDate, section AS seatSection, 
          seatRow, seatNumber, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName, 
          Orders.orderID, DATE_FORMAT(Orders.orderDate, "%M %d %Y") as orderDate, MatchTickets.price
   FROM MatchTickets
   INNER JOIN Matches ON MatchTickets.matchID = Matches.matchID
   INNER JOIN Seats ON MatchTickets.seatID = Seats.seatID
   INNER JOIN Orders ON MatchTickets.orderID = Orders.orderID
   INNER JOIN Customers ON Orders.customerID = Customers.customerID
   ORDER BY matchDate ASC; 
END //
DELIMITER ;

-- Update Match Ticket Seats and Price --
DROP PROCEDURE IF EXISTS UpdateMatchTicket;
DELIMITER //
CREATE PROCEDURE UpdateMatchTicket(IN seatIDInput INT, IN priceInput DECIMAL(10,2), IN ticketIDInput INT)
BEGIN
   UPDATE MatchTickets 
   SET seatID = seatIDInput, price = priceInput
   WHERE ticketID = ticketIDInput;
END //
DELIMITER ;

-- Delete a Match Ticket --
DROP PROCEDURE IF EXISTS DeleteMatchTicket;
DELIMITER //
CREATE PROCEDURE DeleteMatchTicket(IN selectedID INT)
BEGIN
   DELETE FROM MatchTickets
   WHERE ticketID = selectedID;
END //
DELIMITER ;




