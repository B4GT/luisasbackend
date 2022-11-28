
const { createPool } = require('mysql2/promise');


module.exports = connect = async () => {

    const connection = await createPool({        
        host: process.env.HOST,
        user: process.env.USER,
        password: process.env.PASSWORD,
        database: process.env.DATABASE,
        connectionLimit: 10
    });

    return connection;

}