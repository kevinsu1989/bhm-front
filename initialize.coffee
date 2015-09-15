_path = require 'path'
_bijou = require 'bijou'
_async = require 'async'
_ = require 'lodash'
_config = require './config' 
_schedule = require 'node-schedule'
_records = require './biz/records'



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
    console.log 'Monitor Front is running now!'

initSchedule = ()->
  rule = new _schedule.RecurrenceRule()
  rule.dayOfWeek = [0, new _schedule.Range(1, 6)]
  rule.hour = 4
  rule.minute = 0
  j = _schedule.scheduleJob rule, ()->
    _records.calculateRecords (err, result)->

    
  

module.exports = (app)->
  console.log "启动中..."
  require('./router').init(app)
  initBijou app
  initSchedule()




