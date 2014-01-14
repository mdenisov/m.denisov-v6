define(["app"], (app) ->
  "use strict"

  # Create a new module.
  GalleryItem = app.module()

  GalleryItem.View = Backbone.View.extend({
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
    timer: null

    events:
      'click .portfolio__nav__item': 'onSliderNavClick'
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

      app.$body.addClass('fixed')

      @doSlider()
      @doNav()

      @timer = app.delay(3000, =>
        app.$body.addClass('hidden')

        @$sidebar
        .removeClass('fadeIn')
        .addClass('fadeOut')
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
      @$sidebar
      .removeClass('fadeOut')
      .addClass('fadeIn')

    onSidebarLeave: ->
      app.delay(3000, =>
        @$sidebar
        .removeClass('fadeIn')
        .addClass('fadeOut')
      )

    onKeyDown: (e) ->
      switch e.keyCode
        when 37 then @navPrev()
        when 39 then @navNext()

    onMouseMove: (e) ->
      app.$body
      .removeClass('hidden')
      .addClass('mousemove')

      @slider.nav.$el.show().removeClass('fadeOut').addClass('fadeIn')

      @timer = setTimeout (=>
        app.$body
        .removeClass('mousemove')
        .addClass('hidden')

        @slider.nav.$el.removeClass('fadeIn').addClass('fadeOut')

        app.delay(300, =>
          @slider.nav.$el.hide()
        )
        clearTimeout(@timer)
      ), 3000

    onSliderNavClick: (e) ->
      $target = $(e.currentTarget)
      direction = $target.data('direction')

      if direction isnt null
        if direction is 'prev'
          @navPrev()
        if direction is 'next'
          @navNext()

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
  })

  return GalleryItem

)