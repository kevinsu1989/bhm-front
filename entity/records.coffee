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
    sql = "select a.*, 1 as flash_flag from records_history a where 
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} "

    sql += " and page_name='#{data.page_name}'" if !data.page_like

    sql += " and a.url like 'http://www.hunantv.com#{data.page_like}%'" if data.page_like

    sql += " and a.url not like 'http://www.hunantv.com/v/3/166312' and a.url not like 'http://www.hunantv.com/v/3/166386'" if data.page_like

    sql += " and browser_name='#{data.browser_name}'" if data.browser_name

    console.log sql
    
    @execute sql, cb

  # 查询播放器加载成功率
  getFlashLoadCount: (data, cb)->
    sql = "SELECT flash_load, count(*) as count FROM records_history where
    timestamp > #{data.time_start} and timestamp < #{data.time_end} and flash_load in (0,1) and flash_installed <> 0 "

    sql += " and browser_name='#{data.browser_name}' " if data.browser_name

    sql += " and page_name='#{data.page_name}'" if !data.page_like

    sql += " and url like 'http://www.hunantv.com#{data.page_like}%'" if data.page_like

    sql += " group by flash_load order by flash_load "
    console.log sql
    @execute sql, cb

  # 查询播放器JS加载成功率
  getJsLoad: (data, cb)->
    sql = "select js_load,count(*) as count from (select case when flash_js_load is not null then 1 else 0 end as js_load from records_history 
        where first_paint>0 and flash_installed=1 and cli_version='1.0.1' and timestamp > #{data.time_start} and timestamp < #{data.time_end} "

    sql += " and browser_name='#{data.browser_name}' " if data.browser_name

    sql += " and page_name='#{data.page_name}'" if !data.page_like

    sql += " and url like 'http://www.hunantv.com#{data.page_like}%'" if data.page_like

    sql += " ) a group by a.js_load"

    console.log sql

    @execute sql, cb

    
  # 查询将要备份的记录
  findRecordsToBackUp: (timeStart, timeEnd,cb)->
    sql = "select * from records where timestamp < #{timeEnd} and timestamp > #{timeStart}"
    # console.log sql
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

    sql += " group by browser_name order by value desc limit 0,5"
    console.log sql
    @execute sql, cb


  # ip
  getIp: (cb)->
    sql = "SELECT ip,count(*) as c FROM monitor.records_js_error where ip is not null group by ip order by c desc"
    # sql = "SELECT ip FROM records where ip is not null order by id desc limit 0,100"
    # sql = "SELECT ip,url,FROM_UNIXTIME(timestamp/1000, '%m-%d %H:%i') as t FROM monitor.records  where FROM_UNIXTIME(timestamp/1000, '%H')>=0 and FROM_UNIXTIME(timestamp/1000, '%H')<6 and  url like '%hunantv.com/v/1%' and flash_load=0 and flash_installed=1 and timestamp>#{time_start} "
    # sql = "select t,count(*) as c from(SELECT ip,url,FROM_UNIXTIME(timestamp/1000, '%H:%i') as t FROM monitor.records  
    # where FROM_UNIXTIME(timestamp/1000, '%H')>=0 and FROM_UNIXTIME(timestamp/1000, '%H')<6 
    # and  url like '%hunantv.com/v/1%' and flash_load=0 and flash_installed=1 and timestamp>1445356800000 )m group by t"
    # sql="SELECT ip,count(*) as c FROM monitor.records  where FROM_UNIXTIME(timestamp/1000, '%H')>=0 and FROM_UNIXTIME(timestamp/1000, '%H')<6 and  url like '%hunantv.com/v/1%' and flash_load=0 and flash_installed=1 and timestamp>#{time_start} group by ip order by c desc"
    @execute sql, cb

module.exports = new Records