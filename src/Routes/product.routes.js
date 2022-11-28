const { Router } = require('express');
const { getProductsForHomeCarousel,
    getListProductsHome, 
    getListPopularProductsHome,
    getListNewProductsHome,
    likeOrUnlikeProduct, 
    getAllListCategories,
    productFavoriteForUser,
    getProductsForCategories,
    searchProductForName,
    searchProductForPrice,
    getOrdersForStatus,
    saveOrderBuyProducts,
    addNewProduct,
    getAllPurchasedProducts,
    getAllPendingOrders,
    getOrderDetailsProducts } = require('../Controller/ProductController');
const { validateToken }  = require('../Middlewares/ValidateToken');
const { uploadsProduct } = require('../Helpers/Multer');

const router = Router();

    router.get('/product/get-home-products-carousel', validateToken,  getProductsForHomeCarousel );
    router.get('/product/get-products-home', validateToken, getListProductsHome);
    router.get('/product/get-popular-products-home', validateToken, getListPopularProductsHome);
    router.get('/product/get-new-products-home', validateToken, getListNewProductsHome);
    router.post('/product/like-or-unlike-product', validateToken, likeOrUnlikeProduct);
    router.get('/product/get-all-categories',  getAllListCategories);
    router.get('/product/get-all-favorite', validateToken, productFavoriteForUser);
    router.get('/product/get-products-for-category/:idCategory', validateToken, getProductsForCategories);
    router.get('/product/get-products-for-name/:nameProduct', validateToken, searchProductForName);
    router.get('/product/get-products-for-price/:minPrice/:maxPrice', validateToken, searchProductForPrice);
    router.get('/product/get-orders-for-status/:idStatus', validateToken, getOrdersForStatus);
    router.post('/product/save-order-buy-product', validateToken, saveOrderBuyProducts);
    router.post('/product/add-new-product', [validateToken, uploadsProduct.single('productImage')], addNewProduct);
    router.get('/product/get-all-purchased-products', validateToken, getAllPurchasedProducts);
    router.get('/product/get-all-pending-orders', validateToken, getAllPendingOrders);
    router.get('/product/get-orders-details/:uidOrder', validateToken, getOrderDetailsProducts);

module.exports = router;