_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsHistory extends _BaseEntity
  constructor: ()->
    super require('../schema/records_history').schema


  saveHistoryRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

module.exports = new RecordsHistory