const userController = require('../controllers/UserController')
const router = require('koa-router')()

router.prefix('/user')

router.get('/:id', userController.getUser)

module.exports = router;
