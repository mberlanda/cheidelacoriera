const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')
const UglifyJSPlugin = require("uglifyjs-webpack-plugin")

environment.config.merge(customConfig);
if (environment.plugins.keys().includes("UglifyJs")) {
  environment.plugins.delete("UglifyJs")
}
environment.plugins.append("UglifyJs", new UglifyJSPlugin())
environment.plugins.get("UglifyJs").options.uglifyOptions.ecma = 5

module.exports = environment
