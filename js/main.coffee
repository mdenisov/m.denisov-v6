require(["config"], ->
  require(["app", "router", "loader", "appView"], (app, Router, Loader, appView) ->
    # Init Loader
    app.loader = new Loader()

    # Init Base App View
    app.view = new appView()

    # Define your master router on the application namespace and trigger all navigation from this instance.
    app.router = new Router()

    # Trigger the initial route and enable HTML5 History API support, set the root folder to '/' by default.  Change in app.js.
    Backbone.history.start({ pushState: true, silent: true, root: app.root })

    $(document).ready ->
      app.init()
  )
)