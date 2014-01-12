define (require, exports, module) ->
  "use strict"

  # External dependencies.
  Backbone = require("backbone")

  # Defining the application router.
  module.exports = Backbone.Router.extend({
    routes:
      '*path': 'someRoute'

    someRoute: (path) ->
      console.log "Welcome to your / route."
  })