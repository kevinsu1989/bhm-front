
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
    sql = "select a.*, b.flag as flash_flag from records a left join records_flash b on a.hash = b.hash where 
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} and 
    a.page_name = '#{data.page_name}'"

    @execute sql, cb

  findRecordsToBackUp: (timeStart, timeEnd,cb)->
    sql = "select * from records where timestamp < #{timestamp} and timestamp > #{timeEnd}"

    @execute sql, cb

  deleteBackUpRecords: (timestamp, cb)->
    sql = "delete from records where timestamp < #{timestamp}"

    @execute sql, cb

  findPages: (cb)->
    sql = "select page_name from records where page_name is not null group by page_name"

    @execute sql, cb

  browserPercent: (data, cb)->
    sql = "select browser_name as name, count(*) as value from records a where 
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} and 
    a.page_name = '#{data.page_name}' group by browser_name"

    @execute sql, cb

module.exports = new Records