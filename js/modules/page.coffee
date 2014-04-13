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

      @pubSub =
        'app:resize': @resize

      PubSub.attach(@pubSub, this);

      app.$body.addClass('fixedpage').addClass('fixed')

      if ($('.video').children()[0] != null)
        @paneVideo()

    destroy: ->
      app.$body.removeClass('fixedpage').removeClass('fixed')

    paneVideo: ->
      $video = $('video')
      winW = $(window).width()
      winH = $(window).height()
      imgW = $video.width()
      imgH = $video.height()
      imgRatio = imgW / imgH
      winRatio = winW / winH
      imgLeft = 0
      imgTop = 0

      if winRatio > imgRatio
        imgW = parseInt(winW, 10)
        imgH = parseInt(imgW / imgRatio, 10)
      else
        imgH = winH
        imgW = parseInt(imgH * imgRatio, 10)

      imgLeft = parseInt((winW - imgW) / 2, 10)
      imgTop = parseInt((winH - imgH) / 2, 10)

      $video
        .attr({width: imgW})
        .css({width: imgW + 'px', left: imgLeft + 'px', top: imgTop + 'px'});

    resize: ->
      if ($('video').children()[0] != null)
        @paneVideo()
  })