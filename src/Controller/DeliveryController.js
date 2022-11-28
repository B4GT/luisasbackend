const { response } = require('express');
const connet = require('../DataBase/DataBase');

const getAllDelivery = async ( req, res = response ) => {
    try {
        const conn = await connet();

        const delivery = await conn.query(`CALL SP_GET_ALL_ORDERS();`);

        await conn.end();

        res.json({
            resp: true,
            msg : 'Get All Delivery',
            delivery: delivery[0][0]
        });
    } catch (err) {
        return res.status(500).json({
            resp: false,
            msg : err
        });        
    }
}

const getOrderDetails = async ( req, res = response ) => {

    try {

        const conn = await connet();

        const orderDetails = await conn.query(`CALL SP_GET_ORDER_DETAILS_DELIVERY(?);`, [req.params.idOrder]);

        await conn.end();

        res.json({
            resp: true,
            msg : 'Get Details',
            orderDetails : orderDetails[0][0],
        });
        
    } catch (err) {
        
    }
   
}

module.exports = {
    getAllDelivery,
    getOrderDetails
}