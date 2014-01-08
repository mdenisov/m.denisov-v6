$ = jQuery

app =
  baseUrl: window.location.protocol + '//' + window.location.host + '/'
  domainRegex: ''
  subDomain: 'photosite/'
  testDomain: 'http://localhost/photosite/'
  config:
    foo: 'bar'
  view: {}
  subView: null
  modules: {}
  init: ->
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

    PubSub.trigger('app:rendered')

    console.log app

  isValidUrl: (href) ->
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

  getCurrRout: ->
    return @getDefinedRoute window.location.href

  getDefinedRoute: (fragment) ->
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

  loadHtml: (href) ->
    if (!href)
      return false

    return $.Deferred((deferred) ->
      href = app.baseUrl + href

      $.ajax href,
        type: 'GET'
        dataType: 'html'
        error: (jqXHR, textStatus, errorThrown) ->
          console.log "AJAX Error: #{textStatus}"
          deferred.fail(textStatus)
        success: (data, textStatus, jqXHR) ->
#          console.log "Successful AJAX call: #{data}"
          deferred.resolve(data)
    ).promise()

  delay: (time, callback) ->
    setTimeout (->
      callback()
    ), time


# GALLERY VIEW
app.modules.gallery = Backbone.View.extend({
  el: '.portfolio__list'
  unit: null
  unitSpan: 0
  numCols: null
  shuffleOn: false
  popped: false
  setArray: null
  padding: 10

  initialize: ->
    @$el = $(@el)

    app.$body.addClass('grid').addClass('gallery')

    @initGrid(true)

  destroy: ->
    app.$body.removeClass('grid').removeClass('gallery')

  initGrid: (forceReload) ->
    # Set up number of cols
    numCols = @setCols()

    # Only relayout if cols has changed
    if @numCols isnt numCols or forceReload

      @numCols = numCols;

#      this.container = $(this.containerSelector);

      # Reset selection of elements
      @unit = $('.portfolio__item')

      # Reset setArray
      @setArray = []

      # Create the first row
      newRow = []
      i = @numCols
      while i--
        newRow[i] = 0

      @setArray.push(newRow)

#      console.log @setArray, @setArray[0].length

      if @numCols >= 3
        # Layout the grid
        @layout()
      else
        # Otherwise, kill the grid
        @clear()

  clear: ->

  shuffle: (units) ->
    # Randomise the elements
    shuffled = units.not(".ignore-shuffle")
    nonShuffled = units.filter(".ignore-shuffle")

    shuffled = $.makeArray(shuffled);
    nonShuffled = $.makeArray(nonShuffled);

    i = shuffled.length
    while i--
      j = Math.floor(Math.random() * (i + 1))
      temp = shuffled[i]

      shuffled[i] = shuffled[j]
      shuffled[j] = temp

    # Put non shuffle items back in beginning of array
    shuffled = nonShuffled.concat(shuffled)

    $(shuffled)

  setCols: ->
    itemWidth = 320
    (@$el.width() / itemWidth) | 0

  layout: ->
    @unitSpan = @$el.innerWidth() / @numCols;
    @unit.css("position", "absolute");
#    @container.css("position", "relative");

    @unit.find(".portfolio__item__block").css({
      position: "absolute",
      top: @padding,
      left: @padding,
      right: @padding,
      bottom: @padding,
      minHeight: 0
    });

    if @shuffleOn
      # Randomise the elements
      @unit = @shuffle(@unit)

    gridUnit = {}

    # Loop through the grid units
    for key in @unit
      gridUnit = $(key)
      rowSpan = parseInt(gridUnit.data("rowspan"),10)
      colSpan = parseInt(gridUnit.data("colspan"),10)
      placed = false
      newRow = []
      width = @unitSpan * colSpan
      height = @unitSpan * rowSpan

      gridUnit.css({
        width: width,
        height: height
      })

      # For each grid row
      for row of @setArray
        freeUnits = 0
        takenUnits = 0

#        console.log row

        for col of @setArray[row]
          if @setArray[row][col] is 0
            freeUnits++
          else
            freeUnits = 0
            takenUnits++

#          console.log freeUnits

          # If the number of free spaces in this row matches the number needed
          if freeUnits is colSpan
#            console.log gridUnit
            gridUnit.css({
              top: row * @unitSpan,
              left: (col - (colSpan - 1)) * @unitSpan
            })

            # Mark off which units we used
            i = colSpan + (col - (colSpan - 1)) - 1
            while i >= (col - (colSpan - 1))
              @setArray[row][i] = 1
              i--

            if rowSpan > 1
              newRow = []

              i = @numCols
              while i--
                newRow[i] = 0
              @setArray.push(newRow)

              # Add taken units to this row too
              i = colSpan + (col - (colSpan - 1)) - 1
              while i >= (col - (colSpan - 1))
                @setArray[parseInt(row, 10) + 1][i] = 1
                i--

            # We've placed it
            placed = true

            # Break out of this loop
            break

        # If we haven't placed it
        if !placed
          # If there's no more rows
          if @setArray[row + 1]?
            # Add a new row
            newRow = []
            i = @numCols
            while i--
              newRow[i] = 0
            @setArray.push(newRow)
        else
          # Break out to next unit
          break

    @$el.height(@setArray.length * @unitSpan);
})


# GALLERY ITEM VIEW
app.modules.galleryItem = Backbone.View.extend({
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
    app.$body.removeClass('hidden')
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


# ROUTER
app.router = new(Backbone.Router.extend({
  initialize: ->

  routes:
    '*path': 'parseHash'
#    '/': 'parseHash'
#    '/gallery': 'parseHash'
#    '/gallery/*': 'parseHash'
#    '/about': 'parseHash'

  parseHash: (hash) ->
    console.log hash

    ajaxPromise = app.loadHtml(hash)
    ajaxPromise.done (html) ->
      PubSub.trigger('app:loaded', html)
    ajaxPromise.fail (error) ->
      console.log error
#    ajaxPromise.always (error) ->
#      console.log error
}))

Backbone.history.start({pushState: true, hashChange: false, silent: true})


# BASE APP VIEW
app.view = new (Backbone.View.extend({
  el: 'body'
  $container: {}

  events:
    'click': 'triggerRoute'

  initialize: ->
    @pubSub =
      'app:loaded': @render
      'app:rendered': @onAfterRender

    PubSub.attach(@pubSub, this);

    @$el = $(@el)
    @$container = @$el.find('#main')
    @$welcome = @$el.find('#welcome')

  triggerRoute: (e) ->
    $targetLink = $(e.target).closest('a')
    href = $.trim($targetLink.attr('href'))

    if (!Modernizr.history)
      if (app.getDefinedRoute(href) and window.chromeless)
        href = $.trim($targetLink.attr('href'));
        href += ((href.indexOf('?') is -1) ? '?' : '&') + 'chromeless=true';
        $targetLink.attr('href', href);
    else
      if (!app.isValidUrl(href))
        e.preventDefault()
      else
        href = app.getDefinedRoute(href);
        if (href isnt null)
          if (window.chromeless)
            href += ((href.indexOf('?') is -1) ? '?' : '&') + 'chromeless=true';

          Backbone.history.navigate(href, {trigger: true});
          e.preventDefault();

  render: (html) ->
    if (html isnt null)
      $html = $('<div/>').html(html).find('#main-content')

      @$container.html($html)

      PubSub.trigger('app:rendered')

  onAfterRender: ->
    @$welcome.hide()
    @revealApp()

  revealApp: ->
    @moduleName = @$el.find('#main-content').data('module') || 'text'
    console.log @moduleName
    if app.modules.hasOwnProperty(@moduleName)
      if app.subView?
        app.$window.off '.' + app.subView.cid
        app.$document.off '.' + app.subView.cid

        try
          app.subView.destroy(true)
        catch ex
          console.error('View threw an exception on destroy: ', (ex.stack || ex.stacktrace || ex.message));
          app.subView.$el.remove()

      app.subView = new app.modules[@moduleName]
}))


# IMAGE LOADER
app.loader = new (Backbone.View.extend({
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
}))

$(document).ready ->
  app.init()
