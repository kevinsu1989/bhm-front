#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 4:28 PM
#    Description:

"use strict"
define [
  'ng-module'
  'utils'
  'moment'
], (_module, _utils, _moment) ->

  _module.filterModule
  .filter('unsafe', ['$sce', ($sce)->
    (text)->
      $sce.trustAsHtml(text)
  ])

  .filter('timeAgo', -> (date)->
    _moment(date).fromNow()
  )

  #如果时间为空，则返回当前时间
  .filter('dateOrNow', ->
    (date)-> date || new Date()
  )

  .filter('taskStatus', ->
    (status)->
      switch status
        when 1 then '任务入库'
        when 2 then '取消'
        when 3 then '找不到服务器'
        when 10 then '成功'
        when 99 then '失败'
        else '未知'
  )

  .filter('taskStatusType', ->
    (status)->
      switch status
        when 1 then 'info'
        when 2 then 'warning'
        when 3 then 'error'
        when 10 then 'success'
        when 99 then 'error'
        else 'warning'
  )

  .filter('projectName', ->
    (repos, ignoreMember)->
      return '' if not repos
      name = repos.replace(/.+:(.+)\.git$/, '$1')
      name = name.replace(/.+\/(.+)/ig, '$1') if ignoreMember
      name
  )

  .filter('hash2Link', ->
    (hash, repos)->
      repos.replace(/.+@(.+):(.+)\.git/, 'http://$1/$2/commit/') + hash
  )

  .filter('highlightMember', ->
    (projectName)->
      projectName.replace(/^(.+)\/(.+)/, '<span class="custom-member">$1</span>/$2')
  )

  .filter('unsafe', ['$sce', ($sce)->
    (text)->
      $sce.trustAsHtml(text)
  ])

  .filter('msFilter', [()->
    (number)->
      return 0 if !number
      number.toFixed(2)
  ])
  .filter('perFilter', [()->
    (number)->
      return 0 if !number
      Math.round(number * 10000)/100 + "%"
  ])
