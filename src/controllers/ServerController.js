const BaseError = require('../error/BaseError');
const installerManager = require('../intallers/InstallerManager');
const ErrorCodes = require('../error/ErrorCodes');
const Logger = require('../utils/Logger');
const Utils = require('../utils/Utils');

const TAG = "ServerController";

function installServer(ctx, next) {
  const body = ctx.request.body

  // install mongo
  let mongoInfo = body.mongo;
  Utils.checkInstallParams("mongo", {mongoInfo})
  if (mongoInfo.enabled !== false)
    installerManager.installMongo({ip: mongoInfo.ip, port: mongoInfo.port});

  // install redis
  let redisInfo = body.redis;
  Utils.checkInstallParams("redis", {redisInfo});
  if (redisInfo.enabled !== false)
    installerManager.installRedis({ip: redisInfo.ip, port: redisInfo.port, port2: redisInfo.port2});

  // install zookeeper
  let zookeeperInfo = body.zookeeper;
  Utils.checkInstallParams("zookeeper", {zookeeperInfo});
  if (zookeeperInfo.enabled !== false)
    installerManager.installZookeeper({port: zookeeperInfo.port});

  // install kafka
  let kafkaInfo = body.kafka;
  Utils.checkInstallParams("kafka", {kafkaInfo});
  if (kafkaInfo.enabled !== false)
    installerManager.installKafka({ip: kafkaInfo.ip, kafkaPort: kafkaInfo.port, zookeeperPort: kafkaInfo.zookeeperPort});

  // install thumbor
  let thumborInfo = body.thumbor;
  Utils.checkInstallParams("thumbor", {thumborInfo});
  if (thumborInfo.enabled !== false)
    installerManager.installThumbor({port: thumborInfo.port});

  // install fastDfs
  let fdfsInfo = body.fdfs;
  Utils.checkInstallParams("fastdfs", {fdfsInfo});
  if (fdfsInfo.enabled !== false)
    installerManager.installFastDfs({ip: fdfsInfo.ip, port: fdfsInfo.port});

  // install turn
  let turnInfo = body.turn;
  Utils.checkInstallParams("turn", {turnInfo});
  if (turnInfo.enabled !== false)
    installerManager.installTurn({ip: turnInfo.ip, port: turnInfo.port, user: turnInfo.user, password: turnInfo.password});
}

module.exports = {
  installServer
}