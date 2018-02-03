# Add YARN to the project

### Useful Links

- [yarnpkg](https://yarnpkg.com/lang/en/docs/install/)
- [Rails 5.1 and forward - Part 1: Yarn on Rails](http://g3ortega.com/rails/2017/05/30/rails-5-1-and-forward-yarn-on-rails.html)

### Setup

**macOS**

`brew install yarn`

**Ubuntu**

```
# Configure apt
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
```

### Initialize the project

Make sure you have a supported node version.
Install the latest version

```
sudo npm cache clean
sudo npm install -g n
sudo n stable
```

```
$ yarn init
yarn init v1.3.2
question name (cheidelacoriera):
question version (1.0.0):
question description:
question entry point (index.js):
question repository url (git@github.com:mberlanda/cheidelacoriera.git):
question author (Mauro Berlanda <mauro.berlanda@gmail.com>):
question license (MIT):
question private:
success Saved package.json
Done in 27.43s.
```

### Add packages and dependencies

```
yarn add jquery
yarn add jquery-ujs
yarn add bootstrap@3
yarn add waypoints
```

### Deploy to Heroku

Add a new buildpack:

```
heroku buildpacks:set heroku/ruby
heroku buildpacks:add --index 1 heroku/nodejs
```

[SO-43170792](https://stackoverflow.com/a/43170792)

### Code Linting

It could be a good idea to add later jshint.
For now I will just add the config files and use it as a global package:

- `.jshintignore` : files to ignore
- `.jshintrc` : general configuration

```
sudo npm install -g jshint
jshint *
```
