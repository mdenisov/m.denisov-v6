require(["config"], ->
  require(["app", "router", "appView", "modules/gallery", "modules/galleryItem"], (app, Router, appView, galleryView, galleryItemView) ->
    # Define your master router on the application namespace and trigger all navigation from this instance.
    app.router = new Router()

    # Init Base App View
    app.view = new appView()

    # Include modules
    app.modules.gallery = galleryView
    app.modules.galleryItem = galleryItemView

    # Trigger the initial route and enable HTML5 History API support, set the root folder to '/' by default.  Change in app.js.
    Backbone.history.start({ pushState: true, silent: true, root: app.root })
  )
)