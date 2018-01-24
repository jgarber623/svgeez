# svgeez

**A Ruby gem for automatically generating an SVG sprite from a folder of SVG icons.**

[![Gem](https://img.shields.io/gem/v/svgeez.svg?style=for-the-badge)](https://rubygems.org/gems/svgeez)
[![Downloads](https://img.shields.io/gem/dt/svgeez.svg?style=for-the-badge)](https://rubygems.org/gems/svgeez)
[![Build](https://img.shields.io/travis/jgarber623/svgeez/master.svg?style=for-the-badge)](https://travis-ci.org/jgarber623/svgeez)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/jgarber623/svgeez.svg?style=for-the-badge)](https://codeclimate.com/github/jgarber623/svgeez)
[![Coverage](https://img.shields.io/codeclimate/c/jgarber623/svgeez.svg?style=for-the-badge)](https://codeclimate.com/github/jgarber623/svgeez/code)

If you're using an [SVG](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics) icon system in your Web projects, svgeez can help speed up your workflow by automating the SVG sprite generation process. Run svgeez alongside your existing project (or integrate it into your current build system); add, edit, or delete SVG files from a folder; and marvel as svgeez generates a single SVG sprite file ready for inclusion in your user interface.

_For more on why SVG sprites are the bee's knees as far as icon systems go, give Chris Coyier's original post, [Icon System with SVG Sprites](https://css-tricks.com/svg-sprites-use-better-icon-fonts/), and his follow-up article, [SVG \`symbol\` a Good Choice for Icons](https://css-tricks.com/svg-symbol-good-choice-icons/) a read-through._

## Key Features

- Provides a [CLI](https://en.wikipedia.org/wiki/Command-line_interface) for generating SVG sprite files.
- Integrates with existing projects (e.g. alongside a Rails application using [Foreman](https://github.com/ddollar/foreman)).
- Optionally optimizes SVG sprite file with [SVGO](https://github.com/svg/svgo).

## Getting Started

Before installing and using svgeez, you'll want to have Ruby 2.2.9 (or newer) installed on your computer. There are plenty of ways to go about this, but my preference is [rbenv](https://github.com/sstephenson/rbenv). If you're developing on a Mac and using [Homebrew](http://brew.sh), installing rbenv is [super easy](https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x).

svgeez _might_ work with other versions of Ruby, but it's developed in 2.5.0 and automatically tested against 2.2.9, 2.3.6, 2.4.3, and 2.5.0 by [Travis CI](https://travis-ci.org/jgarber623/svgeez).

## Installation

If you're using Bundler, add svgeez to your project's Gemfile:

```rb
ruby '2.5.0'

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
|`--with-svgo`|Optimize SVG sprite file with [SVGO](https://github.com/svg/svgo)|

### The `watch` command

The `watch` command takes the same arguments as the `build` command but uses the [Listen gem](https://github.com/guard/listen) to observe changes in the source folder.

Tweaking the example from above:

```sh
$ svgeez watch --source ~/Sites/sixtwothree.org/images/icons --destination ~/Sites/sixtwothree.org/images/icons.svg
```

svgeez will remaing running, watching for new, removed, or updated SVG files in the provided source folder. As SVG files are added, deleted, or modified in the source folder, svgeez will pump out updated SVG sprite files to the destination folder.

### Preparing SVG files for svgeez

svgeez works best with well-organized SVG files. If you're using tools like Sketch or Adobe Illustrator, your source SVG files _may_ contain unnecessary cruft like comments and editor-specific attributes. svgeez will do its best to work with source SVG files, but as a general rule it's good practice to make sure that the SVG files exported from your editor are as concise as possible.

The first section of Jayden Seric's post, [How to optimize SVG](http://jaydenseric.com/blog/how-to-optimize-svg), offers some helpful advice on optimizing SVGs prior to exporting from editing software.

### Optimizing generated files with SVGO

If you have the excellent [SVGO](https://github.com/svg/svgo) utility installed on your system (and the `svgo` command is available in your PATH), you can use the `--with-svgo` option and optimize the generated sprite file.

```sh
$ svgeez build --source ~/Sites/sixtwothree.org/images/icons --destination ~/Sites/sixtwothree.org/images/icons.svg --with-svgo
```

Depending on the number of individual SVG files in the source folder, using the `--with-svgo` option can add considerable time to SVG sprite generation.

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

In a Rails 4.1.x or lower application:

```erb
<body>
    <!-- Your page’s awesome content goes here! -->

    <%= raw Rails.application.assets.find_asset('icons.svg') %>
</body>
```

In a Rails 4.2.x or 5 application:

```erb
<body>
    <!-- Your page’s awesome content goes here! -->

    <%= raw Rails.application.assets_manifest.find_sources('icons.svg').first %>
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

A more complete example from a Rails 4.1.x or lower application's layout file:

```erb
<body>
    <button>
        <svg><use xlink:href="#icons-menu"></svg>
        Menu
    </button>

    <%= raw Rails.application.assets.find_asset('icons.svg') %>
</body>
```

A more complete example from a Rails 4.2.x or 5 application's layout file:

```erb
<body>
    <button>
        <svg><use xlink:href="#icons-menu"></svg>
        Menu
    </button>

    <%= raw Rails.application.assets_manifest.find_sources('icons.svg').first %>
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

[![Donate via Square Cash](https://img.shields.io/badge/square%20cash-$jgarber-28c101.svg?style=for-the-badge)](https://cash.me/$jgarber)
[![Donate via Paypal](https://img.shields.io/badge/paypal-jgarber-009cde.svg?style=for-the-badge)](https://www.paypal.me/jgarber)

## Acknowledgments

svgeez benefited greatly from the hard work done by the folks working on the following projects:

- [Jekyll](https://github.com/jekyll/jekyll)
- [jekyll-watch](https://github.com/jekyll/jekyll-watch)
- [Mercenary](https://github.com/jekyll/mercenary)
- [Listen](https://github.com/guard/listen)

Additionally, Chris Coyier's [CSS Tricks](https://css-tricks.com) posts linked above got me interested in SVG sprites.

Lastly, the sample icons in `spec/fixtures/icons` are from [Brent Jackson](https://github.com/jxnblk)'s [Geomicons Open](https://github.com/jxnblk/geomicons-open) icon set.

svgeez is written and maintained by [Jason Garber](https://github.com/jgarber623).

### Additional Contributors

- [Brett Wilkins](https://github.com/bwilkins)
- [danny](https://github.com/f96q)
- [Denis Hovart](https://github.com/dhovart)
- [Desmond Sadler](https://github.com/dezman)

## License

svgeez is freely available under the [MIT License](http://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
