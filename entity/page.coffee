#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description: 页面配置

_BaseEntity = require('bijou').BaseEntity
_async = require 'async'


class Page extends _BaseEntity
  constructor: ()->
    super require('../schema/page').schema


  findPages: (req, cb)->
    sql = "select * from page where is_show = 1"
    sql += " and parent=#{req.query.parent}" if req.query.parent
    sql += " or id=#{req.query.parent}" if req.query.parent

    console.log sql
    @execute sql, cb



module.exports = new Page