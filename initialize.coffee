_path = require 'path'
_bijou = require 'bijou'
_async = require 'async'
_ = require 'lodash'
_moment = require 'moment'

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
  rule_backup = new _schedule.RecurrenceRule()
  rule_day = new _schedule.RecurrenceRule()
  rule_hour = new _schedule.RecurrenceRule()


  rule_day.dayOfWeek = [new _schedule.Range(0, 6)]
  rule_day.hour = 3
  rule_day.minute = 30

  rule_backup.dayOfWeek = [1]
  rule_backup.hour = 3
  rule_backup.minute = 30

  rule_hour.minute = 5

  # backup = _schedule.scheduleJob rule_backup, ()->
  #   _records.backUpRecords (err, result)->

  # 每天凌晨3点计算前一天的数据
  day = _schedule.scheduleJob rule_day, ()->
    _records.calculateRecordsByTime _moment().subtract(1,'day').startOf('day').valueOf(), _moment().startOf('day').valueOf(), 'day', (err, result)->

  # 每小时计算上一小时的数据
  hour = _schedule.scheduleJob rule_hour, ()->
    _records.calculateRecordsByTime _moment().subtract(1,'hour').startOf('hour').valueOf(), _moment().startOf('hour').valueOf(), 'hour', (err, result)->
    
  

module.exports = (app)->
  console.log "启动中..."
  require('./router').init(app)
  initBijou app
  initSchedule()
  # _records.calculateRecordsByTime 1444233600000, 1444320000000, 'day', (err, result)->




