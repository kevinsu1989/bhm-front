#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 11:34 AM
#    Description:

define [
  'ng'
  'v/cookies'
], (_ng,_cookies)->
  _ng.module("app.controllers", ['app.services'])
  # .controller('homeController', ['$rootScope', 'API', ($rootScope, API)->
  #   loadData = (page_name, data)->
  #     API.pages(page_name).retrive(data).then (result)->
  #       $scope.loading = false
  #       $rootScope.data = result

  #   loadData('BHF')
  # ])

  .controller('loginController', ['$rootScope', '$scope', '$state',
    ($rootScope, $scope, $state)->
      $rootScope.active_menu = false
      $scope.login = ()->
        if $scope.name is 'honey' and $scope.pwd is '123456'
          _cookies.set('SNDIWUNX', 'MOISDJWOJO', { expires: 3600 })
          $state.go('index') 

  ])

  .controller('mobileController', ['$rootScope', '$scope', '$state', 'API',
    ($rootScope, $scope, $state, API)->
      $rootScope.active_menu = 'mobile'
      $state.go('login') if _cookies.get('SNDIWUNX') isnt 'MOISDJWOJO'
      $rootScope.query = {}
      loadData = ()->
        $scope.loading = true
        API.mpage().retrieve($rootScope.query).then (result)->
          $scope.loading = false
          console.log result
          $rootScope.$broadcast 'main:data:loaded', result, $state.current.name

      $rootScope.$on 'top:menu:select', (event, query)->
        return if $state.current.name isnt "mobile"
        $rootScope.query = query
        $rootScope.query.type = $rootScope.type
        loadData()

      loadData()

  ])

  .controller('mainController', ['$rootScope', '$scope', '$state', 'API',
    ($rootScope, $scope, $state, API)->
      $rootScope.active_menu = 'index'
      $state.go('login') if _cookies.get('SNDIWUNX') isnt 'MOISDJWOJO'
      $rootScope.page_name = ""
      $rootScope.query = {}
      loadData = ()->
        $scope.loading = true
        API.pages($rootScope.page_name).retrieve($rootScope.query).then (result)->
          $scope.loading = false
          $rootScope.$broadcast 'main:data:loaded', result, $state.current.name

      $rootScope.$on 'pages:menu:click', (event, page)->
        return if $state.current.name isnt "index"
        $rootScope.page_name = page.page_name
        $rootScope.query.page_like = page.page_like
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.type = $rootScope.type
        loadData()

      $rootScope.$on 'top:menu:select', (event, query)->
        return if $state.current.name isnt "index"
        $rootScope.query = query
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.type = $rootScope.type
        loadData()
  ])

  