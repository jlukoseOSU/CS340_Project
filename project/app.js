// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 3001;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/customers', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we display our customer data
        const query1 = `SELECT * FROM Customers
            ORDER BY firstName ASC;`;
        const [customers] = await db.query(query1);

        // Render the customers.hbs file, and also send the renderer
        //  an object that contains our  customer information
        res.render('customers', { customers: customers});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/matches', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we display our matches data
        const query1 = `SELECT * FROM Matches 
        ORDER BY matchDATE ASC;`;
        const [matches] = await db.query(query1);

        // Render the matches.hbs file, and also send the renderer
        //  an object that contains our  matches information
        res.render('matches', { matches: matches});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/orders', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we display our order data
        const query1 = `SELECT  Orders.orderID, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName,
                        Orders.orderDate, Orders.total, Orders.paymentStatus
                        FROM Orders
                        INNER JOIN Customers ON Orders.customerID = Customers.customerID
                        ORDER BY Orders.orderDate ASC`;
        const [orders] = await db.query(query1);

        // Render the orders.hbs file, and also send the renderer
        //  an object that contains our  orders information
        res.render('orders', { orders: orders});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/seats', async function (req, res) {
    try {
        // display our order data
        const query1 = `SELECT * FROM Seats
                        Order BY section, seatRow, seatNumber ASC`;
        const [seats] = await db.query(query1);

        // Render the seats.hbs file, and also send the renderer
        //  an object that contains our  seats information
        res.render('seats', { seats: seats});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/matchTickets', async function (req, res) {
    try {
        // display our order data
        const query1 = `SELECT MatchTickets.ticketID, opponentName, matchDate, section AS seatSection, 
        seatRow, seatNumber, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName, MatchTickets.price
                        FROM MatchTickets
                        JOIN Matches ON MatchTickets.matchID = Matches.matchID
                        JOIN Seats ON MatchTickets.seatID = Seats.seatID
                        JOIN Orders ON MatchTickets.orderID = Orders.orderID
                        JOIN Customers ON Orders.customerID = Customers.customerID
                        ORDER BY matchDate ASC`;
        const [matchTickets] = await db.query(query1);

        // Render the matchTickets.hbs file, and also send the renderer
        //  an object that contains our  ticket information
        res.render('matchTickets', { matchTickets: matchTickets});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});