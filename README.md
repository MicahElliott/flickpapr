# flickpapr — Randomly choose an “interesting” flickr photo for desktop wallpaper.

* AUTHOR:  [Micah Elliott](http://MicahElliott.com)
* LICENSE: [WTFPL](http://sam.zoy.org/wtfpl/)

## About Flickr Interestingness

Flickr’s [interestingness heuristics](http://www.flickr.com/explore/interesting/)
generate some lovely images. People visit every day and just click “Refresh”
to see page after page of these. BUT… it’s much better to just have these
delivered right to your desktop as a wallpaper. Well, maybe you should just
have pics of your cats going there, but these can be a little more
inspirational. The cats shouldn’t get too jealous; they’ll love all the birds
and bugs! This little script recipe just puts an image at random onto your
desktop every so often. It also puts a desktop notification describing the
photo and location.

![Flickpapr Screenshot](https://github.com/MicahElliott/flickpapr/raw/master/screenshots/montignano.jpg)
<br />

Some key information is part of each pic. You’ll want to know its original
URL, who took it, and sometimes you’ll be able to find geo-location info. This
is displayed and stowed away in extended filesystem attributes, which can
later be queried.

I presently run Flickpapr on [i3](https://i3wm.org/), but used to run it in
Gnome (hopefully it still does), and want it to work with any DE.

I recommend going through these once a month or so to select some faves for
future, more permanent desktops BGs. There are several
[file managers (photo browsers)](http://www.tuxarena.com/2011/06/20-file-managers-for-ubuntu/)
to consider. There are also photo editors, such as
[shotwell](http://yorba.org/shotwell/) if you don’t do gimp.

## Install
Git it:

    % cd src
    % git clone github.com/MicahElliott/flickpapr
    % cd flickpapr

Install dependencies, and run:

    % ./flickpapr

### Dependencies

* Ruby (v1.8.7+)
* [Nokogiri](http://nokogiri.org/) gem (just made it too easy to not depend on
  flickr API).
* ImageMagick, to identify/discard/shrink large/malproportioned images.
* libnotify-bin, for `notify-send` popup (but could use alternative)
* [ffi-xattr](https://github.com/jarib/ffi-xattr), ffi gems, for creating
  xattrs database (optional)
* [Dunst](https://github.com/knopwob/dunst) notification daemon (optional)
* `xsel` to add image url to clipboard (optional)

### Arch

    % yaourt -S ruby ruby-nokogiri libnotify feh imagemagick daemonize dunst

(AUR PKGBUILD coming soon.)

### CentOS

    % yum install ruby rubygem-nokogiri ImageMagick feh libnotify xsel

### Ubuntu

    % aptitude install imagemagick libnotify-bin ruby
    % gem install nokogiri ffi-xattr

### As a Daemon
If you’ve already installed
[daemonize](http://software.clapper.org/daemonize/) (trival on Arch), you can
run `./flickd`.

Or install it:

    % git clone http://github.com/bmc/daemonize
    % cd daemonize
    % make
    % sudo make install
    % cd -
    % ./flickd

(Systemd support coming soon.)

## Usage
Later on, you can visit your local collection to query and browse them.

    % cd $TMPDIR/flickr
    % getfattr -n user.location *.jpg
    # file: 6667763073_e3271a96e6_o.jpg
    user.location="Velence, Fejér, HU"
    # file: 6672593991_b0cf581e34_o.jpg
    user.location="Kijkduin, The Hague, ZH, NL"
    ...
    % nautilus .
    % mv {x,y,z}.jpg ~/Photos/wallpapers

BTW, You’ll probably want to have semi-transparent terminals to get the most out
your wallpapers.

## As a Daemon
See `flickd` for running as a daemon (via `daemonize`), and
`flickpapr.service` for running with Systemd.

## Present shortcomings

* Just dumps a file into `$TMPDIR` with no cleanup.
* Image gets stretched to desktop width, so top/bottom sometimes cut off.
* Assumes JPG (99% safe).
* Uses `feh` as background setter (used to use `gconftool`). Could use
  `nitrogen` or some other more general wallpaper tool.
* Doesn’t use Flickr API, so DOM/CDNs susceptible to change (but hasn’t
  changed in several years).
* So simple it might not be worth turning into an installable gem.
* Could use [Daemons](https://github.com/mikehale/daemons) to avoid cron
  klugery.
* Haven’t researched what “screensaver” apps (cf. “wallpapers”) are out there
  that could also use these images.
* No way to “like” a pic in real time; have to visit dir to select faves.
* Not obvious which image file corresponds to the current wallpaper.
* Should create an AUR PKGBUILD

## New feature ideas

* Use Zsh’s `attr` module to make clean query interface
* Use Zenity (or some other popup/shell-gui tool) for clickable URLs
* Unicode support
* Cycle through to grab another image if dimensions unsuitable
* Determine proportions (check for non-panoramicity) before downloading
* Darken/mask image to give less attention
* Logging

## Surprises

_Why not just use the flickr API?_ Just wanted to minimize dependencies, and
the scraping a la nokogiri is really simple.

_Why not just use EXIF metadata for storing pic info?_ EXIF data is noisy,
mostly not wanted, and difficult to query. Flickr doesn’t do much (anything?)
with storing the real geolocation data there anyway.

## Tangentially related resources

Shown in screenshot:

* [Orp Font](https://github.com/MicahElliott/Orp-Font)
* [Balance Zsh Prompt](https://gist.github.com/720293)
