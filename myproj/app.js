
var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mysql = require('mysql2');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// Database connection setup
var db = mysql.createConnection({
  host: '34.173.61.66',  // GCP database host
  user: 'root',  //  database username
  password: 'test1234',  // database password
  database: 'uiuc_course_hub'  // database name
});

// Connect to the database
db.connect(function(err) {
  if (err) throw err;
  console.log("Connected to database!");
});

// Route to handle the search form submission and fetch data based on user-entered CRN
app.get('/search', function(req, res, next) {
  // Extract the CRN from the query string
  const userCRN = req.query.CRN;

  // Validate that the CRN is a numeric value
  if (!userCRN || isNaN(userCRN)) {
    return res.status(400).json({ message: 'A valid CRN is required' });
  }

  // Construct the query
  const query = 'SELECT * FROM GPAHistory WHERE CRN = ?';

  // Execute the query with the CRN parameter
  db.query(query, [userCRN], function(err, results) {
    if (err) {
      // Handle any database errors
      return next(err);
    }
    // Send the results back to the client
    if (results.length > 0) {
      res.json(results);
    } else {
      // If no results found, send an appropriate response
      res.status(404).json({ message: 'No records found for the provided CRN' });
    }
  });
});

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});


const PORT = 80; 
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
});
module.exports = app;
