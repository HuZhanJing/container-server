const {exec, execSync} = require('child_process')
const path = require('path');
const BaseError = require('../error/BaseError');
const ErrorCodes = require('../error/ErrorCodes');
const Logger = require('../utils/Logger');
const Utils = require('../utils/Utils');

const TAG = "InstallerManager";

class InstallerManager {

  constructor() {}

  /**
   * 安装mongo
   * @param ip
   * @param port
   */
  installMongo({ip, port}) {
    const tag = "mongo";
    Utils.checkInstallParams(tag, {ip: ip, port: port})
    this.install({
      tag: tag,
      command: `sh ${path.join(process.cwd(), 'shells/mongoInstall.sh')} ${ip} ${port}`,
      errorCode: ErrorCodes.code_INSTALL_MONGO_FAILED
    })
  }

  /**
   * 安装redis
   * @param ip
   * @param port  主节点
   * @param port2 复制节点
   */
  installRedis({ip, port, port2}) {
    const tag = 'redis';
    Utils.checkInstallParams(tag, {ip: ip, port: port, port2: port2})
    this.install({
      tag: tag,
      command: `sh ${path.join(process.cwd(), 'shells/redisInstall.sh')} ${ip} ${port} ${port2}`,
      errorCode: ErrorCodes.code_INSTALL_REDIS_FAILED
    });
  }

  /**
   * 安装zookeeper
   * @param port 默认2181
   */
  installZookeeper({port}) {
    const tag = 'zookeeper';
    Utils.checkInstallParams(tag, {port: port})
    this.install({
      tag: tag,
      command: `sh ${path.join(process.cwd(), 'shells/zookeeperInstall.sh')} ${port}`,
      errorCode: ErrorCodes.code_INSTALL_ZOOKEEPER_FAILED
    });
  }

  /**
   * 安装kafka
   * @param ip
   * @param kafkaPort 默认9092
   * @param zookeeperPort 默认2181
   */
  installKafka({ip, kafkaPort, zookeeperPort}) {
    const tag = 'kafka';
    Utils.checkInstallParams(tag, {ip, kafkaPort, zookeeperPort})
    this.install({
      tag: tag,
      command: `sh ${path.join(process.cwd(), 'shells/kafkaInstall.sh')} ${ip} ${kafkaPort} ${zookeeperPort}`,
      errorCode: ErrorCodes.code_INSTALL_KAFKA_FAILED
    });
  }

  /**
   * 安装thumbor
   * @param port 默认8888
   */
  installThumbor({port}) {
    const tag = 'thumbor';
    Utils.checkInstallParams(tag, {port})
    this.install({
      tag: tag,
      command: `sh ${path.join(process.cwd(), 'shells/thumborInstall.sh')} ${port}`,
      errorCode: ErrorCodes.code_INSTALL_THUMBOR_FAILED
    });
  }

  /**
   * 安装fdfs
   * @param ip
   * @param port 默认22122
   */
  installFastDfs({ip, port}) {
    const tag = 'fastdfs';
    Utils.checkInstallParams(tag, {ip, port})
    this.install({
      tag: tag,
      command: `sh ${path.join(process.cwd(), 'shells/fdfsInstall.sh')} ${ip} ${port}`,
      errorCode: ErrorCodes.code_INSTALL_FASTDFS_FAILED
    });
  }

  /**
   * 安装turn
   * @param ip  外网ip
   * @param port  最好是443，也可以是一个四位端口
   * @param user
   * @param password
   */
  installTurn({ip, port, user, password}) {
    const tag = 'fastdfs';
    Utils.checkInstallParams(tag, {ip, port, user, password})
    this.install({
      tag: tag,
      command: `sh ${path.join(process.cwd(), 'shells/turnInstall.sh')} ${ip} ${port} ${user} ${password}`,
      errorCode: ErrorCodes.code_INSTALL_TURN_FAILED
    });
  }

  // 执行命令
  install({tag, command, errorCode}) {
    Logger.info(TAG, `start install ${tag}...`);
    try {
      // stdio: 'ignore' 忽略输出，以防buffer被战满
      // let result = execSync(command, {stdio: 'ignore'})
      let result = execSync(command)
      Logger.info(TAG, `install ${tag} result: ${result}`);
    } catch (e) {
      let eMsg = e.toString();
      Logger.warn(TAG, `install ${tag} catch eMsg: ${eMsg}`);
      if (!eMsg.includes("Unable to find image") || !eMsg.includes("Status: Downloaded newer image for"))
        throw new BaseError(errorCode, `install ${tag} failed, eMsg: ${e}`)
    }
    Logger.info(TAG, `install ${tag} finished.`);
  }

}

// exec(`sh ${path.join(process.cwd(), 'shells/mongoInstall.sh')} ${ip} ${port}`, (error, stdout, stderr) => {
//   if (error) {
//     Logger.error(TAG, `install mongo error: ${error}`);
//     return;
//   }
//   if (stdout) {
//     Logger.info(TAG, `install mongo stdout: ${stdout}`);
//   }
//   if (stderr) {
//     Logger.error(TAG, `install mongo stderr: ${stderr}`);
//   }
// });

module.exports = new InstallerManager();