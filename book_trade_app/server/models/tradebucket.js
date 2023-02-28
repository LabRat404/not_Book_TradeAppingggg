const mongoose = require('mongoose');

// set user model

var bucketSchema = new mongoose.Schema({
    "self": {
      "type": "String"
    },
    "notself": {
      "type": "String"
    },
    "randomhash":{
        "type": "String"
      },
      "lastdate":{
        "type": "String"
      },
      "lastuser":{
        "type": "String"
      },
      "status":{
        "type": "String"
      },
      
    "selflist": {
      "type": [
        "Mixed"
      ]
    },
    "notselflist": {
      "type": [
        "Mixed"
      ]
    }
  });

//Image is a model which has a schema imageSchema
const TradeBucket = mongoose.model("TradeBucket", bucketSchema);
module.exports = TradeBucket; // allow public access