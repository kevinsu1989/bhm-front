
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
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} "


    if data.page_name is '电视剧'
      sql += " and page_name='底层' and a.url like 'http://www.hunantv.com/v/2%'" 
    else if data.page_name is '底层'
      sql += " and page_name='底层' and a.url not like 'http://www.hunantv.com/v/2%'"
    else
      sql += " and page_name='#{data.page_name}'" 


    sql += " and browser_name='#{data.browser_name}'" if data.browser_name

    @execute sql, cb

  getFlashLoadCount: (data, cb)->
    sql = "SELECT flash_load, count(*) as count FROM records where
    timestamp > #{data.time_start} and timestamp < #{data.time_end} and flash_load in (0,1) and flash_installed <> 0 "
    sql += " and browser_name='#{data.browser_name}' " if data.browser_name


    if data.page_name is '电视剧'
      sql += " and page_name='底层' and url like 'http://www.hunantv.com/v/2%'" 
    else if data.page_name is '底层'
      sql += " and page_name='底层' and url not like 'http://www.hunantv.com/v/2%'"
    else
      sql += " and page_name='#{data.page_name}'" 


    sql += "group by flash_load order by flash_load "

    console.log sql

    @execute sql, cb

  findFlashRecords: (data, cb)->
    sql = "select count(*) as flash_count from records_flash a where a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} "

    if data.page_name is '完美假期-首页'
      sql += " and a.url like '%http://www.hunantv.com/wmjq%'" 
    else
      sql += " and a.url not like '%http://www.hunantv.com/wmjq%'" 

    @execute sql, cb


  findRecordsToBackUp: (timeStart, timeEnd,cb)->
    sql = "select * from records where timestamp < #{timestamp} and timestamp > #{timeEnd}"

    @execute sql, cb

  deleteBackUpRecords: (timestamp, cb)->
    sql = "delete from records where timestamp < #{timestamp}"

    @execute sql, cb

  # findPages: (cb)->
  #   sql = "select page_name from records where page_name is not null group by page_name"

  #   @execute sql, cb

  browserPercent: (data, cb)->
    sql = "select browser_name as name, count(*) as value from records a where 
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} and 
    a.page_name = '#{data.page_name}' group by browser_name order by value asc"

    @execute sql, cb

module.exports = new Records