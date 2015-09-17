
_async = require 'async'
_http = require('bijou').http
_ = require 'lodash'
_entity = require '../entity'
_common = require '../common'
_ip = require 'lib-qqwry'


records = []

# timestamp = new Date().valueOf()


    
# 验证数据
# validateData = (data)->
#   reg = /^\d+(\.\d+)?$/
#   return reg.test(data.first_paint) && reg.test(data.dom_ready) && reg.test(data.load_time) && reg.test(data.first_view)


devideRecordsByTime = (records, data)->
  recordsArr = []
  timestamp = parseInt(data.time_start) + parseInt(data.timeStep)
  timeRecords = {
    time_start: data.time_start
    time_end: timestamp
    records: []
  }
  for rec in records
    if parseInt(rec.timestamp) < timestamp && rec isnt records[records.length - 1]
      timeRecords.records.push rec
    else
      if rec is records[records.length - 1] && parseInt(rec.timestamp) < timestamp
        timeRecords.records.push rec
      recordsArr.push({
        time_start: timeRecords.time_start
        time_end: timeRecords.time_end
        records: timeRecords.records
      })
      # 当两条数据时间间隔大于一个时间段时，需要插入空白数据
      total = Math.floor((rec.timestamp - timestamp)/data.timeStep)
      for index in [0...total]
        recordsArr.push({
          time_start: parseInt(timestamp) + index * data.timeStep
          time_end: parseInt(timestamp) + (index + 1)* data.timeStep
          records:[]
        })
      
      timeRecords = {
        time_start: parseInt(timestamp) + total * data.timeStep
        time_end: parseInt(timestamp) + (total + 1) * data.timeStep
        records:[rec]
      }
      timestamp += data.timeStep * (total + 1)
  #补全最后一条数据到时间终点的空白
  leftTime = Math.floor((data.time_end - timestamp)/data.timeStep)
  for index in [0...leftTime]
    recordsArr.push({
      time_start: parseInt(timestamp) + index * data.timeStep
      time_end: parseInt(timestamp) + (index + 1)* data.timeStep
      records:[]
    })
  
  recordsArr

# 计算平均值
calculateRecords = (records)->
  result = {
    first_paint: 0
    first_view: 0
    dom_ready: 0
    load_time: 0
    flash_load: 0
    pv_cal: 0 #参与计算的数据
    pv: 0 #总数据
  }
  return result if !records || records.length is 0
  for record in records
    result.first_paint += parseInt(record.first_paint)
    result.first_view += parseInt(record.first_view)
    result.dom_ready += parseInt(record.dom_ready)
    result.load_time += parseInt(record.load_time)
    result.flash_load += record.flash_load
    result.pv_cal += 1 if parseInt(record.first_paint) isnt 0

  
  if result.pv_cal > 0
    result = {
      first_paint: result.first_paint / result.pv_cal
      first_view: result.first_view / result.pv_cal
      dom_ready: result.dom_ready / result.pv_cal
      load_time: result.load_time / result.pv_cal
      flash_load: result.flash_load
      pv_cal: result.pv_cal
      pv: records.length
    }
  result


# 最终返回结果拼接
getReturns = (records, pv_count, pv_cal)->
  result = {
    first_paint: 0
    first_view: 0
    dom_ready: 0
    load_time: 0
    flash_load: 0
    pv: pv_count
    records: records
  }
  # 计算所有数据的平局值
  if records
    for record in records
      result.first_paint += record.result.first_paint * record.result.pv_cal / pv_cal
      result.first_view += record.result.first_view * record.result.pv_cal / pv_cal
      result.dom_ready += record.result.dom_ready * record.result.pv_cal / pv_cal
      result.load_time += record.result.load_time * record.result.pv_cal / pv_cal
      result.flash_load += record.result.flash_load

  result.flash_load = result.flash_load / pv_count
  result


exports.getRecords = (req, res, cb)->
  data = req.query
  _entity.records.findRecords data, (err, records)->
    result = calculateRecords records
    cb {
      time_start: data.time_start
      time_end: data.time_end
      result: result
    }
    



exports.getRecordsSplit = (req, res, cb)->
  data = req.query
  data.page_name = req.params.page_name
  data.time_start = _common.getDayStart().valueOf() if !data.time_start
  data.time_end = _common.getDayStart().valueOf() + 24 * 60 * 60 * 1000 - 1  if !data.time_end
  data.timeStep = 24 * 60 * 60 * 10 if !data.timeStep
  data.timeStep = 60 * 1000 if data.timeStep < 60 * 1000

  queue = [] 
  pv_count = 0
  pv_cal = 0
  queue.push((done)->
    _entity.records.findRecords data, (err, result)->
      pv_count = result?.length || 0
      done err, result, data
  )

  queue.push((records, data, done)->
    recordsArr = devideRecordsByTime records, data
    for records in recordsArr
      records.result = calculateRecords records.records
      pv_cal += records.result.pv_cal
      delete records.records 
    done null, recordsArr
  )

  _async.waterfall queue,(err, result)->
    cb err, getReturns(result, pv_count, pv_cal)



exports.getPages = (req, res, cb)->
  _entity.records.findPages (err, result)->
    cb err, result


# exports.receiveData = (req, res, cb)->
#   data = req.query
#   data.timestamp = new Date().valueOf()
#   data.ip = _ip.ipToInt _common.getClientIp(req)

#   records.push data if validateData(data)

#   # if new Date().valueOf() - timestamp > 10000
#   if records.length > 10
#     # timestamp = new Date().valueOf()
#     _records = records
#     records = []
#     _entity.records.addRecords _records, (err, result)->
#       cb err
#   else
#     cb null
