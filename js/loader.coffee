define (require, exports, module) ->
  "use strict"

  # External dependencies.
  $ = require("jquery")
  Backbone = require("backbone")
  app = require("app")
  PubSub = require("pubsub")

  # Defining the application loader view.
  return Backbone.View.extend({
    el: '#loader'

    initialize: ->
      @$el = $(@el)
      @$progress = @$el.children()

      @pubSub =
        'app:rendered': @onAfterRender

      PubSub.attach(@pubSub, this);

    onAfterRender: ->
      @$progress.html('0')
      @$el.show()

      console.log app.view

#      $els = app.view.$el.find('img')
      $els = app.$body.find('img')
      total = $els.length
      imageCount = 0
      l = total

      if l > 0
        while l--
          $($els[l]).on 'load', ->
          ++imageCount

          @$progress.html((total / imageCount) * 100)

          if total is imageCount
            @done()
      else
        @done()

    done: ->
      @$el.hide()
  })