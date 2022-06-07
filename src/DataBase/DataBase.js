
const { createPool } = require('mysql2/promise');


module.exports = connect = async () => {

    const connection = await createPool({
        host: 'localhost',
        user: 'root',
        password: '#64AOO6@8FFBF8*',
        database: 'productshop',
        connectionLimit: 10
    });

    return connection;

}