const {response, request} = require('express');
const connect = require('../DataBase/DataBase');

const updateStatusToDelivered = async ( req, res = response ) => {

    try {
        
        const conn = await connect();

        await conn.query('UPDATE orderbuy SET fk_os_id = ? WHERE uidOrderBuy = ?', [ 5, req.params.idOrder ]);

        await conn.end();

        res.json({
            resp: true,
            msg : 'Order Delivered'
        });
        
    } catch (e) {
        return res.status(500).json({
            resp: false,
            msg : e
        });
    }

}

const getOrdersByDelivery = async ( req, res = response ) => {

    try {

        const conn = await connect();

        const ordersDeliverydb = await conn.query(`CALL SP_ORDERS_BY_DELIVERY(?,?);`, [ req.uidPerson, req.params.statusId ]);
        console.log(req.uidPerson, req.params.statusId);
        await conn.end();

        res.json({
            resp: true,
            msg : 'All Orders By Delivery',
            delivery : ordersDeliverydb[0][0]
        });
        
    } catch (e) {
        return res.status(500).json({
            resp: false,
            msg : e
        });
    }

}

const getOrdersForStatus = async ( req, res = response ) => {

    try {

        const conn = await connect();

        const ordersDeliverydb = await conn.query(`CALL SP_GET_ORDER_FOR_STATUS(?);`, [ req.params.statusId ]);
        await conn.end();

        res.json({
            resp: true,
            msg : 'All Orders For Status',
            delivery : ordersDeliverydb[0][0]
        });
        
    } catch (e) {
        return res.status(500).json({
            resp: false,
            msg : e
        });
    }

}

const updateStatusToOntheWay = async ( req, res = response ) => {

    try {

        const { latitude, longitude, deliveryId } = req.body;

        const conn = await connect();

        await conn.query(
//UPDATE orderbuy SET fk_os_id = 6, latitude = '-8.13005872859025', longitude = '79.04703352600336' WHERE uidOrderBuy = 6
            'UPDATE orderbuy SET fk_os_id = 6, latitude = ?, longitude = ?, fk_delivery_id = ? WHERE uidOrderBuy = ?',
            [ latitude, longitude, deliveryId, req.params.idOrder ]);

        await conn.end();

        res.json({
            resp: true,
            message : 'Order on way'
        });
        
    } catch (e) {
        return res.status(500).json({
            resp: false,
            message : e
        });
    }

}

const getTypeStatus= async ( req, res = response ) => {

    try {

        const conn = await connect();

        const orderStatusDb = await conn.query('SELECT * FROM Order_Status');

        await conn.end();

        res.json({
            resp: true,
            msg : 'Order Status',
            ostatus: orderStatusDb[0]
        });
        
    } catch (e) {
        return res.status(500).json({
            resp: false,
            msg : e
        });
    }

}

module.exports = {
    updateStatusToDelivered,    
    getOrdersByDelivery,
    getOrdersForStatus,
    updateStatusToOntheWay,
    getTypeStatus
}