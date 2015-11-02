_path = require 'path'
_bijou = require 'bijou'
_async = require 'async'
_ = require 'lodash'
_moment = require 'moment'

_config = require './config' 
_schedule = require 'node-schedule'
_records = require './biz/records'
_browser = require './biz/browser'
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
    time_start = _moment().subtract(1,'day').startOf('day').valueOf()
    time_end = _moment().startOf('day').valueOf()
    _browser.calculateBrowserRecords time_start, time_end, 'day', (err, result)->
    setTimeout(()->
      _records.calculateRecordsByTime time_start, time_end, 'day', (err, result)->
    , 30 * 1000)

  # 每小时计算上一小时的数据
  hour = _schedule.scheduleJob rule_hour, ()->
    time_start = _moment().subtract(1,'hour').startOf('hour').valueOf()
    time_end = _moment().startOf('hour').valueOf()
    _browser.calculateBrowserRecords time_start, time_end, 'hour', (err, result)->
    setTimeout(()->
      _records.calculateRecordsByTime time_start, time_end, 'hour', (err, result)->
    , 15 * 1000)
    
  

module.exports = (app)->
  console.log "启动中..."
  require('./router').init(app)
  initBijou app
  # _api.getIp()
  # initSchedule()
  # _records.calculateRecordsByTime 1446447600000, 1446451200000, 'hour', (err, result)->
  # _browser.calculateBrowserRecords 1446429600000, 1446451200000, 'hour', (err, result)->




