# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.5'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
# Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths += %w(
  node_modules/jquery/dist/
  node_modules/jquery-ujs/src/
  node_modules/bootstrap/
  node_modules/jquery-backstretch/
  node_modules/waypoints/lib/
  node_modules/jquery-timepicker/
  node_modules/bootstrap-datepicker/
  node_modules/multiselect/
  node_modules/wowjs/dist/
  node_modules/wowjs/css/libs/
  node_modules/retinajs/dist/
  node_modules/intro.js/
  node_modules/font-awesome/
).map { |ast| Rails.root.join(ast) }

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(*.js *.scss)
Rails.application.config.assets.precompile += %w(*.png *.woff2 *.woff *.ttf *.eot *.jpg *.gif *.svg *.ico)
Rails.application.config.assets.precompile += %w(css/*.css)

