const BaseError = require('../error/BaseError');

function getUser(ctx, next) {
  ctx.body = {name: "xiaoming", id: ctx.params.id}
  // throw new BaseError(300, "hahah")
}

module.exports = {
  getUser
}