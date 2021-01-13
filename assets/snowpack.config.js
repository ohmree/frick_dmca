// Snowpack Configuration File
// See all supported options: https://www.snowpack.dev/reference/configuration
const glob = require('glob');

const isProduction = process.env.NODE_ENV == "production"

/** @type { import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    "js": "/js",
    [glob.sync("vendor/**")]: "/js",
    "css": "/css",
    "static": "/"
  },
  plugins: [
    [
      "@snowpack/plugin-optimize", {
        minifyHTML: isProduction,
        minifyCSS: isProduction,
        minifyJS: isProduction,
        preloadModules: true,
        preloadCSS: isProduction,
        target: "es2015"
      }
    ],
    "@snowpack/plugin-postcss"
  ],
  packageOptions: {
    /* ... */
  },
  // devOptions: {
  //   port: 3000
  // },
  buildOptions: {
    out: "../priv/static",
    watch: !isProduction,
  }
}
