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
  app.testDomain = 'http://localhost/photosite/'
  app.baseUrl = baseUrl + '/'
  app.ajaxUrl = ajaxurl + '/'
#  app.baseUrl = window.location.protocol + '//' + window.location.host + '/'
  app.root = "/photosite/"
  app.testRoot = "/photosite/"
  app.domainRegex = ""

  app.view = {}
  app.subView = null
  app.modules = {}
  app.loader = {}

  app.DEBUG = true
  app.$window = $(window)
  app.$document = $(document)
  app.$body = $('body')

  app.init = ->
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
    if (fragment is '#')
      return null

    fragment = fragment.replace(@domainRegex, '')
    if (!fragment.indexOf(@baseUrl))
      fragment = fragment.substring(@baseUrl.length)
    else if (!fragment.indexOf(@testDomain))
      fragment = fragment.substring(@testDomain.length)
    else if (fragment.indexOf('://') isnt -1)
      return null

    fragment = Backbone.history.getFragment(fragment)
    matched = _.any(Backbone.history.handlers, (handler) ->
      return handler.route.test(fragment)
    )

    if matched
      return fragment
    else
      return null

  app.delay = (time, callback) ->
    setTimeout (->
      callback()
    ), time

  return app