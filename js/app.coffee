define (require, exports, module) ->
  "use strict"

  # External dependencies.
  _ = require("underscore")
  $ = require("jquery")
  Backbone = require("backbone")
  PubSub = require("pubsub")

  # Alias the module for easier identification.
  app = module.exports

  # The root path to run the application through.
  #app.root = "/"
  app.root = "/photosite/"

  console.log module