# Contributing to svgeez

I'd love to have your help improving svgeez! If you'd like to pitch in, you can do so in a number of ways:

1. Look through open [Issues](https://github.com/jgarber623/svgeez/issues).
1. Review any open [Pull Requests](https://github.com/jgarber623/svgeez/pulls).
1. [Fork svgeez](#get-set-up-to-contribute) and fix an open Issue or add your own feature.
1. File new Issues if you have a good idea or see a bug and don't know how to fix it yourself. _Only do this after you've made sure the behavior or problem you're seeing isn't already documented in an open Issue._

I definitely appreciate your interest in (and help improving) svgeez. Thanks!

## Installation

svgeez is written in [Ruby](https://www.ruby-lang.org/en/) (version 2.2.6) and development dependencies are managed using the [Bundler](http://bundler.io/) gem. [Travis CI builds](https://travis-ci.org/jgarber623/svgeez) use Ruby 2.2.6, 2.3.4, and 2.4.1.

I manage Ruby versions with [rbenv](https://github.com/rbenv/rbenv). I'd recommend you do the same or use a similar Ruby version manager ([chruby](https://github.com/postmodern/chruby/) or [RVM](https://rvm.io/) come to mind). Once you've installed Ruby 2.2.6 using your method of choice, install the project's gems by running:

```sh
bundle install
```

…from the root of the project.

In order for the test suite to run properly, [SVGO](https://github.com/svg/svgo/) must be installed (and the `svgo` command must be available in your PATH). This is most easily achieved by installing [Node.js](https://nodejs.org/) and running:

```sh
npm install -g svgo
```

## Get set up to contribute

Contributing to svgeez is pretty straightforward:

1. Fork the svgeez repo and clone it.
1. Install development dependencies as outlined [above](#installation).
1. Create a feature branch for the issue or new feature you're looking to tackle: `git checkout -b your-descriptive-branch-name`.
1. _Write some code!_
1. Build (`bundle exec rake build`) and install (`bundle exec rake install`) your updated code.
1. If your changes would benefit from testing, add the necessary tests and verify everything passes by running `bundle exec rake`.
1. Commit your changes: `git commit -am 'Add some new feature or fix some issue'`.
1. Push the branch to your fork of svgeez: `git push origin your-descriptive-branch-name`.
1. Create a new Pull Request and I'll give it a look!

## Code Style

Code styles are like opinions: Everyone's got one and yours is better than mine. Here's how svgeez should be written:

- Use two-space indentation in Ruby.
- No trailing whitespace and blank lines should have whitespace removed.
- Prefer single quotes over double quotes unless interpolating.
- Follow the conventions you see in the existing source code as best as you can.

svgeez's formatting guidelines are defined in the `.editorconfig` file which uses the [EditorConfig](http://editorconfig.org/) syntax. There are [a number of great plugins for a variety of editors](http://editorconfig.org/#download) that utilize the settings in the `.editorconfig` file. EditorConfig takes the hassle out of syntax-specific formatting.

Additionally, [Rubocop](https://github.com/bbatsov/rubocop) can be used to help identify possible trouble areas in your code. Run `bundle exec rake rubocop` to generate Rubocop's static code analysis report.

Your bug fix or feature addition won't be rejected if it runs afoul of any (or all) of these guidelines, but following the guidelines will definitely make everyone's lives a little easier.
