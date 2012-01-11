# flickpapr — Randomly choose an “interesting” flickr photo for desktop wallpaper.

AUTHOR:  [Micah Elliott](http://MicahElliott.com)
LICENSE: [WTFPL](http://sam.zoy.org/wtfpl/)

## About Flickr Interestingness

Flickr’s [interestingness heuristics](http://www.flickr.com/explore/interesting/)
generate some lovely images. People visit every day and just click “Refresh”
to see page after page of these. BUT… it’s much better just have these
delivered right to your desktop as a wallpaper. Well, maybe you should just
have pics of your cats going there, but these can be a little more
inspirational. The cats shouldn’t get too jealous; they’ll love all the bugs!

There’s a danger in coming to flickr every day to peruse interesting pics. And
anyway, they’re too small there. So this little script recipe just puts one at
random on your desktop every so often. It also puts a desktop notification
describing the photo and location.

Some key information is part of each pic. You’ll want to know its original
URL, who took it, and sometimes you’ll be able to find geo-location info. This
is displayed and stowed away in extended filesystem attributes, which can
later be queried.

I recommend going through these once a month or so to select some faves for
future desktops BGs.

## Dependencies

* GNOME (but adaptable to whatever scriptable desktop manipulator).
* Ruby
* Nokogiri gem (just made it too easy to not depend on flickr API).
* ffi-xattr, ffi gems (for creating xattrs database)

## Usage

Note that there’s a new-ish limitation in Ubuntu that disables updating
desktop things via `cron`. The `cronX` wrapper script (included) works around
this, so use it to call `flickpapr`.

Put something like these (choose one) in your crontab for rotation (`crontab
-e`):

    MAILTO = you@example.com

    @hourly .../cronX.zsh .../flickpapr.rb

    # Pomodoro productivity!
    0,30 * * * * ...

    # Firehose of distraction.
    0-55/5 * * * * ...

Later on, you can visit your local collection to query and browse them.

    % cd ~/tmp/flickr
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

## Present shortcomings and areas for improvement

* Just dumps a file into `$TMPDIR` with no cleanup.
* Should discard images that are too big so as not to fill your disk!
* Image gets stretched to desktop width, so top/bottom often cut off.
* Assumes JPG (99% safe).
* Only works for GNOME (gconftool).
* Doesn’t use Flickr API, so DOM/CDNs susceptible to change.
* So simple it might not be worth turning into an installable gem.
* Could use [Daemons](https://github.com/mikehale/daemons) to avoid cron
  klugery.
* Haven’t researched what “screensaver” apps (cf. “wallpapers”) are out there
  that could also use these images.
* No way to “like” a pic in real time; have to visit dir to select faves.

## Surprises

_Why not just use the flickr API?_ Just wanted to minimize dependencies, and
the scraping a la nokogiri is really simple.

_Why not just use EXIF metadata for storing pic info?_ EXIF data is noisy,
mostly not wanted, and difficult to query. Flickr doesn’t do much (anything?)
with storing the real geolocation data there anyway.
