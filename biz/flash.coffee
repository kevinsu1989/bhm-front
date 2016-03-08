_ = require 'lodash'
_async = require 'async'
_http = require('bijou').http
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'



exports.retrieve = (req, res, cb)->
  query = req.query
  query.time_start = _common.getDayStart().valueOf() if !query.time_start
  query.time_end = _common.getDayStart().valueOf() + 24 * 60 * 60 * 1000 - 1  if !query.time_end
  query.type = 'hour'  if !query.type

  queue = [] 

  queue.push((done)->
    _entity.flash_calculated.findRecords query, (err, result)->
      done err, result
  )

  queue.push((records, done)->
    _entity.flash_calculated.findSumRecords query, (err, result)->
      result[0].records = records if result
      
      done err, result[0]
  )

  _async.waterfall queue,(err, data)->

    cb err, data

