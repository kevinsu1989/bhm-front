#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 12/13/15 11:34 AM
#    Description:

define [
  '../ng-module'
  'v/cookies'
], (_module,_cookies)->
  _module.controllerModule
  .controller('loginController', ['$rootScope', '$scope', '$state',
    ($rootScope, $scope, $state)->
      $rootScope.active_menu = false
      $scope.login = ()->
        if $scope.name is 'honey' and $scope.pwd is '123456'
          _cookies.set('SNDIWUNX', 'MOISDJWOJO', { expires: 3600 })
          $state.go('index') 

  ])