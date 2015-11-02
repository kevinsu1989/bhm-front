_schedule = require 'node-schedule'
_records = require './records'
_browser = require './browser'
_api = require './api'
_moment = require 'moment'
_child = require 'child_process'


report = ()->
  req = 
    query:{
      time_start: _moment().subtract(1,'day').startOf('day').valueOf()
      time_end: _moment().startOf('day').valueOf() - 1
      type: 'day'
      isSpeed: 'true'
    },  
    params:{
      page_name: '底层'
    }

  _api.getRecordsSplit req, null, (err, result)->
    # console.log result.records[0]
    sendMsg(result.records[0].result)



sendMsg = (record)->
  console.log record.result
  text = "
      播放器加载成功率：#{Math.round(record.flash_percent*10000)/100}%,\\n
      白屏时间：#{record.first_paint}ms,
      页面解析：#{record.dom_ready}ms,
      首屏时间：#{record.first_view}ms,
      完全加载：#{record.load_time}ms。\\n
  "

  send_options = "{\"text\":\"昨日【#{record.page_name}】统计数据\",\"attachments\":[{\"title\":\"【#{record.page_name}】\",\"text\":\"#{text}\",\"color\":\"#ffa500\"}]}"

  command = "curl -H \"Content-Type: application/json\" -d '"+send_options+"' \"https://hook.bearychat.com/=bw7by/incoming/088146355989e6687d1d3b35acd608de\" ";

  options =
    env: 'dev',
    maxBuffer: 20 * 1024 * 1024


  exec = _child.exec(command, options);

exports.initReportSchedule = ()->

  rule_day = new _schedule.RecurrenceRule()

  rule_day.hour = 17
  rule_day.minute = 32
  rule_day.second = 30
  report()
  day = _schedule.scheduleJob rule_day, report






exports.initSchedule = ()->
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

 