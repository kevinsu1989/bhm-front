#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 11:06 AM
#    Description: 路由

"use strict"
define [
  "ng"
  "app"
  'utils'
  't!/views.html'
], (_ng, _app, _utils, _template) ->

  _app.config(['$locationProvider', '$stateProvider', '$urlRouterProvider',
    ($locationProvider, $stateProvider, $urlRouterProvider) ->
      $locationProvider.html5Mode enabled: true, requireBase: false

      $urlRouterProvider.otherwise('/login')

      $stateProvider
      .state('index',
        url: '/'
        template: _utils.extractTemplate('#tmpl-main', _template)
        controller: 'mainController'
      )
      
      .state('login',
        url: '/login'
        template: _utils.extractTemplate('#tmpl-login', _template)
        controller: 'loginController'
      )

      .state('mobile',
        url: '/mobile'
        template: _utils.extractTemplate('#tmpl-mobile', _template)
        controller: 'mobileController'
      )

      .state('player',
        url: '/player'
        template: _utils.extractTemplate('#tmpl-player', _template)
        controller: 'playerController'
      )

      .state('position',
        url: '/position'
        template: _utils.extractTemplate('#tmpl-position', _template)
        controller: 'positionController'
      )
      
  ])