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
  .directive('mobileChartsContainer', ['$rootScope', 'API', ($rootScope, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-mobile-charts-container', _template
    link: (scope, element, attrs)->

  ])

