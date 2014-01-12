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
  app.view = {}
  app.subView = null
  app.modules = {}

  app.init = ->
    app.DEBUG = true
    app.$window = $(window)
    app.$document = $(document)
    app.$body = $('body')

    app.$document.on 'resize', (e) ->
      PubSub.trigger('app:resize', e)

    app.$document.on 'mousemove', (e) ->
      PubSub.trigger('app:mousemove', e)

    app.$document.on 'keydown', (e) ->
      PubSub.trigger('app:keydown', e)

  app.isValidUrl = (href) ->
    if (!href)
      return false
    else if (href.indexOf('javascript:') isnt -1)
      return false
    else if (href[0] is '#' and href.length is 1)
      return false
    else if (href.indexOf('../') isnt -1)
      console.error('Attempting to load a relative url, bad code monkey! (' + href + ')')
      return false
    else if (href[0] isnt '/' and href.indexOf('://') is -1)
      console.error('Attempting to load a relative url, bad code monkey! (' + href + ')')
      return false

    return true

  app.getDefinedRoute = (fragment) ->

  app.loadHtml = (href) ->

  app.delay = (time, callback) ->
    setTimeout (->
      callback()
    ), time


  console.log app