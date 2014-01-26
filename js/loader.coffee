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

      $els = app.$body.find('img')
      total = $els.length
      imageCount = 0
      l = total

      if l > 0
        while l--
          $item = $($els[l])
          img = new Image()
          error = false

          img.src = $item.attr('src');
          img.onerror = () =>
            ++imageCount
            console.log 'Error loading image: ' + img.src

          $('<img/>').attr('src', img.src).load (res) =>
            ++imageCount

            @$progress.html(((imageCount / total) * 100) | 0)

            if imageCount is total
              @done()
      else
        @done()

#      if l > 0
#        while l--
#          $($els[l]).load _.bind((e) ->
#            ++imageCount
#
#            $(e.currentTarget).addClass "loaded"
#
#            @$progress.html(((imageCount / total) * 100) | 0)
#
#            if total is imageCount
#              @done()
#          , this)
#      else
#        @done()

    done: ->
      PubSub.trigger('app:preloaded')
      @$el.fadeOut()
  })