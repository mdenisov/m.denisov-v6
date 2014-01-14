define(["app", "pubsub"], (app, PubSub) ->
  "use strict"

  # External dependencies.
  # Backbone = require("backbone")

  # Defining the application router.
  return Backbone.Router.extend({
    routes:
      '*path': 'someRoute'

    someRoute: (path) ->
      ajaxPromise = $.Deferred((deferred) ->
        href = app.baseUrl + path

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

      ajaxPromise.done (html) ->
        PubSub.trigger('app:loaded', html)
      ajaxPromise.fail (error) ->
        console.log error
      #ajaxPromise.always (error) ->
      # console.log error
  })

)