_api = require './api'
_async = require 'async'
_http = require('bijou').http
_ = require 'lodash'
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'


calculateByPage = (timeStart, timeEnd, pageName, cb)->
  req = {
    query: {
      time_start: timeStart,
      time_end: timeEnd,
      timeStep: 10 * 60 *1000
    },
    params:{
      page_name: pageName
    }
  } 

  queue = []

  queue.push(
    (done)->
      _api.getRecordsSplit req, null, (err, result)->
        done err, result.records
  )

  queue.push(
    (records, done)->
      for record in records
        record[key] = value for key,value of record.result
        record.page_name = pageName
        delete record.result
      console.log records
      _entity.records_calculated.saveCalculatedRecords records, done
  )


  _async.waterfall queue, (err, result)->
    cb err, result


exports.calculateRecords = ()->
  _entity.records.findPages (err, pages)->
    timeStart = _moment().subtract(1,'day').startOf('day').valueOf()
    timeEnd = _moment().startOf('day').valueOf() - 1
    console.log new Date()
    console.log timeStart
    console.log timeEnd
    records = []
    for page in pages
      calculateByPage timeStart, timeEnd, page.page_name, (err, result)->
      
  

exports.backUpRecords = (timestamp)->
  queue = []
  queue.push(
    (done)->
      _entity.records.findRecordsToBackUp timestamp, (err, result)->
        done err, result
  )
  
  queue.push(
    (result, done)->
      _entity.records_history.saveHistoryRecords result, (err, result)->
        done err, result
  )

  _async.waterfall queue, (err, result)->


