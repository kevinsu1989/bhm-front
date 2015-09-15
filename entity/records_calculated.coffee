
_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/records_calculated').schema


  saveCalculatedRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

module.exports = new RecordsCalculated