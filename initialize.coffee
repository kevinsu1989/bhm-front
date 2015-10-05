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
  rule_calculate = new _schedule.RecurrenceRule()
  rule_backup = new _schedule.RecurrenceRule()
  rule_hour = new _schedule.RecurrenceRule();


  rule_calculate.dayOfWeek = [new _schedule.Range(0, 6)]
  rule_calculate.hour = 18
  rule_calculate.minute = 44

  rule_backup.dayOfWeek = [1]
  rule_backup.hour = 3
  rule_backup.minute = 30

  rule_hour.minute = 5
  # 每天定时计算
  # calculate = _schedule.scheduleJob rule_calculate, ()->
  #   _records.calculateRecords (err, result)->
  # 每周数据备份
  backup = _schedule.scheduleJob rule_backup, ()->
    # _records.backUpRecords (err, result)->
      
  # 每小时计算上一小时的数据
  hour = _schedule.scheduleJob rule_hour, ()->
    # _records.calculateRecordsByHour (err, result)->
    
  

module.exports = (app)->
  console.log "启动中..."
  require('./router').init(app)
  initBijou app
  initSchedule()
  # _records.calculateRecordsByHour (err, result)->




