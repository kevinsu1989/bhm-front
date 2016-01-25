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
  .directive('firstpaintChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-firstPaint-charts-container', _template
    link: (scope, element, attrs)->

  ])
  .directive('firstviewChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-firstView-charts-container', _template
    link: (scope, element, attrs)->

  ])
  .directive('domreadyChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-domReady-charts-container', _template
    link: (scope, element, attrs)->

  ])
  .directive('pageloadChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-pageLoad-charts-container', _template
    link: (scope, element, attrs)->

  ])
  .directive('playerloadChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-playerLoad-charts-container', _template
    link: (scope, element, attrs)->

  ])