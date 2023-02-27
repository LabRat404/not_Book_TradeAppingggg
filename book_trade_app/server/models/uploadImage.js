const mongoose = require('mongoose');

// set user model

var imageSchema = new mongoose.Schema({
    id: {

        type: String,
    },
    name: {
        required: true,
        type: String, 
    },
    username: {
        required: true,
        type: String, 
    },
    url: {
        required: true,
        type: String,
    },
    dbISBN: {
        required: true,
        type: String,
    },
    delhash: {
        required: true,
        type: String,
    },
    username: {
      
        type: String,
    },
    comments: {
        required: true,
        type: String,
    },
    googlelink: {
        required: true,
        type: String,
    },
    author: {
        required: true,
        type: String,
    },
    booktitle: {
        required: true,
        type: String,
    },

});

//Image is a model which has a schema imageSchema
const Image2 = mongoose.model("Image2", imageSchema);
module.exports = Image2; // allow public access