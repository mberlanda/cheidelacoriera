const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')

environment.config.merge(customConfig)
environment.plugins.get("UglifyJs").options.uglifyOptions.ecma = 5

module.exports = environment
