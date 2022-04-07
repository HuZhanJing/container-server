const log4js = require('log4js');

let logMap = new Map();

function getLogger(className) {
  if (!className)
    className = "container";
  let logger = logMap.get(className);
  if (logger)
    return logger;
  // pino
  // https://segmentfault.com/a/1190000019302858?utm_source=sf-related
  log4js.configure({
    appenders : {
      out: {
        type: "stdout",
        layout: {
          type: 'pattern',
          pattern: `%[[Timer-1-thread-%z] %p  - time: %d{yyyy-MM-dd hh:mm:ss,SSS} [%c] %m`
        }
      },
      access : {
        type : "dateFile",
        filename : './logs/server.log',
        pattern : 'yyyy-MM-dd',
        numBackups : 1
      }
      /*console : {
        type : "console"
      },
      file : {
        type : 'file',
        filename : './logs/server.log',
        maxLogSize : 20971520,
        backups : 2,
        keepFileExt: true,
        compress: false
      }*/
    },
    categories: {
      default: {
        appenders: ["out", "access", /*"console", "file"*/],
        level: "ALL"
      },
    }
  });

  logger = log4js.getLogger(className);
  logMap.set(className, logger);
  return logger;
}

function info(tag, message) {
  let logger = getLogger(tag);
  logger.info(message)
}

function warn(tag, message) {
  let logger = getLogger(tag);
  logger.warn(message);
}

function error(tag, message) {
  let logger = getLogger(tag);
  logger.error(message);
}

function fatal(tag, message) {
  let logger = getLogger(tag);
  logger.fatal(message);
}

module.exports = {
  info,
  error,
  warn,
  fatal
}