#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 11:34 AM
#    Description:

define [
  'ng'
  'utils'
  't!/views.html'
], (_ng, _utils, _template)->
  _ng.module("app.directives", ['app.services', 'app.filters'])


  .directive('mainLeftMenu', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-main-left-menu', _template
    link: (scope, element, attrs)->
      scope.loading = true
      API.pages().retrieve().then (result)->
        $rootScope.page_name = result[0].page_name
        scope.pages = result
        scope.$emit 'pages:menu:loaded', result[0].page_name, 'index'

      scope.showItems = (page,show)->
        page.show_items = show


      scope.pageChange = (page, show_id)->
        scope.$emit "pages:menu:click", page, show_id

  ])
  .directive('mainTopMenu', ['$rootScope', '$interval', ($rootScope, $interval)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-main-top-menu', _template
    link: (scope, element, attrs)->
      timer = null
      query = {}
      $rootScope.isSpeed = true
      $rootScope.type = 'hour'

      scope.reload = loadBySelect = (timeType)->
        $rootScope.type = scope.type
        timestamp = new Date().valueOf()

        if timeType is 0
          scope.time_start = scope.time_end = null 
          if Number(scope.timeSelect) > 0
            query.time_start = timestamp - scope.timeSelect * 60 *1000
            query.time_end = timestamp
            query.timeStep = scope.timeSelect * 60 *10
          else
            timeObj = _utils.getQueryTime(scope.timeSelect)
            query.time_start = timeObj.time_start
            query.time_end = timeObj.time_end
            query.timeStep = timeObj.timeStep
        else if timeType is 1 && scope.time_start && scope.time_end
          scope.timeSelect = null
          query.time_start = new Date(scope.time_start).valueOf()
          query.time_end = new Date(scope.time_end).valueOf()
          query.timeStep = (new Date(scope.time_end).valueOf() - new Date(scope.time_start).valueOf()) / 100
        query.type = scope.type
        query.browser_name = scope.browser_name
        query.page_like = $rootScope.query.page_like if $rootScope.query.page_like
        scope.$emit 'top:menu:select', query


      scope.autoLoad = ()->
        if scope.isAuto
          timer = $interval loadBySelect, 60 * 1000
        else
          $interval.cancel timer

      scope.speedLoad = ()->
        $rootScope.isSpeed = scope.isSpeed

      scope.WITHOUTIE7 = ()->
        $rootScope.ie7 = scope.ie7

      scope.showTable = ()->
        $rootScope.$emit 'table:show'

  ])



  .directive('mainTopInfo', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-main-top-info', _template
    link: (scope, element, attrs)->
      
      $rootScope.$on 'main:chart:loaded', (event, data)->
        scope.records = data
      $rootScope.$on 'main:data:loaded', (event, data)->
        scope.records = data

  ])
  
  .directive('recordsTable', ['$rootScope', ($rootScope)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-data-table', _template
    link: (scope, element, attrs)->
      scope.show = false
      loadTable = (data)->
        scope.data = data.records

      $rootScope.$on 'main:chart:loaded',(event, data)->
        loadTable data

      $rootScope.$on 'main:data:loaded', (event, data)->
        loadTable data

      $rootScope.$on 'table:show', (event)->
        scope.show = !scope.show

      scope.hideTable = ()->
        scope.show = !scope.show

  ])

  .directive('datetimePicker', ()->
    restrict: 'AC'
    link: (scope, element, attrs)->
      dateOpt =
        format: 'yyyy-mm-dd'
        startView: 2
        minView: 2

      timeOpt =
        format: 'hh:ii:ss'
        startView: 1
        minView: 0
        maxView: 1

      dateTimeOpt =
        format: 'yyyy-mm-dd hh:ii:ss'
        startView: 2

      name = attrs.name
      type = attrs.datetype
      format = attrs.format

      #判断类型
      switch type
        when 'time' then dateOpt = timeOpt
        when 'datetime'then dateOpt = dateTimeOpt

      #设定默认值
      dateOpt.showMeridian = true
      dateOpt.autoclose = true
      if format then dateOpt.format = format

      #延时加载datepicker
      require ['datepicker'], ->
        $this = $(element)
        $this.datetimepicker(dateOpt)

        $this.on 'changeDate', (ev)->
          scope.$emit 'datetime:change', name, ev.date.valueOf() - 8 * 3600 * 1000

        $this.on 'show', ()->
          current = attrs.date
          current = new Date(Number(current)) if current
          $this.datetimepicker 'setDate', current || new Date()

  )  

  .directive('mainChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-main-charts-container', _template
    link: (scope, element, attrs)->

  ])

  .directive('mobileChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-mobile-charts-container', _template
    link: (scope, element, attrs)->

  ])

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
            $rootScope.$emit 'main:chart:loaded', result, page
            chart.reload result.records
      scope.$on 'pages:menu:loaded',(event, page_name, page)->
        return if page not in ['index']
        loadChart page_name, page

      $rootScope.$on 'main:data:loaded', (event, data, page)->
        return if page not in ['index']
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

      $rootScope.$on 'main:chart:loaded',(event, data, page)->
        return if page not in ['index','mobile']
        loadChart data

      $rootScope.$on 'main:data:loaded', (event, data, page)->
        return if page not in ['index','mobile']
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

      $rootScope.$on 'main:chart:loaded',(event, data, page)->
        return if page not in ['index']
        loadChart data

      $rootScope.$on 'main:data:loaded', (event, data, page)->
        return if page not in ['index']
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

      $rootScope.$on 'main:chart:loaded',(event, data, page)->
        return if page not in ['index','mobile']
        loadChart data

      $rootScope.$on 'main:data:loaded', (event, data, page)->
        return if page not in ['index','mobile']
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

      $rootScope.$on 'main:chart:loaded',(event, data, page)->
        return if page not in ['index']
        loadChart data

      $rootScope.$on 'main:data:loaded', (event, data, page)->
        return if page not in ['index']
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

      $rootScope.$on 'main:chart:loaded',(event, data, page)->
        return if page not in ['index']
        loadChart data

      $rootScope.$on 'main:data:loaded', (event, data, page)->
        return if page not in ['index']
        if chart.reload
          chart.reload data, scope.title
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
          IE8: 1,
          IE8: 2789,
          IE7: 529,
          IE6: 1,
          IE11: 934,
          IE10: 485
        },
        {
          time_start:1448208000000,
          IE9: 792,
          IE8: 2731,
          IE7: 432,
          IE6: 3,
          IE11: 860,
          IE10: 481
        },
        {
          time_start:1448294400000,
          IE9: 1059,
          IE8: 3294,
          IE7: 466,
          IE6: 1,
          IE11: 1142,
          IE10: 567
        },
        {
          time_start:1448380800000,
          IE9: 791,
          IE8: 2525,
          IE7: 403,
          IE6: 2,
          IE11: 853,
          IE10: 445
        },
        {
          time_start:1448467200000,
          IE9: 559,
          IE8: 2073,
          IE7: 338,
          IE6: 1,
          IE11: 712,
          IE10: 363
        },
        {
          time_start:1448553600000,
          IE9: 675,
          IE8: 2242,
          IE7: 382,
          IE11: 764,
          IE10: 452
        },
        {
          time_start:1448640000000,
          IE9: 824,
          IE8: 2772,
          IE7: 459,
          IE6: 4,
          IE11: 981,
          IE10: 516
        },
        {
          time_start:1448726400000,
          IE9: 768,
          IE8: 2426,
          IE7: 374,
          IE6: 1,
          IE11: 918,
          IE10: 457
        },
        {
          time_start:1448812800000,
          IE9: 687,
          IE8: 2008,
          IE7: 419,
          IE6: 3,
          IE11: 744,
          IE10: 332
        },
        {
          time_start:1448899200000,
          IE9: 654,
          IE8: 1953,
          IE7: 1164,
          IE6: 3,
          IE11: 775,
          IE10: 370
        },
        {
          time_start:1448985600000,
          IE9: 746,
          IE8: 2045,
          IE7: 1939,
          IE6: 3,
          IE11: 737,
          IE10: 361
        },
        {
          time_start:1449072000000,
          IE9: 606,
          IE8: 1713,
          IE7: 1827,
          IE6: 1,
          IE11: 689,
          IE10: 304
        }]
        require ['chart/ie-chart'], (_chart)->
          chart = new _chart(element[0])

          chart.reload data, scope.title

      $rootScope.$on 'main:chart:loaded',(event, data, page)->
        loadChart data

      $rootScope.$on 'main:data:loaded', (event, data, page)->
        if chart.reload
          chart.reload data, scope.title
        else
          loadChart data


  ])