class BaseError extends Error {
  constructor(code, message) {
    super(message);
    this._code = code;
    this._message = {"message" : message}
  }

  get code() {
    return this._code
  }

  get message() {
    return this._message
  }
}

module.exports = BaseError;