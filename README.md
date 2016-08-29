# svgeez

**A Ruby gem for automatically generating an SVG sprite from a folder of SVG icons.**

[![Gem Version](https://badge.fury.io/rb/svgeez.svg)](https://badge.fury.io/rb/svgeez)
[![Build Status](https://travis-ci.org/jgarber623/svgeez.svg?branch=master)](https://travis-ci.org/jgarber623/svgeez)
[![Code Climate](https://codeclimate.com/github/jgarber623/svgeez/badges/gpa.svg)](https://codeclimate.com/github/jgarber623/svgeez)
[![Test Coverage](https://codeclimate.com/github/jgarber623/svgeez/badges/coverage.svg)](https://codeclimate.com/github/jgarber623/svgeez/coverage)

If you're using an [SVG](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics) icon system in your Web projects, svgeez can help speed up your workflow by automating the SVG sprite generation process. Simply run svgeez alongside your existing project (or integrate it into your current build system); add, edit, or delete SVG files from a folder; and marvel as svgeez generates a single SVG sprite file ready for inclusion in your user interface.

_For more on why SVG sprites are the bee's knees as far as icon systems go, give Chris Coyier's original post, [Icon System with SVG Sprites](https://css-tricks.com/svg-sprites-use-better-icon-fonts/), and his follow-up article, [SVG \`symbol\` a Good Choice for Icons](https://css-tricks.com/svg-symbol-good-choice-icons/) a read-through._

## Key Features

- Provides a simple [CLI](https://en.wikipedia.org/wiki/Command-line_interface) for generating SVG sprite files.
- Easily integrates with existing projects (e.g. alongside a Rails application using [Foreman](https://github.com/ddollar/foreman)).
- Optionally optimizes SVG files with [SVGO](https://github.com/svg/svgo/).

## Getting Started

Before installing and using svgeez, you'll want to have Ruby 2.2.5 installed on your computer. There are plenty of ways to go about this, but my preference is [rbenv](https://github.com/sstephenson/rbenv). If you're developing on a Mac and using [Homebrew](http://brew.sh/), installing rbenv is [super easy](https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x).

svgeez _might_ work with other versions of Ruby, but it's developed in 2.2.5.

## Installation

If you're using Bundler, add svgeez to your project's Gemfile:

```rb
ruby '2.2.5'

source 'https://rubygems.org' do
  gem 'svgeez'
end
```

…and hop over to your command prompt and run…

`$ bundle`

You may also install svgeez directly by issuing the following command:

`$ gem install svgeez`

## Usage

svgeez is a command line program with several useful subcommands. From the root of your project, run `svgeez -h` for a complete list of commands.

### The `build` command

You can manually generate an SVG sprite from a folder of SVGs with the `build` command which takes two options, a path to your folder of individual SVGs and a path to the desired destination folder. _These paths must be different!_

A basic example:

```sh
$ svgeez build --source ~/Sites/sixtwothree.org/images/icons --destination ~/Sites/sixtwothree.org/images/icons.svg
```

The above example will combine all SVG files in `~/Sites/sixtwothree.org/images/icons` into a single SVG sprite file (`icons.svg`) in `~/Sites/sixtwothree.org/images`.

#### Options and Defaults

|Option|Description|
|---|---|
|`-s`<br>`--source`|Path to the folder of source SVGs (defaults to `./_svgeez`).|
|`-d`<br>`--destination`|Path to the destination file or folder (defaults to `./svgeez.svg`)|
|`--with-svgo`|Optimize source SVGs with [SVGO](https://github.com/svg/svgo/) before sprite generation (non-destructive)|

### The `watch` command

The `watch` command takes the same arguments as the `build` command but uses the [Listen gem](https://github.com/guard/listen) to observe changes in the source folder.

Tweaking the example from above:

```sh
$ svgeez watch --source ~/Sites/sixtwothree.org/images/icons --destination ~/Sites/sixtwothree.org/images/icons.svg
```

svgeez will remaing running, watching for new, removed, or updated SVG files in the provided source folder. As SVG files are added, deleted, or modified in the source folder, svgeez will keep pumping out updated SVG sprite files to the destination folder.

### Optimizing generated files with SVGO

If you have the excellent [SVGO](https://github.com/svg/svgo/) utility installed on your system (and the `svgo` command is available in your PATH), you can use the `--with-svgo` option and optimize source SVGs before generating the sprite file.

```sh
$ svgeez build --source ~/Sites/sixtwothree.org/images/icons --destination ~/Sites/sixtwothree.org/images/icons.svg --with-svgo
```

Optimizing source SVG files with SVGO is done on-the-fly and the original files are left intact. Depending on the number of individual SVG files in the source folder, using the `--with-svgo` option can add considerable time to SVG sprite generation.

## Working with SVG sprites

Within generated SVG sprite files, each icon is wrapped in a `<symbol>` element and assigned an `id` attribute with a value combining the SVG sprite's file name and the original, individual icon's file name.

For example, a file named `menu.svg` in `~/Sites/sixtwothree.org/images/icons` will be assigned an `id` value of `icons-menu`.

```svg
<symbol id="icons-menu" viewBox="0 0 32 32">
    <path d="…"/>
</symbol>
```

**Note:** Single quotes, double quotes, and spaces in individual icon file names will be replaced with dashes. This _could_ result in two `<symbol>`s with the same `id` attribute value. Keep this in mind when naming your source icon files.

### Markup

To use an svgeez-generated SVG sprite file, first include the file's contents at the bottom of your HTML page.

In a Rails 4 application:

```erb
<body>
    <!-- Your page’s awesome content goes here! -->

    <%= raw Rails.application.assets.find_asset('icons.svg') %>
</body>
```

Or, with PHP:

```html
<body>
    <!-- Your page’s awesome content goes here! -->

    <?php include_once('path/to/icons.svg'); ?>
</body>
```

Next, wherever you want to include an icon in your user interface, use HTML similar to the following, replacing the identifier `#icons-menu` with a value corresponding to the ID of the `<symbol>` in the relevant SVG sprite file:

```html
<svg><use xlink:href="#icons-menu"></svg>
```

A more complete example from a Rails 4 application's layout file:

```erb
<body>
    <button>
        <svg><use xlink:href="#icons-menu"></svg>
        Menu
    </button>

    <%= raw Rails.application.assets.find_asset('icons.svg') %>
</body>
```

In this example, the contents of the svgeez-generated SVG sprite file is included on every page and isn't terribly cacheable. How onerous this is depends on the size of your icon system.

For smaller icon sets, this may be an acceptable balance of user and developer needs. For larger icon sets, you may want to investigate more advanced techniques for loading and caching an SVG sprite file (perhaps with [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Storage/LocalStorage)…?)

### Styling embedded icons

Icons embedded with the inline `<use>` technique will inherit their fill color from the nearest parent's `color` value, but this can be overriden with CSS:

```css
button {
    color: #333;
}

button svg {
    fill: #c00; // Absent this declaration, the icon’s fill color would be #333
}
```

## Improving svgeez

You want to help make svgeez better? Hell yeah! I like your enthusiasm. For more on how you can help, check out [CONTRIBUTING.md](https://github.com/jgarber623/svgeez/blob/master/CONTRIBUTING.md).

### Donations

If diving into Ruby isn't your thing, but you'd still like to support svgeez, consider making a donation! Any amount—large or small—is greatly appreciated. As a token of my gratitude, I'll add your name to the [Acknowledgments](#acknowledgments) below.

[![Donate via Square Cash](https://img.shields.io/badge/square%20cash-$jgarber-28c101.svg)](https://cash.me/$jgarber)
[![Donate via Paypal](https://img.shields.io/badge/paypal-jgarber-009cde.svg)](https://www.paypal.me/jgarber)

## Acknowledgments

svgeez benefited greatly from the hard work done by the folks working on the following projects:

- [Jekyll](https://github.com/jekyll/jekyll)
- [jekyll-watch](https://github.com/jekyll/jekyll-watch)
- [Mercenary](https://github.com/jekyll/mercenary)
- [Listen](https://github.com/guard/listen)

Additionally, Chris Coyier's [CSS Tricks](https://css-tricks.com/) posts linked above got me interested in SVG sprites.

Lastly, the sample icons in `spec/fixtures/icons` are from [Brent Jackson](https://github.com/jxnblk)'s [Geomicons Open](https://github.com/jxnblk/geomicons-open) icon set.

svgeez is written and maintained by [Jason Garber](https://github.com/jgarber623).

### Additional Contributors

- [Brett Wilkins](https://github.com/bwilkins)

## License

svgeez is freely available under the [MIT License](http://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
