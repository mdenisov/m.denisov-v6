// Generated by CoffeeScript 1.6.3
define(function(require, exports, module) {
  "use strict";
  var $, Backbone, PubSub, app;
  $ = require("jquery");
  Backbone = require("backbone");
  app = require("app");
  PubSub = require("pubsub");
  return Backbone.View.extend({
    el: '#loader',
    initialize: function() {
      this.$el = $(this.el);
      this.$progress = this.$el.children();
      this.pubSub = {
        'app:rendered': this.onAfterRender
      };
      return PubSub.attach(this.pubSub, this);
    },
    onAfterRender: function() {
      var $els, $item, error, imageCount, img, l, total, _results,
        _this = this;
      this.$progress.html('0');
      this.$el.show();
      $els = app.$body.find('img');
      total = $els.length;
      imageCount = 0;
      l = total;
      if (l > 0) {
        _results = [];
        while (l--) {
          $item = $($els[l]);
          img = new Image();
          error = false;
          img.src = $item.attr('src');
          img.onerror = function() {
            ++imageCount;
            return console.log('Error loading image: ' + img.src);
          };
          _results.push($('<img/>').attr('src', img.src).load(function(res) {
            ++imageCount;
            _this.$progress.html(((imageCount / total) * 100) | 0);
            if (imageCount === total) {
              return _this.done();
            }
          }));
        }
        return _results;
      } else {
        return this.done();
      }
    },
    done: function() {
      PubSub.trigger('app:preloaded');
      return this.$el.fadeOut();
    }
  });
});
