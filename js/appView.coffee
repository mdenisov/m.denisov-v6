define (require, exports, module) ->
  "use strict"

  # External dependencies.
  _ = require("underscore")
  $ = require("jquery")
  Backbone = require("backbone")
  app = require("app")
  PubSub = require("pubsub")

  # Defining the application base view.
  return Backbone.View.extend({
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

#      PubSub.trigger('app:rendered')
      @onAfterRender()

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
      @$welcome.fadeOut()
      @revealApp()

    revealApp: ->
      @moduleName = @$el.find('#main-content').data('module') || 'page'

      module = require(["modules/" + @moduleName], (module) ->
        if app.subView?
          app.$window.off '.' + app.subView.cid
          app.$document.off '.' + app.subView.cid

          try
            app.subView.destroy()
          catch ex
            console.error('View threw an exception on destroy: ', (ex.stack || ex.stacktrace || ex.message));
            app.subView.$el.remove()

        app.subView = new module()
      )

  })