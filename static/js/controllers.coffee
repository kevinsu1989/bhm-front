#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 11:34 AM
#    Description:

define [
  'ng'
  'v/cookies'
], (_ng,_cookies)->
  _ng.module("app.controllers", ['app.services'])

  .controller('loginController', ['$rootScope', '$scope', '$state',
    ($rootScope, $scope, $state)->
      $scope.login = ()->
        if $scope.name is 'honey' and $scope.pwd is '123456'
          _cookies.set('SNDIWUNX', 'MOISDJWOJO', { expires: 3600 })
          $state.go('index') 

  ])

  .controller('mainController', ['$rootScope', '$scope', 'API',
    ($rootScope, $scope, API)->
      $state.go('login') if _cookies.get('SNDIWUNX') isnt 'MOISDJWOJO'
      $rootScope.page_name = ""
      $rootScope.query = {}
      loadData = ()->
        $scope.loading = true
        API.pages($rootScope.page_name).retrieve($rootScope.query).then (result)->
          $scope.loading = false
          $rootScope.$broadcast 'main:data:loaded', result

      $rootScope.$on 'pages:menu:click', (event, page)->
        $rootScope.page_name = page.page_name
        $rootScope.query.page_like = page.page_like
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.type = $rootScope.type
        loadData()

      $rootScope.$on 'top:menu:select', (event, query)->
        $rootScope.query = query
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.type = $rootScope.type
        loadData()
  ])

  