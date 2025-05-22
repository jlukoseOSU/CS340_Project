
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