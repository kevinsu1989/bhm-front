#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:计算后的数据


_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/m_records_calculated').schema


  findRecords: (data, cb)->
    sql = "select pv, detail, source, vv, app, 
    (vv+app)/pv as pv2vv , app/pv as pv2app , detail/pv as pv2detail , source/pv as pv2source, time_start, time_type as type
    from m_records_calculated where time_start>#{data.time_start} and time_start<#{data.time_end} "

    sql += " and time_type='#{data.type}' "
    sql += " order by time_start"

    @execute sql, cb

  findSumRecords: (data, cb)->
    sql = "select sum(pv) as pv, sum(detail) as detail, sum(source) as source, sum(vv) as vv, sum(app) as app, 
    (sum(vv)+sum(app))/sum(pv) as pv2vv , sum(app)/sum(pv) as pv2app , sum(detail)/sum(pv) as pv2detail , sum(source)/sum(pv) as pv2source 
    from m_records_calculated where time_start>#{data.time_start} and time_start<#{data.time_end} "

    sql += " and time_type='#{data.type}' "
    sql += " order by time_start"

    @execute sql, cb

module.exports = new RecordsCalculated