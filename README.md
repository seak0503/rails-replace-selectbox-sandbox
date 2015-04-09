# Replace selectbox sandbox

Sample app for replacing selectbox options by ajax.

![Image](http://f.st-hatena.com/images/fotolife/J/JunichiIto/20150409/20150409090748.gif)

## How to setup

### 1. Install PhantomJS

Poltergeist requires PhantomJS. See https://github.com/teampoltergeist/poltergeist#installing-phantomjs

```
brew install phantomjs
```

### 2. Bundle install

```
bundle install
```

### 3. Set up initial data

```
bin/rake db:seed
```

### 4. Run Rails server

```
rails s
```

### 5. Open browser

```
open http://localhost:3000
```

## How to run test

```
bin/rspec
```

## License

MIT license.
