const { environment } = require('@rails/webpacker');
const webpack = require("webpack");

const customConfig = require('./custom');
environment.config.merge(customConfig);

/*
// https://rubyyagi.com/how-to-use-bootstrap-and-jquery-in-rails-6-with-webpacker/

environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
  })
);

// const config = environment.toWebpackConfig();

environment.config.resolve.alias = {
  jquery: 'jquery/dist/jquery',
  React: 'react',
  ReactDOM: 'react-dom',
};
*/
module.exports = environment;
