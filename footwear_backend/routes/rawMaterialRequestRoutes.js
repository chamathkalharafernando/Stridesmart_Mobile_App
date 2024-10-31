const express = require('express');
const { 
  createRawMaterialRequest, 
  getRawMaterialRequests, 
  updateRawMaterialRequestStatus 
} = require('../controllers/rawMaterialRequestController');

const router = express.Router();

router.post('/create', createRawMaterialRequest);
router.get('/', getRawMaterialRequests);
router.put('/update-status/:id', updateRawMaterialRequestStatus);

module.exports = router;