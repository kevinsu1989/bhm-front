#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 12/13/15 11:34 AM
#    Description:

define [
  '../ng-module'
  'v/cookies'
], (_module,_cookies)->
  _module.controllerModule
  .controller('mobileController', ['$rootScope', '$scope', '$state', 'API',
    ($rootScope, $scope, $state, API)->
      $rootScope.active_menu = 'mobile'
      $state.go('login') if _cookies.get('SNDIWUNX') isnt 'MOISDJWOJO'
      $rootScope.query = {}
      loadData = ()->
        $scope.loading = true
        API.mpage().retrieve($rootScope.query).then (result)->
          $scope.loading = false
          $rootScope.$broadcast 'main:data:loaded', result, $state.current.name

      $scope.$on 'top:menu:select', (event, query)->
        return if $state.current.name isnt "mobile"
        $rootScope.query = query
        $rootScope.query.type = $rootScope.type
        loadData()

      loadData()

  ])