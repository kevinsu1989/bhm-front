#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 12/13/15 11:34 AM
#    Description:

define [
  '../ng-module'
  'v/cookies'
], (_module,_cookies)->
  _module.controllerModule
  .controller('emailController', ['$rootScope', '$scope', '$state', 'API',
    ($rootScope, $scope, $state, API)->
      $rootScope.query = {}
      loadData = ()->
        $scope.loading = true
        API.email().retrieve().then (result)->
          $scope.loading = false
          $rootScope.$broadcast 'main:data:loaded', result, $state.current.name

      loadData()

  ])
