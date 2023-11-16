const express = require('express');
const session = require('express-session');
const cors = require('cors');
//const MongoClient = require('mongodb').MongoClient;
const app = express();
const stripe = require('stripe')('sk_test_51O20fQJtCenMZXzLbdEAHFPxCX6c2ToH1vbas6wcZrQlRySLIlAqfeCXCtEbh4qrdlAUTCh40eUVOMqpkSxDK9U500up82d4Qb');

// Session Variables:
  // cart
  // paymentIntent

app.use(session({
  secret: "SECRETKEY",
  resave: false,
  saveUninitialized: false
}))

app.use(cors({
  origin: "http://localhost:3000",
  credentials: true
}));

app.use(express.json());

/*MongoClient.connect("mongodb://127.0.0.1:27017")
.then((client) => {
  console.log('Mongo Client Connected');
  const db = client.db('ECommerceDB');
  app.locals.db = db;
  console.log('ECommerceDB Connected');
})
.catch(err => console.log(err));*/

process.stdin.resume(); // so the program will not close instantly

function exitHandler(options, exitCode) {
  console.log('Exit Handler');
  if (options.cleanup) console.log('clean');
  if (exitCode || exitCode === 0) console.log(exitCode);
  if (options.exit) process.exit();
}

// do something when app is closing
process.on('exit', exitHandler.bind(null,{cleanup:true}));

// catches ctrl+c event
process.on('SIGINT', exitHandler.bind(null, {exit:true}));

// catches "kill pid" (for example: nodemon restart)
process.on('SIGUSR1', exitHandler.bind(null, {exit:true}));
process.on('SIGUSR2', exitHandler.bind(null, {exit:true}));

// catches uncaught exceptions
process.on('uncaughtException', exitHandler.bind(null, {exit:true}));

/* ROUTES */

app.get('/list-products', async (req, res) => {
  const products = await stripe.products.list();
  res.send(products);
});

app.post('/add-to-cart', async (req, res) => {

  if (!req.session.cart) {
    req.session.cart = [];
  }

  const restore = req.session.cart;

  const restoreCart = () => {
    req.session.cart = restore;
    res.status(500).send("An item was out of stock");
  };

  // CHECK IF OUT OF STOCK

  const product = await stripe.products.retrieve(req.body.id);
  const index = req.session.cart.findIndex(x => x.id === req.body.id);
  if (index > -1) {
    req.session.cart[index].quantity += req.body.quantity;
    if (req.session.cart[index].quantity > Number(product.metadata.stock)) {
      restoreCart();
      return;
    }
  } else {
    if (req.body.quantity > Number(product.metadata.stock)) {
      restoreCart();
      return;
    }
    req.session.cart.push(req.body);
  }

  res.send(" was added to cart");
});

app.post('/create-payment-intent', async (req, res) => {
  if(req.session.cart && req.session.cart.length > 0) {
    let amount = 0;
    let receipt = "";
    for (const element of req.session.cart) {
      const price = await stripe.prices.retrieve(element.price);
      amount += price.unit_amount * element.quantity;
      receipt += element.name +
      price.unit_amount +
      element.quantity +
      price.unit_amount * element.quantity;
    }
    receipt += amount;

    req.session.paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: 'usd'
    });
    res.send({ 
      clientSecret: req.session.paymentIntent.client_secret,
      receipt : receipt
    });
    return;
  }
  res.send({})
});

app.post('/complete-payment', async (req, res) => {
  if(!req.session.paymentIntent) {
    res.status(500).send("No payment made");
    return;
  }

  if(req.session.cart && req.session.cart.length > 0) {
    // Decrease Stock
    for (const element of req.session.cart) {
      const product = await stripe.products.retrieve(element.id);
      const currentStock = Number(product.metadata.stock) - element.quantity;
      await stripe.products.update(
        element.id,
        {metadata: { stock: "" + currentStock }}
      );

      /*await app.locals.db.collection('products').updateOne({
        id: element.id
      }, {
        $set: {
          stock: currentStock
        }
      })*/
    }
    // Destroy cart and paymentIntent
    req.session.cart = null;
    req.session.paymentIntent = null;

    res.send({ receipt: "receipt" })
  } else {
    res.status(500).send("Session cart was empty or invalid");
  }
});

app.listen(8000, () => {
  console.log(`Server is running on port 8000.`);
});