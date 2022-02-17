// var createError = require('http-errors');
// var express = require('express');
const path = require('path');
// var cookieParser = require('cookie-parser');
// var logger = require('morgan');
//
// var indexRouter = require('./routes/index');
// var usersRouter = require('./routes/users');



const Koa = require('koa');
const router = require('koa-router')();
const userRouter = require('./routes/users');
const staticServe = require('koa-static')
const historyApiFallback = require('koa-history-api-fallback');
const BaseError = require('./error/BaseError');


const app = new Koa();

// 拦截url
app.use(async (ctx, next) => {
  if (ctx.request.url.includes("/rest/")) {
    try {
      await next();
      ctx.body = {code: 1, data: ctx.body};
    } catch (e) {
      if (e instanceof BaseError)
        ctx.body = {code: e.code, message: e.message}
    }
  } else {
    // handle web page, such as 404...
    await next();
  }
});

// 路由信息
router.prefix("/rest")
router.use(userRouter.routes());
app.use(router.routes());

// 静态资源，放在设置router之后
app.use(historyApiFallback())
app.use(staticServe(path.join(__dirname, 'dist')))

app.listen(8000,() => {
  console.log('Koa is listening in 8000');
});

module.exports = app;





// var app = express();
//
// // view engine setup
// app.set('views', path.join(__dirname, 'views'));
// app.set('view engine', 'pug');
//
// app.use(logger('dev'));
// app.use(express.json());
// app.use(express.urlencoded({ extended: false }));
// app.use(cookieParser());
// // app.use(express.static(path.join(__dirname, 'public')));
// // app.use('/', indexRouter);
// // app.use('/users', usersRouter);
//
// app.use(express.static(path.join(__dirname, 'dist')));
// app.get('/', function(req,res){
//   res.sendFile(__dirname, './dist/index.html')
// })
//
// app.get('/rest/', function (req, res) {
//
// })
//
//
// // catch 404 and forward to error handler
// app.use(function(req, res, next) {
//   next(createError(404));
// });
//
// // error handler
// app.use(function(err, req, res, next) {
//   // set locals, only providing error in development
//   res.locals.message = err.message;
//   res.locals.error = req.app.get('env') === 'development' ? err : {};
//
//   // render the error page
//   res.status(err.status || 500);
//   res.render('error');
// });
//
// module.exports = app;
