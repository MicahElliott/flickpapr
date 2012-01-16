#! /usr/bin/env ruby
# encoding: UTF-8

# flickpapr — Randomly choose an “interesting” flickr photo for desktop wallpaper.
#
# AUTHOR:  Micah Elliott http://MicahElliott.com
# LICENSE: WTFPL http://sam.zoy.org/wtfpl/
#
# Any output from this script will go to cron, and subsequently into
# email. So you probably want to keep it silent.

require 'nokogiri'
require 'open-uri'
require 'ffi-xattr'

# Debug cron here if you have issues.
##puts $LOAD_PATH

dir = File.expand_path(File.dirname(__FILE__))
icon    = dir + "/flickr-icon.png"
icon_bw = dir + "/flickr-icon-bw.png"

int_table = 'http://www.flickr.com/explore/interesting/7days/'
doc = Nokogiri::HTML( open(int_table) )

orig = '/sizes/o/in/photostream/'  # o => original
# Get the first pic in the page’s table.
# /photos/micke33/6108863245/
base = doc.css('.TwentyFour td.Photo a').first.attributes['href'].value

# http://www.flickr.com/photos/superpepelu/6097194845/sizes/o/in/photostream/
largest_uri = 'http://flickr.com' + base + orig

doc2 = Nokogiri::HTML( open(largest_uri) )
# e.g. http://farm7.static.flickr.com/6074/6116492734_36e7ec6efc_b.jpg
pic = doc2.css('#allsizes-photo img').first.attributes['src'].value
title = doc2.title.split(' | ')[1]

# About info.
about_uri = 'http://flickr.com' + base
# Uncomment to have each URL show up in your cron email (as thumbnail in gmail).
##puts about_uri
about_doc = Nokogiri::HTML( open(about_uri) )
# Keep the string `dump`-safe, avoiding nil.
location = ""
location_tree = about_doc.css('a#photoGeolocation-storylink')
if ! location_tree.empty?
  location = location_tree.first.children.first.content.strip
  # NOTE: this replaced whitespace is non-ascii (nbsp?)!
  location.gsub! / /, " "
  # e.g. "Little Stoke, Bristol, England, GB"
end

jpg = File.split(pic).last
# You do set TMPDIR, don’t you? Hmm, let's not rely on TMPDIR being set.
archive = "#{ENV['HOME']}/tmp/flickr"
# Not going to attempt to sensibly name the photo file.
jpg_path = "#{archive}/#{jpg}"
FileUtils.mkdir_p archive
`wget --quiet '#{pic}' -O #{jpg_path}`

# Discard and abort if dimensions not panoramic.
w, h = `identify #{jpg_path}`.gsub(/.* (\d+x\d+) .*/, '\1').strip.split('x').map!(&:to_f)
if w / h < 1.2
  # Would be better to do re-fetch loop, but doing the simpler thing.
  `notify-send -i #{icon_bw} ":( Dimensions unsuitable" "Wait for next cycle"`
  ##puts about_uri, w, h
  File.delete jpg_path
  exit 1
end

# Shrink if too big.
# I’ve witnessed large wallpaper files crashing GNOME.
max_width = 2000 # wiggle room to crop to 1920
if w > max_width
  ##puts "Shrinking huge image #{jpg_path} to #{max_width}."
  huge_path = jpg_path+".huge"
  File.rename jpg_path, huge_path
  `convert -scale #{max_width}x #{huge_path} #{jpg_path}`
  File.delete huge_path
end

# Set the extended filesystem attributes.
attrs = Xattr.new(jpg_path)
attrs['user.location'] = location if ! location.empty?
attrs['user.title'] = title
attrs['user.url'] = about_uri

# Might want to someday display filename if popup becomes clickable.
title_and_fname = title.dump + " (#{jpg_path})"
##puts about_uri, jpg_path, title, location, title_and_fname


# Using `dump` to avoid extra quotes (punctuation) going to shell.
# No sense in displaying URI or filename since can’t copy from NS popup.
`notify-send -i #{icon} #{title.dump} #{location.dump}`

# GConfTool is a programmatic means to control GNOME’s wallpaper.
# Not sure why this is such a heavy op; maybe due to two large monitors.
`/usr/bin/gconftool -t str -s /desktop/gnome/background/picture_filename #{jpg_path}`
