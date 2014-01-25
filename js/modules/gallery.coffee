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
    el: '.portfolio__list'
    unit: null
    unitSpan: 0
    numCols: null
    shuffleOn: false
    popped: false
    setArray: null
    padding: 10
    itemWidth: 320

    initialize: ->
      @pubSub =
        'app:resize': @resize

      PubSub.attach(@pubSub, this);

      @$el = $(@el)

      app.$body.addClass('grid').addClass('gallery')

      @initGrid(true)

    destroy: ->
      app.$body.removeClass('grid').removeClass('gallery')

      PubSub.unattach(@pubSub, @)
      @stopListening()
      @undelegateEvents();
      @$el.removeData().unbind();
      Backbone.View.prototype.remove.call(this);

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
          @$el.width(@numCols * @itemWidth).addClass('portfolio__list--centered')

    clear: ->
      @unit = $('.portfolio__item')

      # Reset all CSS back to default as specified in CSS
      @setArray = []
      @unit.css({
        position:"",
        top: "",
        left: "",
        width: "",
        height: ""
      })

      @unit.find(".portfolio__item__block").css({
        position: "",
        top: "",
        left: "",
        right: "",
        bottom: "",
        minHeight: ""
      })

      @initGrid()

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
      (@$el.width() / @itemWidth) | 0

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

    resize: ->
      @initGrid(true);
  })