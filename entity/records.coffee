
_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class Records extends _BaseEntity
  constructor: ()->
    super require('../schema/records').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data


  findRecords: (data, cb)->
    sql = "select * from records where 
    timestamp > #{data.time_start} and timestamp < #{data.time_end} and 
    page_name = '#{data.page_name}'"

    @execute sql, cb

  findRecordsToBackUp: (data, cb)->
    sql = "select * from records where timestamp < #{data.timestamp}"

    @execute sql, cb

  findPages: (cb)->
    sql = "select page_name from records where page_name is not null group by page_name"

    @execute sql, cb

module.exports = new Records