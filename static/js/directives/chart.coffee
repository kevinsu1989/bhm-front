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
  .directive('mainChart', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (page_name, page)->
        require ['chart/main-chart'], (_mainChart)->
          chart = new _mainChart(element[0])
          API.pages(page_name).retrieve({isSpeed:$rootScope.isSpeed,type:$rootScope.type}).then (result)->
          # API.pages('动漫').retrieve({page_like:'/v/3',time_end:1448236800000,time_start:1444867200000}).then (result)->
            scope.loading = false
            scope.$broadcast 'main:chart:loaded', result, page
            chart.reload result.records
      scope.$on 'pages:menu:loaded',(event, page_name, page)->
        loadChart page_name, page

      scope.$on 'main:data:loaded', (event, data, page)->
        if data.records
          if chart.reload
            chart.reload data.records, scope.title, scope.cntitle 
          else
            loadChart data


  ])



  .directive('childChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@", cntitle: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/child-chart'], (_chart)->
          chart = new _chart(element[0])

          chart.reload data.records, scope.title, scope.cntitle

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if data.records
          if chart.reload
            chart.reload data.records, scope.title, scope.cntitle 
          else
            loadChart data


  ])

  .directive('pieChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/pie-chart'], (_chart)->
          chart = new _chart(element[0])

          chart.reload data.browser, scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if data.browser
          if chart.reload
            chart.reload data.browser, scope.title 
          else
            loadChart data

  ])

  .directive('gaugeChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@", field: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/gauge-chart'], (_chart)->
          chart = new _chart(element[0])

          chart.reload data[scope.field], scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if data[scope.field]
          if chart.reload
            chart.reload data[scope.field], scope.title 
          else
            loadChart data

  ])

  .directive('barChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/bar-chart'], (_chart)->
          chart = new _chart(element[0])

          chart.reload data, scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if chart.reload
          chart.reload data, scope.title
        else
          loadChart data

  ])

  .directive('linePiledChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/line-piled-chart'], (_chart)->
          chart = new _chart(element[0])

          chart.reload data, scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if chart.reload
          chart.reload data, scope.title
        else
          loadChart data

  ])

  .directive('funnelChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/funnel-chart'], (_chart)->
          chart = new _chart(element[0])
          chart.reload data, scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if chart.reload
          chart.reload data, scope.title
        else
          loadChart data

  ])


  .directive('playerBarChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/player-bar-chart'], (_chart)->
          chart = new _chart(element[0])
          chart.reload data, scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if chart.reload
          chart.reload data, scope.title
        else
          loadChart data

  ])

  .directive('playerLineChart', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    scope: title: "@"
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        require ['chart/player-line-chart'], (_chart)->
          chart = new _chart(element[0])
          chart.reload data.records, scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if chart.reload
          chart.reload data.records, scope.title
        else
          loadChart data

  ])

  .directive('ieChart', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      chart = {}
      loadChart = (data)->
        data = [{
          time_start:1448121600000,
          IE9: 830,
          IE8: 2789,
          IE7: 529,
          IE6: 1,
          IE11: 934,
          IE10: 485
        }]
        require ['chart/ie-chart'], (_chart)->
          chart = new _chart(element[0])

          chart.reload data, scope.title

      scope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      scope.$on 'main:data:loaded', (event, data, page)->
        if chart.reload
          chart.reload data, scope.title
        else
          loadChart data


  ])