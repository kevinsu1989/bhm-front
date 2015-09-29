
_BaseEntity = require('bijou').BaseEntity
_async = require 'async'


class Page extends _BaseEntity
  constructor: ()->
    super require('../schema/page').schema


  findPages: (cb)->
    sql = "select * from page"

    @execute sql, cb



module.exports = new Page