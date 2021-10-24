const { environment } = require('@rails/webpacker');
const erb = require('./loaders/erb')

const customConfig = require('./custom');
environment.config.merge(customConfig);

environment.loaders.prepend('erb', erb)
module.exports = environment;
