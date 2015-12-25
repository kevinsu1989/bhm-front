_path = require 'path'
_bijou = require 'bijou'
_async = require 'async'
_ = require 'lodash'

_config = require './config' 
_schedule = require './biz/schedule'
_api = require './biz/api'


#初始化bijou
initBijou = (app)->
  options =
    log: process.env.DEBUG
    #指定数据库链接
    database: _config.database
    #指定路由的配置文件
    routers: []

  _bijou.initalize(app, options)

  queue = []
  queue.push(
    (done)->
      #扫描schema，并初始化数据库
      schema = _path.join __dirname, './schema'
      _bijou.scanSchema schema, done
  )

  _async.waterfall queue, (err)->
    console.log err if err
    console.log 'BHM Front is running now!'


module.exports = (app)->
  console.log "启动中..."
  require('./router').init(app)
  initBijou app
  # _records.calculateRecordsByTime 1450846800000, 1450857600000, 'hour', (err, result)->
  _flash.calculateRecordsByTime 1450407600000, 1451008800000, 'hour', (err, result)->
  # _browser.calculateBrowserRecords 1450850400000, 1450857600000, 'hour', (err, result)->




