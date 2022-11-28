const { Router } = require('express');
const {createPaypalPayment, execute} = require('../Controller/PaymentController');

const router = Router();

    router.get('/payment/create-paypal-payment',  createPaypalPayment );
    router.get('/payment/execute', execute );

module.exports = router;