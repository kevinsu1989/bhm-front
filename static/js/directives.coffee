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
        $rootScope.$emit "pages:menu:click", page, show_id

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
        console.log scope.data

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

