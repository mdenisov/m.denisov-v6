// Generated by CoffeeScript 1.6.3
define(function(require, exports, module) {
  "use strict";
  var $, Backbone, PubSub, _;
  _ = require("underscore");
  $ = require("jquery");
  Backbone = require("backbone");
  PubSub = require("pubsub");
  return module.exports = Backbone.View.extend({
    el: 'body',
    $container: {},
    events: {
      'click': 'triggerRoute'
    },
    initialize: function() {
      this.pubSub = {
        'app:loaded': this.render,
        'app:rendered': this.onAfterRender
      };
      PubSub.attach(this.pubSub, this);
      this.$el = $(this.el);
      this.$container = this.$el.find('#main');
      return this.$welcome = this.$el.find('#welcome');
    },
    triggerRoute: function(e) {
      var $targetLink, href, _ref, _ref1;
      $targetLink = $(e.target).closest('a');
      href = $.trim($targetLink.attr('href'));
      console.log(href);
      if (!Modernizr.history) {
        if (app.getDefinedRoute(href) && window.chromeless) {
          href = $.trim($targetLink.attr('href'));
          href += ((_ref = href.indexOf('?') === -1) != null ? _ref : {
            '?': '&'
          }) + 'chromeless=true';
          return $targetLink.attr('href', href);
        }
      } else {
        if (!app.isValidUrl(href)) {
          return e.preventDefault();
        } else {
          href = app.getDefinedRoute(href);
          if (href !== null) {
            if (window.chromeless) {
              href += ((_ref1 = href.indexOf('?') === -1) != null ? _ref1 : {
                '?': '&'
              }) + 'chromeless=true';
            }
            Backbone.history.navigate(href, {
              trigger: true
            });
            return e.preventDefault();
          }
        }
      }
    },
    render: function(html) {
      var $html;
      if (html !== null) {
        $html = $('<div/>').html(html).find('#main-content');
        this.$container.html($html);
        return PubSub.trigger('app:rendered');
      }
    },
    onAfterRender: function() {
      this.$welcome.hide();
      return this.revealApp();
    },
    revealApp: function() {
      var ex;
      this.moduleName = this.$el.find('#main-content').data('module') || 'text';
      console.log(this.moduleName, app.subView);
      if (app.modules.hasOwnProperty(this.moduleName)) {
        if (app.subView != null) {
          app.$window.off('.' + app.subView.cid);
          app.$document.off('.' + app.subView.cid);
          try {
            app.subView.destroy();
          } catch (_error) {
            ex = _error;
            console.error('View threw an exception on destroy: ', ex.stack || ex.stacktrace || ex.message);
            app.subView.$el.remove();
          }
        }
        return app.subView = new app.modules[this.moduleName];
      }
    }
  });
});
