
_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsFlash extends _BaseEntity
    constructor: ()->
      super require('../schema/records_flash').schema

module.exports = new RecordsFlash