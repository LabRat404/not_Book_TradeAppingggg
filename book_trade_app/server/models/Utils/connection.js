//This will handle a mongo db connection
mongoose = require('mongoose');
const dotenv = require('dotenv');
const { default: mongoose } = require('mongoose');
const PORT = 3000;
const app = express();
const DB =

dotenv.config();

let MONGO_URL = DB;
const connectDB = async () => {
  
    await mongoose
    .connect(DB)
    .then(() => {
        console.log("Connected to MongoDB successfully");
    })
    .catch((e) => {
        console.log("Error: " + e);
    })

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at PORT ${PORT}`);
}) 
}
