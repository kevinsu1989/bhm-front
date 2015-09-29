_api = require './api'
_async = require 'async'
_http = require('bijou').http
_ = require 'lodash'
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'


calculateByPage = (time, pageName, cb)->
  req = {
    query: {
      time_start: time.timeStart,
      time_end: time.timeEnd,
      timeStep: time.timeStep
    },
    params:{
      page_name: pageName
    }
  } 

  queue = []

  queue.push(
    (done)->
      _api.getRecordsSplit req, null, (err, result)->
        console.log result
        done err, result, time
  )

  queue.push(
    (result, time, done)->
      pv_cal = 0
      for record in result.records
        record[key] = value for key, value of record.result
        record.page_name = pageName
        record.type = 'hour'
        pv_cal += record.pv_cal
        delete record.result
      
      result.records.push({
        time_start: time.timeStart,
        time_end: time.timeEnd,
        first_paint: result.first_paint,
        first_view: result.first_view,
        dom_ready: result.dom_ready,
        load_time: result.load_time,
        flash_load: result.flash_load,
        pv: result.pv,
        pv_cal: pv_cal,
        page_name: pageName,
        type: 'day'
      })

      _entity.records_calculated.saveCalculatedRecords result.records, done
  )


  _async.waterfall queue, (err, result)->

    console.log arguments
    cb err, result




exports.calculateRecords = ()->
  console.log "开始统计#{_moment().subtract(1,'day').format('YYYYMMDD')}的数据"
  _entity.records.findPages (err, pages)->
    records = []
    time = {
      timeStart: _moment().subtract(1,'day').startOf('day').valueOf()
      timeEnd: _moment().startOf('day').valueOf() - 1
      timeStep: 60 * 60 * 1000
    }
    for page in pages
      calculateByPage time, page.page_name, (err, result)->
      
  

exports.backUpRecords = ()->
  console.log "开始备份#{_moment().startOf('week').format('YYYYMMDD')}到#{_moment().subtract(1,'day').format('YYYYMMDD')}的数据"
  timeStart = _moment().startOf('week').valueOf()
  timeStart = 0
  timeEnd = _moment().startOf('day').valueOf() - 1
  queue = []
  queue.push(
    (done)->
      _entity.records.findRecordsToBackUp timeStart, timeEnd, (err, result)->
        console.log result.length
        done err, result
  )
  
  queue.push(
    (result, done)->
      _entity.records_history.saveHistoryRecords result, (err, result)->
        console.log "备份完成"
        done err, result
  )
  # queue.push(
  #   (result, done)->
  #     _entity.records.deleteBackUpRecords timestamp, (err, result)->
  #       done err, result
  # )

  _async.waterfall queue, (err, result)->


