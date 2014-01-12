require.config(
  paths: {
    # Make vendor easier to access.
    "vendor": "vendor",
    "lib": "lib",

    # Opt for Lo-Dash Underscore compatibility build over Underscore.
    "underscore": "vendor/bower_components/lodash/dist/lodash.underscore",

    # Map remaining vendor dependencies.
    "jquery": "vendor/bower_components/jquery/jquery",
    "backbone": "vendor/bower_components/backbone/backbone",

    "pubsub": "lib/pubsub"
  },

  shim:
    # This is required to ensure Backbone works as expected within the AMD environment.
    "backbone":
      # These are the two hard dependencies that will be loaded first.
      deps: ["jquery", "underscore"],

      # This maps the global `Backbone` object to `require("backbone")`.
      exports: "Backbone"
)