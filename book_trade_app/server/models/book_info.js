const mongoose = require('mongoose');

// var isbn_code = '9781451578270';

const bookSchema = ({
    book_isbn: {
        required: true,
        type: String, 
        trim: true,
    }
});

const Book = mongoose.model("Book", bookSchema);
module.exports = Book; // allow public access