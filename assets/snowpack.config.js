// Snowpack Configuration File
// See all supported options: https://www.snowpack.dev/reference/configuration
const glob = require("glob");

const isProduction = process.env.NODE_ENV == "production"

const vendorJs = glob.sync("vendor/**")
const jsFiles = vendorJs.concat(["js/app.js"])

/** @type { import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    "js": "/js",
    [vendorJs]: "/js",
    "css": "/css",
    "static": "/"
  },
  optimize: {
    entrypoints: jsFiles,
    bundle: isProduction,
    splitting: true,
    treeshake: isProduction,
    minify: isProduction,
    target: "es2017"
  },
  plugins: [
    "@snowpack/plugin-postcss"
  ],
  packageOptions: {
    knownEntrypoints: jsFiles,
  },
  buildOptions: {
    out: "../priv/static",
    watch: !isProduction,
    sourcemap: !isProduction,
  }
}
