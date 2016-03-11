#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 3/19/15 11:20 AM
#    Description: 处理路由以及socket
_async = require 'async'
_http = require('bijou').http

# _config = require './config'
_cluster = require 'cluster'


_api = require './biz/api'
_records = require './biz/records'
_mrecords = require './biz/m_records'
_browser = require './biz/browser'
_flash = require './biz/flash'
_email = require './biz/email'




_cheerio = require 'cheerio'
_request = require 'request'

receiveData = (req, res, next)->
  _api.receiveData req, res, (err, result)-> _http.responseJSON err, result, res

getRecordsSplit = (req, res, next)->
  _api.retrieve req, res, (err, result)-> _http.responseJSON err, result, res

getRecords = (req, res, next)->
  _api.getRecords req, res, (err, result)-> _http.responseJSON err, result, res

getPages = (req, res, next)->
  _api.getPages req, res, (err, result)-> _http.responseJSON err, result, res


getMRecords = (req, res, next)->
  _mrecords.retrieve req, res, (err, result)-> _http.responseJSON err, result, res

getFlashRecords = (req, res, next)->
  _flash.retrieve req, res, (err, result)-> _http.responseJSON err, result, res

##########################

calRecords = (req, res, next)->
  return if !req.query.time_start || !req.query.time_end || !req.query.type
  _records.calculateRecordsByTime req.query.time_start * 1, req.query.time_end * 1, req.query.type, (err, result)->
    _http.responseJSON err, result, res

calBrowser = (req, res, next)->
  return if !req.query.time_start || !req.query.time_end || !req.query.type
  _browser.calculateBrowserRecords req.query.time_start * 1, req.query.time_end * 1, req.query.type, (err, result)->
    _http.responseJSON err, result, res

getIp = (req, res, next)->
  _api.getIp req, res, (err, result)-> _http.responseJSON err, result, res

getUA = (req, res, next)->
  _api.getUA req, res, (err, result)-> _http.responseJSON err, result, res


getEmail = (req, res, next)->
  _email.retrieve req, res, (err, result)-> _http.responseJSON err, result, res

getImg = (req, res, next)->
  _request 'http://172.31.13.173/document/2016/',(err, content)->
    url = []
    $a = _cheerio.load(content.body)('a')
    url.push("http://172.31.13.173/document/2016/#{$a.eq(index).attr('href')}") for index in [1...$a.length]
    _http.responseJSON err, url, res
#初始化路由
exports.init = (app)->

  #收集数据
  app.get '/api/receive', receiveData
  #页面
  app.get '/api/pages', getPages
  #批量分析
  app.get '/api/pages/:page_name', getRecordsSplit
  #定时分析
  app.get '/api/pages/:page_name/recent', getRecords

  #M站
  app.get '/api/mpage', getMRecords
  #flash统计
  app.get '/api/flash', getFlashRecords

  ################################

  #计算数据
  app.get '/api/cal/records', calRecords
  #计算浏览器占比
  app.get '/api/cal/browser', calBrowser
  #计算ip
  app.get '/api/ip', getIp
  #计算ua
  app.get '/api/ua', getUA



  app.get '/api/email', getEmail


  app.get '/api/img', getImg


  app.get /(\/\w+)?$/, (req, res, next)-> res.sendfile 'static/index.html'






