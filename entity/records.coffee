#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:基础数据处理


_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class Records extends _BaseEntity
  constructor: ()->
    super require('../schema/records').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

  # 查询基础数据    
  findRecords: (data, cb)->
    sql = "select a.*, b.flag as flash_flag from records a left join records_flash b on a.hash = b.hash where 
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} "

    sql += " and page_name='#{data.page_name}'" if !data.page_like

    sql += " and a.url like 'http://www.hunantv.com#{data.page_like}%'" if data.page_like

    sql += " and browser_name='#{data.browser_name}'" if data.browser_name

    console.log sql
    
    @execute sql, cb

  # 查询播放器加载成功率
  getFlashLoadCount: (data, cb)->
    sql = "SELECT flash_load, count(*) as count FROM records where
    timestamp > #{data.time_start} and timestamp < #{data.time_end} and flash_load in (0,1) and flash_installed <> 0 "

    sql += " and browser_name='#{data.browser_name}' " if data.browser_name

    sql += " and page_name='#{data.page_name}'" if !data.page_like

    sql += " and url like 'http://www.hunantv.com#{data.page_like}%'" if data.page_like

    sql += " group by flash_load order by flash_load "

    console.log sql

    @execute sql, cb

  # 查询将要备份的记录
  findRecordsToBackUp: (timeStart, timeEnd,cb)->
    sql = "select * from records where timestamp < #{timeEnd} and timestamp > #{timeStart}"
    console.log sql
    @execute sql, cb
  
  # 删除备份好的记录
  deleteBackUpRecords: (timestamp, cb)->
    sql = "delete from records where timestamp < #{timestamp}"

    @execute sql, cb

  # 浏览器占比
  browserPercent: (data, cb)->
    sql = "select browser_name as name, count(*) as value from records a where 
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} "

    sql += " and page_name='#{data.page_name}'" if !data.page_like

    sql += " and url like 'http://www.hunantv.com#{data.page_like}%'" if data.page_like

    sql += " group by browser_name order by value asc"

    @execute sql, cb

module.exports = new Records