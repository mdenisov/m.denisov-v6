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
    el: '.portfolio__item'
    slider:
      curr: 1
      count: 0
      $el: {}
      $slides: {}
      nav:
        $el: {}
        $prev: {}
        $curr: {}
        $next: {}
    $sidebar: {}
    $comments: {}
    imgStretch: false
    timer1: null
    timer2: null

    startCoords: {}
    endCoords: {}

    events:
      'click .portfolio__nav': 'onSliderNavClick'
      'click .portfolio__social__item': 'onSocialLinkClick'
      'click #submit': 'onCommentPost'
      'click .comment-reply-link': 'onCommentReplyClick'
      'click #cancel-comment-reply-link': 'onCommentReplyClick'
      'submit form.comment-form': 'onCommentPost'
      'click .portfolio__info': 'showSidebar'
      'click .portfolio__sidebar__close': 'hideSidebar'
      'mousemove .portfolio__slider': 'onMouseMove'
      'touchstart .portfolio__slider': 'onTouchStart'
      'touchmove .portfolio__slider': 'onTouchMove'
      'touchend .portfolio__slider': 'onTouchEnd'

    initialize: ->
      @pubSub =
        'app:preloaded': @resize
        'app:keydown': @onKeyDown
        'app:resize': @resize

      PubSub.attach(@pubSub, this);

      @$el = $(@el)
      @slider.$el = @$el.find('.portfolio__slider')
      @$sidebar = @$el.find('.portfolio__sidebar')
      @slider.nav.$el = @$el.find('.portfolio__nav')
      @$comments = @$el.find('.portfolio__comments')
      @$info = @$el.find('.portfolio__info')
      @$close = @$sidebar.find('.portfolio__sidebar__close')

      @$comments.find('form').prepend('<div class="portfolio__comment-status" ></div>')
      @commentStatus = @$comments.find('.portfolio__comment-status')

      @postId = @$el.data('post-id')

      app.$body.addClass('fixed')

      @doSlider()
      @doNav()
      @showSidebar()

      func = () =>
        @timer1 = null
        app.$body.addClass('hidden')
        @hideSidebar()
      @timer1 = _.delay(func, 3000)

      return this

    destroy: ->
      @timer1 = null
      @timer2 = null
      app.$body.removeClass('hidden').removeClass('fixed')
      PubSub.unattach(@pubSub, @)
      @stopListening()
      @undelegateEvents();
      @$el.removeData().unbind();
      Backbone.View.prototype.remove.call(this);

    doSlider: ->
      @slider.$slides = @slider.$el.find('.portfolio__slider__item')
      @slider.count = @slider.$slides.length

      @updateSlider()

    updateSlider: ->
      @slider.$slides
        .removeClass('portfolio__slider__item--curr')
        .eq(@slider.curr - 1)
        .addClass('portfolio__slider__item--curr')

    doNav: ->
      @slider.nav.$prev = @slider.nav.$el.filter('.portfolio__nav--prev')
      @slider.nav.$next = @slider.nav.$el.filter('.portfolio__nav--next')

      @updateNav()

    updateNav: ->
      if @slider.curr is 1
        @slider.nav.$prev.addClass('portfolio__nav--hidden')
      else
        @slider.nav.$prev.removeClass('portfolio__nav--hidden')

      if @slider.curr is @slider.count
        @slider.nav.$next.addClass('portfolio__nav--hidden')
      else
        @slider.nav.$next.removeClass('portfolio__nav--hidden')

    resize: ->
      $slides = @slider.$slides
      winW = app.$window.width()
      winH = app.$window.height() - 140
      winRatio = winW / winH

      if $slides.length > 0
        for item in $slides
          $slide = $(item)
          $img = $slide.children('img');

          imgW = $img.width()
          imgH = $img.height()
          imgRatio = imgW / imgH
          imgLeft = 0
          imgTop = 0

          if @imgStretch is true
            if winRatio > imgRatio
              imgW = parseInt(winW, 10)
              imgH = parseInt(imgW / imgRatio, 10)
            else
              imgH = winH
              imgW = parseInt(imgH * imgRatio, 10)
          else
            if winRatio > imgRatio
              imgH = parseInt(winH, 10)
              imgW = parseInt(imgH * imgRatio, 10)
            else
              imgW = winW
              imgH = parseInt(imgW / imgRatio, 10)

          imgLeft = parseInt((winW - imgW) / 2, 10)
          imgTop = parseInt((winH - imgH) / 2, 10)

          # Set Bg Image W, H
#          $img.css({width: imgW + 'px', height: imgH + 'px'});
          $slide.css({width: imgW + 'px', height: imgH + 'px', left: imgLeft + 'px', top: imgTop + 'px'});

    showSidebar: ->
      @$info.addClass('hide')
      @$close.removeClass('hide')
      @$sidebar.addClass('portfolio__sidebar--shown')

    hideSidebar: ->
      @$info.removeClass('hide')
      @$close.addClass('hide')
      @$sidebar.removeClass('portfolio__sidebar--shown')

    onKeyDown: (e) ->
      switch e.keyCode
        when 37 then @navPrev()
        when 39 then @navNext()

    onMouseMove: (e) ->
      @timer2 = null

      app.$body
        .removeClass('hidden')
        .addClass('mousemove')

      func = () =>
        app.$body
          .removeClass('mousemove')
          .addClass('hidden')

      @timer2 = _.delay(func, 3000)

    onTouchStart: (e) ->
      @startCoords = @endCoords = e.originalEvent.targetTouches[0];

    onTouchMove: (e) ->
      @endCoords = e.originalEvent.targetTouches[0];

    onTouchEnd: (e) ->
      if Math.abs(@startCoords.pageX - @endCoords.pageX) > 0
        @navNext()
      else
        @navPrev()

    onSliderNavClick: (e) ->
      $target = $(e.currentTarget)
      direction = $target.data('direction')

      if direction isnt null
        if direction is 'prev'
          @navPrev()
        if direction is 'next'
          @navNext()

    onSocialLinkClick: (e) ->
      $target = $(e.currentTarget)
      type = $target.data('type')

      e.preventDefault()
      e.stopPropagation()

      switch type
        when 'fave' then @doFave(e)
        when 'comment' then @toggleCommentsBlock(e)
        when 'share' then @toggleShareBlock(e)

    onCommentPost: (e) ->
      form = $(e.currentTarget).parents('form')
      url = form.attr('action')
      data = form.serializeArray()

      $.post( url, data, =>

      )
      .done( (data, textStatus) =>
          if textStatus is "success"
            @commentStatus.html('<div class="alert alert--success" >Thanks for your comment. We appreciate your response.</div>')
          else
            @commentStatus.html('<div class="alert alert--error" >Please wait a while before posting your next comment</div>')

          form.find('textarea[name=comment]').val('')
      )
      .fail( (data, textStatus) =>
          @commentStatus.html('<div class="alert alert--error" >You might have left one of the fields blank, or be posting too quickly</div>')
      )

      e.preventDefault()
      e.stopPropagation()

    onCommentReplyClick: (e) ->
      e.preventDefault()
      e.stopPropagation()

    navPrev: ->
      if @slider.curr > 1
        @slider.curr--
        @updateNav()
        @updateSlider()

    navNext: ->
      if @slider.curr < @slider.count
        @slider.curr++
        @updateNav()
        @updateSlider()

    doFave: (e) ->
      counter = $(e.currentTarget).children('.portfolio__social__count')
      url = app.ajaxUrl
      data = {action: 'fave', id: @postId}

      $.post( url, data, =>

      )
      .done( (data, textStatus) =>
          counter.html(data)
        )
      .fail( (data, textStatus) =>
          console.log data
        )

    toggleCommentsBlock: ->
      return @$comments.toggleClass('portfolio__comments--shown')

    toggleShareBlock: ->
  })