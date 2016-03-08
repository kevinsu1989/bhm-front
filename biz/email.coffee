_ = require 'lodash'
_async = require 'async'
_http = require('bijou').http
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'

_api = require './api'
_flash = require './flash'
_mobile = require './m_records'



exports.retrieve = (req, res, cb)->
  pages = ['首页', '底层', '综艺', '电视剧']

  query = req.query

  query.time_start = _moment().subtract(7,'day').startOf('day').valueOf() if !query.time_start
  query.time_end = _moment().startOf('day').valueOf()  if !query.time_end
  query.type = 'day'  if !query.type
  query.isSpeed = 'true'
  
  req.query = query



  queue = [] 
  result = []
  for page in pages
    ((page)->
      queue.push((done)->
        req.params.page_name = page      
        _api.retrieve req, res, (err, records)->
          result.push records
          done err
      )
    )(page)

  queue.push((done)->
    _mobile.retrieve req, res, (err, records)->
      result.push records
      done err
  )

  queue.push((done)->
    _flash.retrieve req, res, (err, records)->
      result.push records
      done err
  )

  _async.waterfall queue, (err)->

    cb err, result


