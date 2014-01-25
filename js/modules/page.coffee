define (require, exports, module) ->
  "use strict"

  # External dependencies.
  _ = require("underscore")
  $ = require("jquery")
  Backbone = require("backbone")
  app = require("app")
  PubSub = require("pubsub")

  # Defining the module class.
  return Backbone.View.extend({
    el: '.page'

    initialize: ->
      @$el = $(@el)

      app.$body.addClass('fixedpage').addClass('fixed')

    destroy: ->
      app.$body.removeClass('fixedpage').removeClass('fixed')
  })