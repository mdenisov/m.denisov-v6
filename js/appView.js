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
      this.$welcome = this.$el.find('#welcome');
      return PubSub.trigger('app:rendered');
    },
    triggerRoute: function(e) {
      var $targetLink, href, originHref, _ref, _ref1;
      $targetLink = $(e.target).closest('a');
      originHref = $.trim($targetLink.attr('href'));
      href = originHref;
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
            e.preventDefault();
            return _gaq.push(['_trackPageview', originHref]);
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
      this.$welcome.fadeOut();
      return this.revealApp();
    },
    revealApp: function() {
      this.moduleName = this.$el.find('#main-content').data('module') || 'page';
      return module = require(["modules/" + this.moduleName], function(module) {
        var ex;
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
        return app.subView = new module();
      });
    }
  });
});
