#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 12/13/15 11:34 AM
#    Description:
define [
  '../ng-module'
  'utils'
  't!/views.html'
], (_module, _utils, _template)->
  _module.directiveModule
  .directive('positionChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-position-charts-container', _template
    link: (scope, element, attrs)->

  ])

  .directive('positionSelectBar', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-position-select-bar', _template
    link: (scope, element, attrs)->
      scope.list = [{
          title: '白屏时间',
          name: 'first_paint',
          value: 1,
          selected:true
        },{
          title: '首屏时间',
          name: 'first_view',
          value: 4,
          selected:false
        },{
          title: '页面解析',
          name: 'dom_ready',
          value: 3,
          selected:false
        },{
          title: '完全加载',
          name: 'load_time',
          value: 5,
          selected:false
        }]
      scope.barClick = (item, index)->
        for _item in scope.list
          _item.selected = false
        scope.list[index].selected = true
        scope.$broadcast "position:data:reload", item
  ])

