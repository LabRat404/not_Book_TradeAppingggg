const mongoose = require('mongoose');

// set user model

var chatSchema = new mongoose.Schema({
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
    "chatter": {
      "type": [
        "Mixed"
      ]
    }
  });

//Image is a model which has a schema imageSchema
const Chatters = mongoose.model("Chatters", chatSchema);
module.exports = Chatters; // allow public access