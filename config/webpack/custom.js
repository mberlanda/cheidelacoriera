const webpack = require('webpack');

module.exports = {
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery',
      Popper: ['popper.js', 'default']
    }),
  ],

  resolve: {
    alias: {
      jquery: 'jquery/dist/jquery',
      React: 'react',
      ReactDOM: 'react-dom',
    }
  }
}
