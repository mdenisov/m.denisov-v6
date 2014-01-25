// Generated by CoffeeScript 1.6.3
define(function(require, exports, module) {
  "use strict";
  var $, Backbone, PubSub, app, _;
  _ = require("underscore");
  $ = require("jquery");
  Backbone = require("backbone");
  app = require("app");
  PubSub = require("pubsub");
  return Backbone.View.extend({
    el: '.portfolio__list',
    unit: null,
    unitSpan: 0,
    numCols: null,
    shuffleOn: false,
    popped: false,
    setArray: null,
    padding: 10,
    itemWidth: 320,
    initialize: function() {
      this.pubSub = {
        'app:resize': this.resize
      };
      PubSub.attach(this.pubSub, this);
      this.$el = $(this.el);
      app.$body.addClass('grid').addClass('gallery');
      return this.initGrid(true);
    },
    destroy: function() {
      app.$body.removeClass('grid').removeClass('gallery');
      PubSub.unattach(this.pubSub, this);
      this.stopListening();
      this.undelegateEvents();
      this.$el.removeData().unbind();
      return Backbone.View.prototype.remove.call(this);
    },
    initGrid: function(forceReload) {
      var i, newRow, numCols;
      numCols = this.setCols();
      console.log(numCols);
      if (this.numCols !== numCols || forceReload) {
        this.numCols = numCols;
        this.unit = $('.portfolio__item');
        this.setArray = [];
        newRow = [];
        i = this.numCols;
        while (i--) {
          newRow[i] = 0;
        }
        this.setArray.push(newRow);
        if (this.numCols >= 3) {
          return this.layout();
        } else {
          return this.clear();
        }
      }
    },
    clear: function() {
      this.$el.width(this.numCols * this.itemWidth).addClass('portfolio__list--centered');
      this.unit = $('.portfolio__item');
      this.setArray = [];
      this.unit.css({
        position: "",
        top: "",
        left: "",
        width: "",
        height: ""
      });
      this.unit.find(".portfolio__item__block").css({
        position: "",
        top: "",
        left: "",
        right: "",
        bottom: "",
        minHeight: ""
      });
      return this.initGrid();
    },
    shuffle: function(units) {
      var i, j, nonShuffled, shuffled, temp;
      shuffled = units.not(".ignore-shuffle");
      nonShuffled = units.filter(".ignore-shuffle");
      shuffled = $.makeArray(shuffled);
      nonShuffled = $.makeArray(nonShuffled);
      i = shuffled.length;
      while (i--) {
        j = Math.floor(Math.random() * (i + 1));
        temp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = temp;
      }
      shuffled = nonShuffled.concat(shuffled);
      return $(shuffled);
    },
    setCols: function() {
      return (app.$window.width() / this.itemWidth) | 0;
    },
    layout: function() {
      var col, colSpan, freeUnits, gridUnit, height, i, key, newRow, placed, row, rowSpan, takenUnits, width;
      this.unitSpan = this.$el.innerWidth() / this.numCols;
      this.unit.css("position", "absolute");
      this.unit.find(".portfolio__item__block").css({
        position: "absolute",
        top: this.padding,
        left: this.padding,
        right: this.padding,
        bottom: this.padding,
        minHeight: 0
      });
      if (this.shuffleOn) {
        this.unit = this.shuffle(this.unit);
      }
      gridUnit = {};
      key = 0;
      while (key < this.unit.length) {
        gridUnit = $(this.unit[key]);
        rowSpan = parseInt(gridUnit.attr("data-rowspan"), 10);
        colSpan = parseInt(gridUnit.attr("data-colspan"), 10);
        placed = false;
        newRow = [];
        width = this.unitSpan * colSpan;
        height = this.unitSpan * rowSpan;
        gridUnit.css({
          width: width,
          height: height
        });
        row = 0;
        while (row <= this.setArray.length) {
          freeUnits = 0;
          takenUnits = 0;
          col = 0;
          while (col <= this.setArray[row].length) {
            if (this.setArray[row][col] === 0) {
              freeUnits++;
            } else {
              freeUnits = 0;
              takenUnits++;
            }
            if (freeUnits === colSpan) {
              gridUnit.css({
                top: row * this.unitSpan,
                left: (col - (colSpan - 1)) * this.unitSpan
              });
              i = colSpan + (col - (colSpan - 1)) - 1;
              while (i >= (col - (colSpan - 1))) {
                this.setArray[row][i] = 1;
                i--;
              }
              if (rowSpan > 1) {
                newRow = [];
                i = 0;
                while (i <= this.numCols - 1) {
                  newRow[i] = 0;
                  i++;
                }
                this.setArray.push(newRow);
                i = colSpan + (col - (colSpan - 1)) - 1;
                while (i >= (col - (colSpan - 1))) {
                  this.setArray[row + 1][i] = 1;
                  i--;
                }
              }
              placed = true;
              break;
            }
            col++;
          }
          if (!placed) {
            if (!this.setArray[row + 1]) {
              newRow = [];
              i = 0;
              while (i <= this.numCols - 1) {
                newRow[i] = 0;
                i++;
              }
              this.setArray.push(newRow);
            }
          } else {
            break;
          }
          row++;
        }
        key++;
      }
      return this.$el.height(this.setArray.length * this.unitSpan);
    },
    resize: function() {
      this.$el.width('auto').removeClass('portfolio__list--centered');
      return this.initGrid(true);
    }
  });
});
