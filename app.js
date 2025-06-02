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
    // helper function to convert objects to JSON
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
        // get customers data
         const [[customers]] = await db.query('CALL getCustomers()');

        // Render the customers.hbs file, and also send the renderer
        //  an object that contains our customer information
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
        // get matches data
        const [[matches]] = await db.query('CALL getMatches()');

        // Render the matches.hbs file, and also send the renderer
        //  an object that contains our matches information
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
        // get orders data
        const [[orders]] = await db.query('CALL getOrders()');

        // Render the orders.hbs file, and also send the renderer
        //  an object that contains our orders information
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
        // get seats data
        const [[seats]] = await db.query('CALL getSeats()');

        // Render the seats.hbs file, and also send the renderer
        //  an object that contains our seats information
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
        // get matchTickets data for diplay table
        const [[matchTickets]] = await db.query('CALL getMatchTickets()');

        // get matches data for dropdown
        const [[matches]] = await db.query('CALL GetMatches()');

        // get seats data for dropdown
        const [[seats]] = await db.query('CALL getSeats()');

        // Render the matchTickets.hbs file, and also send the renderer
        //  an object that contains our ticket, matches, and seats information
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
        // update customer info with info from form
        const { customerID, firstName, lastName, email, phone } = req.body;
        await db.query('CALL updateCustomer(?, ?, ?)', [
            email,
            phone,
            customerID
        ]);
        res.status(200).send('Update successful');
    } catch (error) {
        console.error('Error updating customer:', error);
        res.status(500).send('Failed to update customer.');
    }
});

app.post('/matchTickets/update', async function (req, res) {
    const { ticketID, matchID, seatID, orderID, price, } = req.body;
    try {
        // update matchTicket info from form
        await db.query('CALL UpdateMatchTicket(?, ?, ?, ?)', [
            seatID,
            price,
            ticketID, 
            matchID
        ]);
        // redirects once completes updates
        res.redirect('/matchTickets')
    } catch (error) {
        console.error(`Error updating Match Ticket ID ${ticketID}`, error);

        res.render('matchTickets', {error: error.message})
    }
});

// CREATE ROUTES
app.post('/matches/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL CreateMatch(?, ?);`;

        // Store ID of last inserted row
        const [[result]] = await db.query(query1, [
            data.create_match_opponentName,
            data.create_match_matchDate
        ]);

        console.log(`CREATE match. ID: ${result.new_ID} ` +
            `Opponent: ${data.create_match_opponentName}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/matches');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
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