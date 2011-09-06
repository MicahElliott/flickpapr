#! /usr/bin/env ruby

# flickpapr — Randomly choose an “interesting” flickr photo for desktop wallpaper.
#
# AUTHOR:  Micah Elliott http://MicahElliott.com
# LICENSE: WTFPL http://sam.zoy.org/wtfpl/
#
# Flickr’s about interestingness:
# http://www.flickr.com/explore/interesting/
#
# There’s a danger in coming to flickr every day to peruse these. So
# this recipe just puts one at random on your desktop every hour.
#
# Put this in your crontab for rotation:
#   @hourly /path/to/wallpaper-flickr.rb
#
# Shortcomings:
# * Just dumps a file file into $TMPDIR with no cleanup.
# * Doesn't track any attribution: URL, photographer, location, etc.
#   (could use ImageMagick to superimpose)
# * Image gets stretched to desktop width.
# * Assumes JPG.
# * Only works for GNOME.
# * Doesn't use Flickr API; DOM/CDNs susceptible to change.
#
# ...but good enough for now.

require 'nokogiri'
require 'open-uri'

int_table = 'http://www.flickr.com/explore/interesting/7days/'
doc = Nokogiri::HTML( open(int_table) )

orig = '/sizes/o/in/photostream/'  # o => original
# /photos/micke33/6108863245/
base = doc.css('.TwentyFour td.Photo a').first.attributes['href'].value

# http://www.flickr.com/photos/superpepelu/6097194845/sizes/o/in/photostream/
int_uri = 'http://flickr.com' + base + orig
#puts int_uri

doc2 = Nokogiri::HTML( open(int_uri) )
# http://farm7.static.flickr.com/6074/6116492734_36e7ec6efc_b.jpg
pic = doc2.css('#allsizes-photo img').first.attributes['src'].value
#puts pic
jpg = File.split(pic).last
archive = "#{ENV['TMPDIR']}/flickr"
jpg_path = "#{archive}/#{jpg}"
FileUtils.mkdir_p archive
`wget --quiet '#{pic}' -O #{jpg_path}`

# GConfTool is the programmatic means to control GNOME’s wallpaper.
# Substitute with your OS’s equivalent.
`gconftool -t str -s /desktop/gnome/background/picture_filename #{jpg_path}`