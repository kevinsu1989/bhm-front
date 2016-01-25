#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 12/13/15 11:34 AM
#    Description:

define [
  '../ng-module'
  'v/cookies'
], (_module,_cookies)->
  _module.controllerModule
  .controller('playerLoadController', ['$rootScope', '$scope', '$state', 'API',
    ($rootScope, $scope, $state, API)->
      $state.go('login') if _cookies.get('SNDIWUNX') isnt 'MOISDJWOJO'
      $rootScope.active_menu = 'index'
      $rootScope.active_menu_child = 'playerLoad'
      $rootScope.page_name = ""
      $rootScope.browser_percent = false
      $rootScope.query = {}
      loadData = ()->
        $scope.loading = true
        API.pages($rootScope.page_name).retrieve($rootScope.query).then (result)->
          $scope.loading = false
          $rootScope.$broadcast 'main:data:loaded', result, $state.current.name

      $scope.$on 'pages:menu:click', (event, page)->
        return if $state.current.name isnt "playerLoad"
        $rootScope.page_name = page.page_name
        $rootScope.query.page_like = page.page_like
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.ie7 = $rootScope.ie7
        $rootScope.query.type = $rootScope.type
        $rootScope.query.browser_percent = false
        loadData()

      $scope.$on 'top:menu:select', (event, query)->
        return if $state.current.name isnt "playerLoad"
        $rootScope.query = query
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.ie7 = $rootScope.ie7
        $rootScope.query.type = $rootScope.type
        $rootScope.query.browser_percent = false
        loadData()
        
      $scope.$on 'pages:menu:loaded', (event, page_name)->
        $rootScope.page_name = page_name
        $rootScope.query = 
          isSpeed: 'true'
          type: 'hour'
          browser_percent: false
        loadData()
  ])
