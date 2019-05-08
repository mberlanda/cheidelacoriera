const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')

environment.config.merge(customConfig);

// https://github.com/rails/webpacker/blob/master/docs/v4-upgrade.md#splitchunks-configuration
// Enable the default config
environment.splitChunks()

module.exports = environment
