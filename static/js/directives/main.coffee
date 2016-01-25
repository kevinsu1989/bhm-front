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
  .directive('mainLeftMenu', ['$rootScope', '$state', 'API', ($rootScope, $state, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-main-left-menu', _template
    link: (scope, element, attrs)->
      scope.loading = true
      API.pages().retrieve().then (result)->
        $rootScope.page_name = result[0].page_name
        scope.pages = result
        scope.$emit 'pages:menu:loaded', result[0].page_name, $state.current.name

      scope.showItems = (page,show)->
        page.show_items = show


      scope.pageChange = (page, parent)->
        scope.show_id = page.id
        scope.$emit "pages:menu:click", page, parent

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
        scope.$broadcast 'table:show'

  ])



  .directive('mainTopInfo', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-main-top-info', _template
    link: (scope, element, attrs)->
      
      scope.$on 'main:chart:loaded', (event, data)->
        scope.records = data
      scope.$on 'main:data:loaded', (event, data)->
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

      scope.$on 'main:chart:loaded',(event, data)->
        loadTable data

      scope.$on 'main:data:loaded', (event, data)->
        loadTable data

      scope.$on 'table:show', (event)->
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




  .directive('mainTopMenuC', ['$rootScope', '$interval', ($rootScope, $interval)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-main-top-menu-container', _template
    link: (scope, element, attrs)->
      timer = null
      query = {}
      $rootScope.isSpeed = true
      $rootScope.type = 'hour'

      scope.time_range = 'today'
      scope.time_type = 'hour'
      scope.browser_name = ''
      scope.timeObj = _utils.getQueryTime('today')

      scope.reload = loadBySelect = ()->
        scope.menu_show = false

        $rootScope.type = scope.time_type
        timestamp = new Date().valueOf()

        if scope.time_range isnt ''
          scope.time_start = scope.time_end = null 
          query.time_start = scope.timeObj.time_start
          query.time_end = scope.timeObj.time_end
          query.timeStep = scope.timeObj.timeStep
        else if scope.time_start && scope.time_end
          scope.timeSelect = null
          query.time_start = new Date(scope.time_start).valueOf()
          query.time_end = new Date(scope.time_end).valueOf()
          query.timeStep = (new Date(scope.time_end).valueOf() - new Date(scope.time_start).valueOf()) / 100
        query.type = scope.type
        query.browser_name = scope.browser_name
        query.page_like = $rootScope.query.page_like if $rootScope.query.page_like
        scope.$emit 'top:menu:select', query

      scope.setTimeRange = (time_range)->
        scope.time_range = time_range
        scope.timeObj = _utils.getQueryTime(time_range)

      scope.setTimeType = (time_type)->
        scope.time_type = time_type

      scope.setBrowserName = (browser_name)->
        scope.browser_name = browser_name

      scope.showMenu = ()->
        scope.menu_show = !scope.menu_show
        
      scope.showTable = ()->
        scope.$broadcast 'table:show'


  ])

