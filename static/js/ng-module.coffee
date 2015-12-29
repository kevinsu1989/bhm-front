define [
  'ng'
], (_ng)->
  return {
    directiveModule: _ng.module("app.directives", ["app.services", "app.filters"])
    controllerModule: _ng.module("app.controllers", ["app.services"])
    serviceModule: _ng.module("app.services", [])
    filterModule: _ng.module("app.filters", [])
  }