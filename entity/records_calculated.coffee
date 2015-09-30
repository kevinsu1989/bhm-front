
_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/records_calculated').schema


  saveCalculatedRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data


  findRecords: (data, cb)->
    sql = "select * from records_calculated where 
      time_start >= #{data.time_start} and time_start < #{data.time_end} and
      page_name = '#{data.page_name}' "
    
    @execute sql, cb
  
module.exports = new RecordsCalculated