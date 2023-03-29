const express = require('express');
const User = require("../models/user");
const Image2 = require("../models/uploadImage");
const Chatters = require("../models/chatters");
const TradeBucket = require("../models/tradebucket");
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

authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        msg: "No user found!"
      });
    }
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({
        msg: "incorrect password!"
      });
    }
    const token = jwt.sign({ id: user._id }, "passwordKey"); //private key
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({
      error: e.message
    }
    );
  }
});


authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password, address } = req.body;
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
      state: '0',
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
    .find({ username: req.params["username"] })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send(results);
      }
    }
    );
});

authRouter.get("/api/grabdbbook/:hashname", async (req, res) => {
  console.log(req.params["hashname"]);
  Image2
    .find({ name: req.params["hashname"] })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send(results);
      }
    }
    );
});

authRouter.get("/api/graballuserbook", async (req, res) => {

  Image2
    .find().sort({ booktitle: 1 })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send(results);
      }
    }
    );
});

authRouter.get("/api/grabuserdata/:username", async (req, res) => {
  console.log(req.params["username"]);
  User
    .findOne({ name: req.params["username"] })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send(results);
        //console.log(results);
      }
    }
    );

});

authRouter.get("/api/grabrec/:notthis", async (req, res) => {
  //console.log(req.params["notthis"]);
  Image2
    .aggregate([
      { $match: { username: { $not: { $eq: req.params["notthis"] } } } },
      { $sample: { size: 3 } }
    ])
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null) {
        //console.log("results");  
        res.send("404 not found. No records found!", 404);
      }

      else {
        res.send(results);
        //console.log(results);
      }
    }
    );
});


authRouter.put("/api/changeavatar/:username", async (req, res) => {
  //console.log(req.params["username"]+ req.body['url']);
  User
    .findOne({ name: req.params["username"] })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        results.address = req.body['url'];
        results.save();
        res.send(results);
        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
      }
    }
    );

});


authRouter.put("/api/changegmailpw/", async (req, res) => {
  //console.log(req.params["username"]+ req.body['url']);
  User
    .findOne({ name: req.body["username"] })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        results.email = req.body['email'];
        results.password = req.body['password'];
        results.save();
        res.send('ok');
        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
      }
    }
    );

});

authRouter.delete("/api/dellist/:dellist", async (req, res) => {
  Image2
    .find({ name: req.params["dellist"] })
    .deleteOne()
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send(results);
      }
    }
    );
});

authRouter.delete("/api/delchat/:delhash", async (req, res) => {
  console.log(req.params["delhash"]);
  Chatters
    .find({ randomhash: req.params["delhash"] })
    .deleteOne()
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send('ok');
      }
    }
    );
});

authRouter.get("/api/loaduserimage/:username", async (req, res) => {
  User
    .find({ name: req.params["username"] })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send(results[0].address);
      }
    }
    );
});


//not yet done
authRouter.delete("/api/deluser/:username", async (req, res) => {
  console.log(req.params["username"]);
  Image2
    .find({ username: req.params["username"] })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        res.send(results);
      }
    }
    );
});

authRouter.get("/api/graballchat/:self", async (req, res) => {

  Chatters
    .find({
      $or: [
        {
          self: req.params["self"],

        },
        {

          notself: req.params["self"]
        }
      ]
    })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results.length == 0)
        res.send(null);
      else {
        res.send(results);
      }
    }
    );
});

authRouter.post("/api/grabchat", async (req, res) => {

  Chatters
    .find({
      $or: [
        {
          self: req.body["self"],
          notself: req.body["notself"]
        },
        {
          self: req.body["notself"],
          notself: req.body["self"]
        }
      ]
    })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results.length == 0)
        res.send(null);
      else {
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
      .find({
        $or: [
          {
            self: req.body["self"],
            notself: req.body["notself"]
          },
          {
            self: req.body["notself"],
            notself: req.body["self"]
          }
        ]
      })
      .exec((e, results) => {
        if (e)
          res.send("Error not known");
        else if (results.length == 0) {
          // console.log(results + "hi1");
          Chatters
            .create({
              self: req.body['self'],
              notself: req.body['notself'],
              randomhash: req.body["randomhash"],
              lastdate: req.body["dates"],
              chatter: [{ dates: req.body["dates"] }, { user: req.body["self"], text: req.body["msg"] }]

              //{dates: new Date()}, {user: req.body["self"],text: msg}
            })
          //console.log(datess);
          res.send("done");
        }
        else if (results.length > 0) {
          Chatters
            .find({
              $or: [
                {
                  self: req.body["self"],
                  notself: req.body["notself"]
                },
                {
                  self: req.body["notself"],
                  notself: req.body["self"]
                }
              ]
            }).exec((e, results) => {
              let x = new Date(req.body["dates"]);
              let y = new Date(results[0]["lastdate"]);
              if (e)
                res.send("Error not known");
              else if ((x - y) > 43200000) {
                results[0]["lastdate"] = req.body["dates"];
                let times = { "dates": req.body["dates"] }
                results[0]["chatter"].push(times);
                let mesg = {
                  "user": req.body['self'],
                  "text": req.body['msg']
                }
                results[0]["chatter"].push(mesg);
                results[0].save();
              } else {
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
        } else { res.send(null); }
      }
      );
    // get the data from client, 
    // post that data in db
    // return that data to the user
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//developing
authRouter.post("/api/PhotoChat", async (req, res) => {

  try {
    Chatters
      .find({
        $or: [
          {
            self: req.body["self"],
            notself: req.body["notself"]
          },
          {
            self: req.body["notself"],
            notself: req.body["self"]
          }
        ]
      })
      .exec((e, results) => {
        if (e)
          res.send("Error not known");
        else if (results.length == 0) {
          Chatters
            .create({

              self: req.body['self'],
              notself: req.body['notself'],
              randomhash: req.body["randomhash"],
              lastdate: req.body["dates"],
              chatter: [{ dates: req.body["dates"] }, { user: req.body["self"], images: req.body["images"] }]
              //data2["chatter"][i]["images"]
              //{dates: new Date()}, {user: req.body["self"],text: msg}
            })
          //console.log(datess);
          res.send("done");
        }
        else if (results.length > 0) {

          Chatters
            .find({
              $or: [
                {
                  self: req.body["self"],
                  notself: req.body["notself"]
                },
                {
                  self: req.body["notself"],
                  notself: req.body["self"]
                }
              ]
            }).exec((e, results) => {
              let x = new Date(req.body["dates"]);
              let y = new Date(results[0]["lastdate"]);
              if (e)
                res.send("Error not known");
              else if ((x - y) > 43200000) {

                results[0]["lastdate"] = req.body["dates"];
                let times = { "dates": req.body["dates"] }
                results[0]["chatter"].push(times);
                let mesg = {
                  "user": req.body['self'],
                  "images": req.body["images"]
                }
                results[0]["chatter"].push(mesg);
                results[0].save();
              } else {

                let mesg = {

                  "user": req.body['self'],
                  "images": req.body["images"]
                }
                results[0]["chatter"].push(mesg);
                results[0].save();
              }

            }
            );
          res.send("done");
        } else { res.send(null); }
      }
      );
    // get the data from client, 
    // post that data in db
    // return that data to the user
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/gettradebusket", (req, res) => {

  TradeBucket
    .find({
      $or: [
        {
          status: 'inprogress',
          self: req.body["self"],
          notself: req.body["notself"]
        },
        {
           status: 'inprogress',
          self: req.body["notself"],
          notself: req.body["self"]
        }
      ]
    })
    .exec((e, results) => {
      if (e)
        res.send("Error");
      else if (results.length == 0) {
        res.send("Empty");
        console.log('Empty');
      }

      else {
        res.send(results);
        console.log('notempty');
      }
    }
    );
});
authRouter.put("/api/changetradebusket", (req, res) => {

  TradeBucket
    .find({
      $or: [
        {
          status: 'inprogress',
          self: req.body["self"],
          notself: req.body["notself"]
        },
        {
          status: 'inprogress',
          self: req.body["notself"],
          notself: req.body["self"]
        }
      ]
    })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        console.log(req.body['selflist']);
        results[0].selflist = req.body['selflist'];
        results[0].notselflist = req.body['notselflist'];
        results[0].selfaccept = '0',
          results[0].notselfaccept = '0',
          results[0].save();
        res.send("done");
        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
      }
    }
    );


});
authRouter.put("/api/changetradebusketstate", (req, res) => {

  TradeBucket
    .find({
      $or: [
        {
          status: 'inprogress',
          self: req.body["self"],
          notself: req.body["notself"]
        },
        {
          status: 'inprogress',
          self: req.body["notself"],
          notself: req.body["self"]
        }
      ]
    })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        if (req.body["self"] == results[0].self) {
          if (results[0].selfaccept == '0')
            results[0].selfaccept = '1';
            else if(results[0].notselfaccept == '1')
            results[0].selfconfirm = '1';
        } else {
          if (results[0].notselfaccept == '0')
            results[0].notselfaccept = '1';
          else if(results[0].selfaccept == '1')
            results[0].notselfconfirm = '1';
        }
        results[0].save();
        if(results[0].notselfconfirm == '1' && results[0].selfconfirm == '1'){
              results[0]['selflist'].forEach(names => {
                Image2
                .find({ name: names })
                .exec((e, imageresults) => {
                  if (e)
                    res.send("Error not known");
                  else if (imageresults == null)
                    res.send("404 not found. No records found!", 404);
                  else {
                    imageresults[0].state ='1';
                    imageresults[0].save();
                  }
                }
                );
                console.log(names);
            });
            results[0]['notselflist'].forEach(names => {
              Image2
              .find({ name: names })
              .exec((e, imageresults) => {
                if (e)
                  res.send("Error not known");
                else if (imageresults == null)
                  res.send("404 not found. No records found!", 404);
                else {
                  imageresults[0].state ='1';
                  imageresults[0].save();
                }
              }
              );
              console.log(names);
            });
        }
        //if(results[0].notselfconfirm=='1')
        res.send("done");
        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
      }
    }
    );


});

authRouter.post("/api/createtradebusket", (req, res) => {

  TradeBucket
    .find({
      $or: [
        {
          status: 'inprogress',
          self: req.body["self"],
          notself: req.body["notself"]
        },
        {
          status: 'inprogress',
          self: req.body["notself"],
          notself: req.body["self"]
        }
      ]
    })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results.length == 0) {
        TradeBucket
          .create({

            self: req.body['self'],
            notself: req.body['notself'],
            randomhash: req.body["randomhash"],
            lastdate: req.body["lastdate"],
            status:   'inprogress',
            editing: req.body["editing"],
            selflist: req.body["selflist"],
            notselflist: req.body["notselflist"],
            selfaccept: '0',
            notselfaccept: '0',
            selfconfirm: '0',
            notselfconfirm: '0',

            //data2["chatter"][i]["images"]
            //{dates: new Date()}, {user: req.body["self"],text: msg}
          })
        //cretae the trade busket
        console.log("creating ");
        res.send("done");
      }
      else {

        res.send("notempty...");
        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
      }
    }
    );


});

authRouter.put("/api/deleteaccount", (req, res) => {
  //to be imp
  TradeBucket
    .find({
      $or: [
        {
          self: req.body["self"],
          notself: req.body["notself"]
        },
        {
          self: req.body["notself"],
          notself: req.body["self"]
        }
      ]
    })
    .exec((e, results) => {
      if (e)
        res.send("Error not known");
      else if (results == null)
        res.send("404 not found. No records found!", 404);
      else {
        console.log(req.body['selflist']);
        results[0].selflist = req.body['selflist'];
        results[0].notselflist = req.body['notselflist'];
        console.log(results);
        results[0].save();
        res.send("done");
        //console.log(results  + "ASdasdsadasdsad test" + req.body['url']);
      }
    }
    );


});
module.exports = authRouter; //allow public access