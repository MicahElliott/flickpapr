#! /usr/bin/env ruby

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

# Set the extended filesystem attributes.
attrs = Xattr.new(jpg_path)
attrs['user.location'] = location if ! location.empty?
attrs['user.title'] = title
attrs['user.url'] = about_uri

#puts about_uri
#puts jpg_path
#puts title, location

# Using `dump` to avoid extra quotes (punctuation) going to shell.
`notify-send #{title.dump} #{location.dump}`

# GConfTool is the programmatic means to control GNOME’s wallpaper.
# Substitute with your OS’s equivalent.
`/usr/bin/gconftool -t str -s /desktop/gnome/background/picture_filename #{jpg_path}`
