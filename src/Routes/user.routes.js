const { Router } = require('express');
const { addNewUser, 
    getUserById,
    changeFotoProfile, 
    updateInformationUser, 
    updateStreetAddress, 
    addStreetAddress, 
    getAddressesUser, 
    deleteStreetAddress } = require('../Controller/UserController');
const { uploadsProfile } = require('../Helpers/Multer');
const { validateToken }  = require('../Middlewares/ValidateToken');

const router = Router();

    router.post('/user/add-new-user', addNewUser);
    router.post('/user/add-street-address', validateToken, addStreetAddress);
    router.delete('/user/delete-street-address/:ad_id', validateToken, deleteStreetAddress);
    router.get('/user/get-address-user', validateToken, getAddressesUser);
    router.get('/user/get-user-by-id', validateToken, getUserById);
    router.put('/user/update-picture-profile', [ validateToken, uploadsProfile.single('image') ], changeFotoProfile );
    router.put('/user/update-information-user', validateToken, updateInformationUser);
    router.put('/user/update-street-address', validateToken, updateStreetAddress);

module.exports = router;