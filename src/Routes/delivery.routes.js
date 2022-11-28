const { Router } = require('express');
const { validateToken } = require('../Middlewares/ValidateToken');
const { getAllDelivery, getOrderDetails } = require('../Controller/DeliveryController');

const router = Router();

router.get('/delivery/get-all-orders-home', validateToken, getAllDelivery);
router.get('/delivery/get-order-details-delivery/:idOrder', validateToken, getOrderDetails);

module.exports = router;