
const express = require('express');
const path = require('path');

const http = require('http');
const Server = require("socket.io");
const socket = require('./Sockets/SockerOrderDelivery')

require('dotenv').config();


const app = express();

//Socket
const httpServer = http.createServer(app);
const io = Server(httpServer);
socket.socketOrderDelivery(io);


// Middleware
app.use( express.json() );
app.use( express.urlencoded({ extended: false }) );


// Routes
app.use('/api', require("./Routes/user.routes"));
app.use('/api', require("./Routes/auth.routes"));
app.use('/api', require("./Routes/product.routes"));
app.use('/api', require("./Routes/category.routes"));
app.use('/api', require("./Routes/payment.routes"));
app.use('/api', require("./Routes/delivery.routes"));
app.use('/api', require("./Routes/order.routes"));

// This folder will be Public
app.use( express.static( path.join( __dirname, 'Uploads/Profile') ));
app.use( express.static( path.join( __dirname, 'Uploads/Home' )));
app.use( express.static( path.join( __dirname, 'Uploads/Products' )));
app.use( express.static( path.join( __dirname, 'Uploads/Categories' )));


module.exports = app;