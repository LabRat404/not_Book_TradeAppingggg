const express = require('express');
const User = require("../models/user");
const Image2 = require("../models/uploadImage");
const Chatters = require("../models/chatters");
const isbn = require('node-isbn');
const bcryptjs = require('bcryptjs');
const jwt = require("jsonwebtoken");
const { text } = require('body-parser');
const authRouter = express.Router();

authRouter.get("/test", (req, res) => {
    res.json({
        test: "this is the testing api"
    });
});

authRouter.post("/api/bookinfo", async (req, res) => {
    const { book_isbn } = req.body;

    isbn.resolve(book_isbn).then(function (book) {
        return res.json(book);
    }).catch(function (err) {
        res.status(401).json({ error: err });
    });
});

authRouter.post("/api/signin", async(req, res) => {
    try {
        const {email, password} = req.body;
        const user = await User.findOne( {email} );
        if (!user) {
            return res.status(400).json({
                msg: "No user found!"
            });
        }
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json( {
                msg: "incorrect password!"
            });
        }

        const token = jwt.sign({id: user._id}, "passwordKey"); //private key
        res.json({token, ...user._doc});
        // {
        //     'token': 'abcd'
        //     'name': 'doria',
        //     'email': 'admin123@gmail.com'
        // }
    } catch (e) {
        res.status(500).json( {
                error: e.message
            }
        );
    }
});


authRouter.post("/api/signup", async (req, res) => {
    try {
        const {name, email, password, address} = req.body;
        // {
        //     'name':name,
        //     'email':email,
        //     'password':password
        // }
        
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res
                .status(400)
                .json({ msg: 'User with same email already exists!' });
        }
        const hashedPassword = await bcryptjs.hash(password, 8);

        let user = new User({ //save to MongoDB
            email,
            password: hashedPassword,
            name,
            address,
        })
        user = await user.save();
        res.json(user);

        // 200 OK
        // get the data from client, 
        // post that data in db
        // return that data to the user
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

authRouter.post("/api/uploading", async (req, res) => {
    try {
  
            Image2.create({
            name: req.body['name'],
            url: req.body['url'],
            delhash: req.body['delhash'],
            dbISBN: req.body['dbISBN'],
            comments: req.body['comments'],
            username: req.body['username'],
            booktitle: req.body['booktitle'],
            author: req.body['author'],
            googlelink: req.body['googlelink']
            
          }, (e, results) => {
            if (e)
              res.send(e);
            else
              res.send("Ref: asdasdsd");
          });
        // get the data from client, 
        // post that data in db
        // return that data to the user
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

authRouter.get("/api/grabuserlist/:username", async (req, res) => {
    console.log(req.params["username"]);
    Image2
    .find({username : req.params["username"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );   
});

authRouter.get("/api/grabdbbook/:hashname", async (req, res) => {
    console.log(req.params["hashname"]);
    Image2
    .find({name : req.params["hashname"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );   
});

authRouter.get("/api/graballuserbook", async (req, res) => {
   
    Image2
    .find().sort( { booktitle: 1 } )
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );   
});

authRouter.get("/api/grabuserdata/:username", async (req, res) => {
    console.log(req.params["username"]);
    User
    .findOne({name : req.params["username"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        //console.log(results);
        }
     }
     );

});


authRouter.put("/api/changeavatar/:username", async (req, res) => {
    //console.log(req.params["username"]+ req.body['url']);
  
    User
    .findOne({name : req.params["username"]})
    .exec((e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        results.address = req.body['url'];
        results.save();
        res.send(results);

        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
        }
     }
     );

});

authRouter.delete("/api/dellist/:dellist", async (req, res) => {
    Image2
    .find({name : req.params["dellist"]})
    .deleteOne()
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
          
        res.send(results);
        }
     }
     );
});

authRouter.get("/api/loaduserimage/:username", async (req, res) => {
  
    User
    .find({name : req.params["username"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
    
        res.send(results[0].address);
   
      
        }
     }
     );
});
//not yet done
authRouter.delete("/api/deluser/:username", async (req, res) => {
    console.log(req.params["username"]);
    Image2
    .find({username : req.params["username"]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results == null)
          res.send("404 not found. No records found!", 404);
        else{
        res.send(results);
        }
     }
     );
});

authRouter.get("/api/graballchat/:self", async (req, res) => {

    Chatters
    .find({$or: [
        {
          self: req.params["self"],
       
        },
        {
       
          notself: req.params["self"]
        }
      ]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results.length == 0)
          res.send(null);
        else{
        res.send(results);
        }
     }
     );   
});

authRouter.post("/api/grabchat", async (req, res) => {

    Chatters
    .find({$or: [
        {
          self: req.body["self"],
          notself: req.body["notself"]
        },
        {
          self: req.body["notself"],
          notself: req.body["self"]
        }
      ]})
    .exec( (e, results) => {
        if (e)
          res.send("Error not known");
      else if(results.length == 0)
          res.send(null);
        else{
        res.send(results);
        }
     }
     );   
});


authRouter.post("/api/createnloadChat", async (req, res) => {
    try {
        // print("asdsad");
        //console.log(req.body["self"] + req.body["notself"] + req.body["msg"]+   + req.body["randomhash"]);
        Chatters
        .find({$or: [
            {
              self: req.body["self"],
              notself: req.body["notself"]
            },
            {
              self: req.body["notself"],
              notself: req.body["self"]
            }
          ]})
          .exec( (e, results) => {
            if (e)
              res.send("Error not known");
          else if(results.length ==0){
            // console.log(results + "hi1");
            Chatters
            .create({
                self: req.body['self'],
                notself: req.body['notself'],
                randomhash: req.body["randomhash"],
                lastdate:req.body["dates"],
                chatter: [{dates: req.body["dates"]}, {user: req.body["self"],text: req.body["msg"]}]
             
                //{dates: new Date()}, {user: req.body["self"],text: msg}
              })
               //console.log(datess);
               res.send("done");
          } 
          else if(results.length >0){
            Chatters
        .find({$or: [
            {
              self: req.body["self"],
              notself: req.body["notself"]
            },
            {
              self: req.body["notself"],
              notself: req.body["self"]
            }
          ]}).exec((e, results) => {
            let x = new Date(req.body["dates"]);
            let y = new Date(results[0]["lastdate"]);
            if (e)
              res.send("Error not known");
           else if((x-y) > 43200000){
            results[0]["lastdate"] = req.body["dates"];
            let times ={"dates": req.body["dates"]}
            results[0]["chatter"].push(times);
            let mesg = {
                "user": req.body['self'],
                "text": req.body['msg']
            }
            results[0]["chatter"].push(mesg);
            results[0].save();
          }else{
            let mesg = {
                "user": req.body['self'],
                "text": req.body['msg']
            }
            results[0]["chatter"].push(mesg);
            results[0].save();
          }
         
        }
          );
          res.send("done");
            }else{ res.send(null);}
         }
         ); 
        // get the data from client, 
        // post that data in db
        // return that data to the user
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});
//Chatters

module.exports = authRouter; //allow public access