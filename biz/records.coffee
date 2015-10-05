#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:

_api = require './api'
_async = require 'async'
_http = require('bijou').http
_ = require 'lodash'
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'


calculateByPage = (time, page, cb)->
  req = {
    query: {
      time_start: time.timeStart,
      time_end: time.timeEnd,
      timeStep: time.timeStep,
      page_like: page.page_like
    },
    params:{
      page_name: page.page_name
    }
  } 

  queue = []

  queue.push(
    (done)->
      _api.getRecordsSplit req, null, (err, result)->
        done err, result, time
  )

  queue.push(
    (result, time, done)->
      pv_cal = 0
      for record in result.records
        record[key] = value for key, value of record.result
        record.page_name = page.page_name
        record.flash_percent = 0.123
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
        flash_percent: result.flash_load,
        pv: result.pv,
        pv_cal: pv_cal,
        page_name: page.page_name,
        type: 'day'
      })
      _entity.records_calculated.saveCalculatedRecords result.records, done
  )


  _async.waterfall queue, (err, result)->
    cb err, result

calculateByHour = (time, page, cb)->
  req = {
    query: {
      time_start: time.timeStart,
      time_end: time.timeEnd,
      timeStep: time.timeStep,
      page_like: page.page_like
    },
    params:{
      page_name: page.page_name
    }
  } 

  queue = []

  queue.push(
    (done)->
      _api.getRecordsSplit req, null, (err, result)->
        done err, result, time
  )

  queue.push(
    (result, time, done)->
      record = {
        time_start: time.timeStart,
        time_end: time.timeEnd,
        first_paint: result.first_paint,
        first_view: result.first_view,
        dom_ready: result.dom_ready,
        load_time: result.load_time,
        flash_percent: result.flash_load,
        pv: result.pv,
        pv_cal: result.records[0].result.pv_cal,
        page_name: page.page_name,
        flash_count: result.flash_count,
        type: 'hour'
      }
      _entity.records_calculated.saveCalculatedRecords [record], done
  )


  _async.waterfall queue, (err, result)->
    cb err, result



exports.calculateRecordsByHour = ()->
  _entity.page.findPages (err, pages)->
    records = []
    time = {
      timeStart: _moment().subtract(1,'hour').startOf('hour').valueOf()
      timeEnd: _moment().startOf('hour').valueOf() - 1
      timeStep: 60 * 60 * 1000
    }
    for page in pages
      calculateByHour time, page, (err, result)->



exports.calculateRecords = ()->
  console.log "开始统计#{_moment().subtract(1,'day').format('YYYYMMDD')}的数据"
  _entity.page.findPages (err, pages)->
    records = []
    time = {
      timeStart: _moment().subtract(1,'day').startOf('day').valueOf()
      timeEnd: _moment().startOf('day').valueOf() - 1
      timeStep: 60 * 60 * 1000
    }
    for page in pages
      calculateByPage time, page, (err, result)->




      
  

exports.backUpRecords = ()->
  console.log "开始备份#{_moment().startOf('week').format('YYYYMMDD')}到#{_moment().subtract(1,'day').format('YYYYMMDD')}的数据"
  timeStart = _moment().startOf('week').valueOf()
  timeStart = 0
  timeEnd = _moment().startOf('day').valueOf() - 1
  queue = []
  queue.push(
    (done)->
      _entity.records.findRecordsToBackUp timeStart, timeEnd, (err, result)->
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


