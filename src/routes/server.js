const serverController = require('../controllers/ServerController')
const router = require('koa-router')()

router.prefix('/server')

// router.get('/:id', userController.getUser)

router.post('/install', serverController.installServer)

module.exports = router;
