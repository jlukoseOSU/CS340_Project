// Get an instance of mysql we can use in the app
require('dotenv').config({ path: './.env' });
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : process.env.DB_HOST,
    user              : process.env.DB_USER,
    password          : process.env.DB_PASSWORD,
    database          : process.env.DB_NAME,
    port              : process.env.DB_PORT,
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;