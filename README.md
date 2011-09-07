# flickpapr — Randomly choose an “interesting” flickr photo for desktop wallpaper.

AUTHOR:  [Micah Elliott](http://MicahElliott.com)
LICENSE: [WTFPL](http://sam.zoy.org/wtfpl/)

## About Flickr Interestingness
Flickr’s [interestingness heuristics](http://www.flickr.com/explore/interesting/)
generate some lovely images. People visit every day and just click “Refresh”
to see page after page of these. BUT… it’s much better just have these
delivered right to your desktop as a wallpaper. Well, maybe you should just
have pics of your cats going there, but these can be a little more
inspirational. They shouldn’t get too jealous.

There’s a danger in coming to flickr every day to peruse interesting pics. So
this little script recipe just puts one at random on your desktop every so
often. It also puts a desktop notification describing the photo and location.

## Usage

Note that there’s a new-ish limitation in Ubuntu that disables updating
desktop things via `cron`. The `cronX` wrapper script works around this, so use
it to call `flickpapr`.

Put this in your crontab for rotation (`crontab -e`):
    @hourly .../cronX.zsh .../flickpapr.rb

## Present shortcomings and areas for improvement

* Just dumps a file file into $TMPDIR with no cleanup.
* Doesn't track any attribution: URL, photographer, location, etc.
  (could use ImageMagick to superimpose)
* Image gets stretched to desktop width.
* Assumes JPG.
* Only works for GNOME.
* Doesn't use Flickr API; DOM/CDNs susceptible to change.
