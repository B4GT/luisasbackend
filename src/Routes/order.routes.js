const { Router } = require('express');
const { getOrdersByStatus, updateStatusToDelivered, getOrdersByDelivery, getTypeStatus, updateStatusToOntheWay, getOrdersForStatus } = require('../Controller/OrderController');
const { validateToken } = require('../Middlewares/ValidateToken');

const router = Router();

router.get('/order/get-order-for-status/:statusId', validateToken, getOrdersForStatus);
router.put('/order/update-status-to-on-way/:idOrder', validateToken, updateStatusToOntheWay);
router.put('/order/update-status-to-delivered/:idOrder', updateStatusToDelivered);
//router.put('/order/update-status-to-delivered/:idOrder', validateToken, updateStatusToDelivered);
router.get('/order/get-order-by-delivery/:statusId', validateToken, getOrdersByDelivery);
router.get('/order/get-types-status', getTypeStatus);

module.exports = router;