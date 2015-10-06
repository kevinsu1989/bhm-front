#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:计算后的数据


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
    sql += " and browser_name='#{data.browser_name}'" if data.browser_name

    @execute sql, cb
  
module.exports = new RecordsCalculated