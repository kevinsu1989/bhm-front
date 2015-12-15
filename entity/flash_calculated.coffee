_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class FlashRecordsCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/flash_calculated').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data


  findRecords: (data, cb)->
    sql="select pv, flash_load, cms, dispatch, ad, video_load, play,
    flash_load/pv as per_flash , cms/pv as per_cms , dispatch/pv as per_dispatch , 

    ad/pv as per_ad, video_load/pv as per_video, play/pv as per_play, time_start, time_type as type

    from flash_calculated where time_start >= #{data.time_start} and time_start < #{data.time_end}"
    sql += " and time_type='#{data.type}' "
    sql += " order by time_start"

    console.log sql
    @execute sql, cb


  findSumRecords: (data, cb)->
    sql = "select sum(ad) as ad ,sum(dispatch) as dispatch, sum(video_load) as video_load,
    sum(cms) as cms, sum(play) as play, sum(flash_load) as flash_load, sum(pv) as pv,
    (sum(ad))/sum(pv) as per_ad , sum(dispatch)/sum(pv) as per_dispatch , 
    sum(video_load)/sum(pv) as per_video , sum(cms)/sum(pv) as per_cms ,
    sum(play)/sum(pv) as per_play , sum(flash_load)/sum(pv) as per_flash 
    from flash_calculated where time_start>#{data.time_start} and time_start<#{data.time_end} "

    sql += " and time_type='#{data.type}' "
    sql += " order by time_start"

    @execute sql, cb

module.exports = new FlashRecordsCalculated