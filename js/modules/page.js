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
    el: '.page',
    initialize: function() {
      this.$el = $(this.el);
      return app.$body.addClass('fixedpage').addClass('fixed');
    },
    destroy: function() {
      return app.$body.removeClass('fixedpage').removeClass('fixed');
    }
  });
});
