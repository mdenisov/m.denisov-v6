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
    timer1: null
    timer2: null

    events:
      'click .portfolio__nav__item': 'onSliderNavClick'
      'click .portfolio__social__item': 'onSocialLinkClick'
      'click #submit': 'onCommentPost'
      'submit form.comment-form': 'onCommentPost'
      'mousemove .portfolio__slider': 'onMouseMove'
      'mouseenter .portfolio__sidebar': 'onSidebarOver'
      'mouseleave .portfolio__sidebar': 'onSidebarLeave'
#    'click .portfolio__sidebar__close': 'onSidebarLeave'

    initialize: ->
      @pubSub =
        'app:keydown': @onKeyDown

      PubSub.attach(@pubSub, this);

      @$el = $(@el)
      @slider.$el = @$el.find('.portfolio__slider')
      @$sidebar = @$el.find('.portfolio__sidebar')
      @slider.nav.$el = @$el.find('.portfolio__nav')
      @$comments = @$el.find('.portfolio__comments')

      @$comments.find('form').prepend('<div class="portfolio__comment-status" ></div>')
      @commentStatus = @$comments.find('.portfolio__comment-status')

      app.$body.addClass('fixed')

      @doSlider()
      @doNav()

      @timer1 = app.delay(3000, =>
        clearTimeout(@timer1)
        app.$body.addClass('hidden')

#        @$sidebar
#        .removeClass('fadeIn')
#        .addClass('fadeOut')
      )

      return this

    destroy: ->
      clearTimeout(@timer)
      app.$body.removeClass('hidden').removeClass('fixed')
      PubSub.unattach(@pubSub, this)

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
      @slider.nav.$prev = @slider.nav.$el.find('.portfolio__nav__item--prev')
      @slider.nav.$curr = @slider.nav.$el.find('.portfolio__nav__item--curr')
      @slider.nav.$next = @slider.nav.$el.find('.portfolio__nav__item--next')

      @updateNav()

    updateNav: ->
      prev = @slider.curr - 1
      next = @slider.curr + 1

      if @slider.curr is 1
        @slider.nav.$prev.addClass('portfolio__nav__item--hidden')
      else
        @slider.nav.$prev.removeClass('portfolio__nav__item--hidden')

      if @slider.curr is @slider.count
        @slider.nav.$next.addClass('portfolio__nav__item--hidden')
      else
        @slider.nav.$next.removeClass('portfolio__nav__item--hidden')

      @slider.nav.$prev.children('.portfolio__nav__item__pos').html('0' + prev)
      @slider.nav.$curr.children('.portfolio__nav__item__pos').html('0' + @slider.curr)
      @slider.nav.$next.children('.portfolio__nav__item__pos').html('0' + next)

    onSidebarOver: ->
#      @$sidebar
#      .removeClass('fadeOut')
#      .addClass('fadeIn')

    onSidebarLeave: ->
#      app.delay(3000, =>
#        @$sidebar
#        .removeClass('fadeIn')
#        .addClass('fadeOut')
#      )

    onKeyDown: (e) ->
      switch e.keyCode
        when 37 then @navPrev()
        when 39 then @navNext()

    onMouseMove: (e) ->
      clearTimeout(@timer2)

      app.$body
        .removeClass('hidden')
        .addClass('mousemove')

      @slider.nav.$el.addClass('portfolio__nav--shown')

      @timer2 = setTimeout (=>
        clearTimeout(@timer2)

        app.$body
          .removeClass('mousemove')
          .addClass('hidden')

        @slider.nav.$el.removeClass('portfolio__nav--shown')
      ), 3000

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
        when 'fave' then @doFave()
        when 'comment' then @toggleCommentsBlock()
        when 'share' then @toggleShareBlock()

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

    doFave: ->

    toggleCommentsBlock: ->
      return @$comments.toggleClass('portfolio__comments--shown')

    toggleShareBlock: ->
  })