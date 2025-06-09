--- ----------------------------------------------------
-- Customers Page
-- -----------------------------------------------------

-- Display all customers --
DROP PROCEDURE IF EXISTS GetCustomers;
DELIMITER //
CREATE PROCEDURE GetCustomers()
BEGIN
   SELECT customerID, firstName, lastName, email, phone
   FROM Customers
   ORDER BY `firstName` ASC;
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


-- -----------------------------------------------------
-- Matches Page
-- -----------------------------------------------------

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

   SELECT LAST_INSERT_ID() AS new_ID;
END //
DELIMITER ;


-- -----------------------------------------------------
-- Orders Page
-- -----------------------------------------------------

-- Read Orders Info and customer name, contact info --
DROP PROCEDURE IF EXISTS GetOrders;
DELIMITER //
CREATE PROCEDURE GetOrders()
BEGIN
   SELECT  Orders.orderID, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName,
         DATE_FORMAT(Orders.orderDate, "%M %d %Y") as orderDate, Orders.total, Orders.paymentStatus
   FROM Orders
   INNER JOIN Customers ON Orders.customerID = Customers.customerID
   ORDER BY Orders.orderDate ASC;
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


-- -----------------------------------------------------
-- Seats Page
-- -----------------------------------------------------

-- Display all seats ordered by section, row, and seatNumber --
DROP PROCEDURE IF EXISTS GetSeats;
DELIMITER //
CREATE PROCEDURE GetSeats()
BEGIN
   SELECT seatID, section, seatRow, seatNumber 
   FROM Seats
   ORDER BY section, seatRow, seatNumber ASC;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Match Tickets Page
-- -----------------------------------------------------

-- Display all match tickets ordered by match date --
DROP PROCEDURE IF EXISTS GetMatchTickets;
DELIMITER //
CREATE PROCEDURE GetMatchTickets()
BEGIN
   SELECT MatchTickets.ticketID, opponentName, DATE_FORMAT(Matches.matchDate, "%M %d %Y") AS matchDate, section, 
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

-- Create a new Match Ticket --
DROP PROCEDURE IF EXISTS CreateMatchTicket;

DELIMITER //

CREATE PROCEDURE CreateMatchTicket(IN matchIDinput int, IN seatIDinput int,  IN customerIDinput int)

BEGIN

IF EXISTS (
        SELECT 1 FROM MatchTickets
        WHERE matchID = matchIDInput AND
        seatID = seatIDInput
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat already reserved. Please select new seat.';
    ELSE
        INSERT INTO Orders (customerID, orderDate, total, paymentStatus)
        VALUES (customerIDinput, NOW(), 20, 'Paid');

        INSERT INTO MatchTickets (matchID, seatID, orderID, price) VALUES
        (matchIDinput, seatIDinput, LAST_INSERT_ID(), 20.00);
    END IF;

END //

DELIMETER ;



-- Update Match Ticket Seats --
DROP PROCEDURE IF EXISTS UpdateMatchTicket;
DELIMITER //
CREATE PROCEDURE UpdateMatchTicket(IN seatIDInput INT, IN ticketIDInput INT, IN matchIDInput INT)
BEGIN
    IF EXISTS (
        SELECT 1 FROM MatchTickets
        WHERE matchID = matchIDInput AND
        seatID = seatIDInput AND ticketID != ticketIDInput
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat already reserved. Please select new seat.';
    ELSE
        UPDATE MatchTickets 
        SET seatID = seatIDInput, matchID = matchIDInput
        WHERE ticketID = ticketIDInput;
    END IF;
END //
DELIMITER ;

-- Delete a Match Ticket --
DROP PROCEDURE IF EXISTS DeleteMatchTicket;
DELIMITER //
CREATE PROCEDURE DeleteMatchTicket(IN selectedID INT)
BEGIN
   DECLARE deletedOrderID INT; 
   SELECT orderID into deletedOrderID
   FROM MatchTickets
   WHERE ticketID = selectedID;

   DELETE FROM MatchTickets
   WHERE ticketID = selectedID;


   UPDATE Orders
   SET paymentStatus= 'Cancelled'
   WHERE orderID = deletedOrderID;
   
END //
DELIMITER ;

-- Reset SP --

DROP PROCEDURE IF EXISTS ResetDB;
DELIMITER //
CREATE PROCEDURE ResetDB()
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    SET AUTOCOMMIT = 0;

    -- Table structure for table 'Matches'
    DROP TABLE IF EXISTS Matches;
    CREATE TABLE Matches (
        matchID INT AUTO_INCREMENT PRIMARY KEY,
        opponentName VARCHAR(50) NOT NULL,
        matchDate DATETIME NOT NULL
    );

    INSERT INTO Matches (opponentName, matchDate) 
    VALUES ('Redwood Kickers', '2025-06-13  18:00:00'),
        ('Venice Beach FC', '2025-06-24 18:00:00'),
        ('TBD', '2025-07-10 18:30:00')

    ;


    -- Table structure for table 'Seats'
    DROP TABLE IF EXISTS Seats;
    CREATE TABLE Seats (
        seatID INT AUTO_INCREMENT PRIMARY KEY,
        section VARCHAR(15) NOT NULL,
        seatRow VARCHAR(15) NOT NULL,
        seatNumber INT NOT NULL
    );

    INSERT INTO Seats (section, seatRow, seatNumber) 
    VALUES ('GA', 'GA', 1), ('GA', 'GA', 2), ('GA', 'GA', 3)
    ;


    -- Table structure for table 'Customers'
    DROP TABLE IF EXISTS Customers;
    CREATE TABLE Customers (
        customerID INT AUTO_INCREMENT PRIMARY KEY,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        phone VARCHAR(15)
    );

    INSERT INTO Customers (firstName, lastName, email, phone) 
    VALUES ('John', 'Doe', 'Doe45@gmail.com', '4589320111'),
        ('Emil', 'Johnson', 'EJ345@hotmail.com', NULL), 
        ('Helen', 'Yamal', 'hely@yahoo.com', '6781234567')
    ;


    -- Table structure for table 'Orders'
    DROP TABLE IF EXISTS Orders;
    CREATE TABLE Orders (
        orderID INT AUTO_INCREMENT PRIMARY KEY,
        customerID INT NOT NULL,
        orderDate DATETIME NOT NULL,
        total Decimal(10,2) NOT NULL,
        paymentStatus VARCHAR(10) NOT NULL CHECK (paymentStatus IN ('Paid', 'Processing', 'Cancelled', 'Refunded')),
        FOREIGN KEY (customerID) REFERENCES Customers(customerID)
    );

    INSERT INTO Orders (customerID, orderDate, total, paymentStatus) 
    VALUES ((SELECT customerID from Customers where firstName = 'John' and lastName = 'Doe'), '2025-05-01 12:20:00', 20, 'Paid'),
        ((SELECT customerID from Customers where firstName = 'Emil' and lastName = 'Johnson'), '2025-04-28 09:15:00', 20, 'Paid'),
        ((SELECT customerID from Customers where firstName = 'Helen' and lastName = 'Yamal'), '2025-05-02 15:30:05', 20, 'Paid'),
        ((SELECT customerID from Customers where firstName = 'Emil' and lastName = 'Johnson'), '2025-05-22 10:32:00', 20, 'Paid')
    ;

    -- Table structure for table 'MatchTickets'
    DROP TABLE IF EXISTS MatchTickets;
    CREATE TABLE MatchTickets (
        ticketID INT AUTO_INCREMENT PRIMARY KEY,
        matchID INT NOT NULL,
        seatID INT NOT NULL,
        orderID INT,
        price Decimal(10, 2) NOT NULL,
        FOREIGN KEY (matchID) REFERENCES Matches(matchID) ON DELETE CASCADE,
        FOREIGN KEY (seatID) REFERENCES Seats(seatID) ON DELETE CASCADE,
        FOREIGN KEY (orderID) REFERENCES Orders(orderID) ON DELETE CASCADE
    );

    INSERT INTO MatchTickets (matchID, seatID, orderID, price) VALUES
        ((SELECT matchID from Matches where opponentName = 'Redwood Kickers'), (SELECT seatID from Seats where section = 'GA' and
        seatRow = 'GA' and seatNumber = 1), (SELECT orderID from Orders where orderDate = '2025-05-01 12:20:00'), 20),
        ((SELECT matchID from Matches where opponentName = 'Venice Beach FC'), (SELECT seatID from Seats where section = 'GA' and
        seatRow = 'GA' and seatNumber = 2), (SELECT orderID from Orders where orderDate = '2025-04-28 09:15:00'), 20),
        ((SELECT matchID from Matches where opponentName = 'Venice Beach FC'), (SELECT seatID from Seats where section = 'GA' and
        seatRow = 'GA' and seatNumber = 3), (SELECT orderID from Orders where orderDate = '2025-05-02 15:30:05'), 20),
        ((SELECT matchID from Matches where opponentName = 'Redwood Kickers'), (SELECT seatID from Seats where section = 'GA' and
        seatRow = 'GA' and seatNumber = 2), (SELECT orderID from Orders where orderDate = '2025-05-22 10:32:00'), 20)
    ;


    SET FOREIGN_KEY_CHECKS=1;
    COMMIT;
END //
DELIMITER ;