/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

require("@rails/ujs").start();
// require("turbolinks").start()
// require("@rails/activestorage").start()
// require("channels")

// Support component names relative to this directory:
var componentRequireContext = require.context(
  "components",
  true,
  /^(?!.*__tests__\/.*$).+$/,
  );
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

// https://stackoverflow.com/questions/56128114
// import Rails from '@rails/ujs';
// Rails.start();
