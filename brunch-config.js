exports.config = {
  sourceMaps: "absoluteUrl",

  files: {
    javascripts: {
      joinTo: "js/app.js"
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: "assets/css/app.css"
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(assets\/static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "assets/static",
      "assets/scss",
      "assets/js"
    ],
    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/assets\/static\/vendor/]
    },
    sass: {
      options: {
        includePaths: [
          'node_modules/normalize-scss/sass',
          'node_modules/foundation-sites/scss',
          'deps/phoenix_live_view/assets/css/live_view.css'
        ]
      }
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["assets/js/app.js"]
    }
  },

  npm: {
    enabled: true,
    globals: {
      jQuery: "jquery",
      $: "jquery"
    }
  }
};
