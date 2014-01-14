define(["app", "pubsub"], (app, PubSub) ->
  "use strict"

  # Defining the application loader view.
  return Backbone.View.extend({
    el: '#loader'

    initialize: ->
      @$el = $(@el)
      @$progress = @$el.children()

      @pubSub =
        'app:rendered': @start

      PubSub.attach(@pubSub, this);

    start: ->
      @$progress.html('0')
      @$el.show()

      $els = app.view.$el.find('img')
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

)