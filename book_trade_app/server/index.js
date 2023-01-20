//IMPORT FROM PACKAGES
const express = require('express');
const mongoose = require('mongoose');
console.log("hello server");

//IMPORT FROM OTHER FILES
const authRouter = require('./routes/auth');

//INIT
const PORT = 3000;
const app = express();
//const DB = "mongodb+srv://cuhktradeApp:9dbhnx67Xjx904Oc@cluster0.pjrdqne.mongodb.net/test";
const DB = "mongodb+srv://tan:tan@cluster0.kcnx2o6.mongodb.net/test";

//middleware
app.use(express.json());
app.use(authRouter);

//create API
// app.get("/hello-world", (req, res) => {
//     res.json({
//         hi: "hello world"
//     });
// })
// a get request sample
//GET, PUT, POST, DELETE, UPDATE -> CRUD 

// connections

mongoose
    .connect(DB)
    .then(() => {
        console.log("Connected to MongoDB successfully");
    })
    .catch((e) => {
        console.log("Error: " + e);
    })

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at PORT ${PORT}`);
}) //access anywhere, for android to locate localhost
//localhost, 127.0.0.1