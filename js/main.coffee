require(["config"], ->
  # Kick off the application.
  require(["app", "router", "appView"], (app, Router, appView) ->
    # Define your master router on the application namespace and trigger all
    # navigation from this instance.
    app.router = new Router()
    app.view = new appView()

    # Trigger the initial route and enable HTML5 History API support, set the
    # root folder to '/' by default.  Change in app.js.
    Backbone.history.start({ pushState: true, silent: true, root: app.root })
  )
)