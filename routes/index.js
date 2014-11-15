var express = require('express');
var router = express.Router();

var debug = require('debug')('AST_myApp');

/* GET home page. */
router.get('/', function(req, res) {
  debug("get home");
  res.render('index', { title: 'AST Project' });
});

/* Render connection page */
router.post('/dashboard', function (req, res) {
  if (!req.body.username || !req.body.password) {
    debug("username or password empty go login page")
    return res.redirect('/');
  }
  //debug("post connection: " + req.body.user + " - " + req.user);
  res.render('dashboard', {
    title: 'Dashboard',
    user: req.body.username,
    pass: req.body.password
    });
});

module.exports = router;
