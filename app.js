// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

// Database
const db = require('./database/db-connector');



// Handlebars
const { engine, ExpressHandlebars } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs',
    helpers: {
        json: function (context) {
            return JSON.stringify(context);
        }
    }
 })); // Create instance of handlebars
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
        // const query1 = `SELECT * FROM Customers
        //     ORDER BY firstName ASC;`;
        // const [customers] = await db.query(query1);
         const [[customers]] = await db.query('CALL getCustomers()');

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
        // const query1 = `SELECT matchID, opponentName, DATE_FORMAT(matchDate, "%M %d %Y") AS matchDate FROM Matches`;
        // const [matches] = await db.query(query1);
        const [[matches]] = await db.query('CALL getMatches()');

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
        // const query1 = `SELECT  Orders.orderID, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName,
        //                 DATE_FORMAT(Orders.orderDate, "%M %d %Y") as orderDate, Orders.total, Orders.paymentStatus
        //                 FROM Orders
        //                 INNER JOIN Customers ON Orders.customerID = Customers.customerID
        //                 ORDER BY Orders.orderDate ASC`;
        // const [orders] = await db.query(query1);
        const [[orders]] = await db.query('CALL getOrders()');

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
        // const query1 = `SELECT * FROM Seats
        //                 Order BY section, seatRow, seatNumber ASC`;
        // const [seats] = await db.query(query1);
        const [[seats]] = await db.query('CALL getSeats()');

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
        // display match tickets data
        // const query1 = `SELECT MatchTickets.ticketID, opponentName, DATE_FORMAT(matchDate, "%M %d %Y") AS matchDate, section, 
        // seatRow, seatNumber, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName, MatchTickets.price, DATE_FORMAT(orderDate, "%M %d %Y") AS orderDate
        //                 FROM MatchTickets
        //                 JOIN Matches ON MatchTickets.matchID = Matches.matchID
        //                 JOIN Seats ON MatchTickets.seatID = Seats.seatID
        //                 JOIN Orders ON MatchTickets.orderID = Orders.orderID
        //                 JOIN Customers ON Orders.customerID = Customers.customerID
        //                 ORDER BY matchDate ASC`;
        // const [matchTickets] = await db.query(query1);
        const [[matchTickets]] = await db.query('CALL getMatchTickets()');

        // const query2 = `SELECT matchID, opponentName, DATE_FORMAT(matchDate, "%M %d %Y") AS matchDate FROM Matches`;
        // const [matches] = await db.query(query2);
        const [[matches]] = await db.query('CALL GetMatches()');

        // const query3 = `SELECT * FROM Seats`;
        // const [seats] = await db.query(query3);
        const [[seats]] = await db.query('CALL getSeats()');

        // Render the matchTickets.hbs file, and also send the renderer
        //  an object that contains our  ticket information
        res.render('matchTickets', { 
            matchTickets: matchTickets,
            matches: matches,
            seats: seats
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.put('/customers/update', async function (req, res) {
    try {
        const { customerID, firstName, lastName, email, phone } = req.body;
        await db.query('CALL updateCustomer(?, ?, ?)', [
            email,
            phone,
            customerID
        ]);
    } catch (error) {
        console.error('Error updating customer:', error);
        res.status(500).send('Failed to update customer.');
    }
});

app.post('/reset-db', async function (req, res) {
    console.log('Resetting database...');
    try {
        await db.query('CALL resetDB()');
        console.log('Database reset successfully');
        res.redirect('/');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send(
            'Failed to reset database.'
        );
    }
});


// ########################################
// ########## LISTENER

app.listen(process.env.PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            process.env.PORT +
            '; press Ctrl-C to terminate.'
    );
});