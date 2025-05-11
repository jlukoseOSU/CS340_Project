// Get an instance of mysql we can use in the app
require('dotenv').config({ path: './.env' });
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : 'classmysql.engr.oregonstate.edu',
    user              : 'cs340_penatek',
    password          : process.env.DB_PASSWORD,
    database          : 'cs340_penatek'
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;