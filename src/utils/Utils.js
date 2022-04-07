const ErrorCodes = require('../error/ErrorCodes');
const BaseError = require('../error/BaseError');

function checkInstallParams(tag, params) {
  Object.keys(params).forEach((key) => {
    let value = params[key];
    if (!value) {
      throw new BaseError(ErrorCodes.code_BAD_PARAMS, `install ${tag} error, bad params, ${key} ${value}`);
    }
  })
}

module.exports = {
  checkInstallParams
}